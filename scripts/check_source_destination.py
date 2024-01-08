"""
staging 环境 zerocap_fireblock_new 数据库

检查 transactions history 表中 source_address 为空的数据
通过 tx_hash 获取链上数据, 分为以下几种情况：
1.目标地址不一致;
2.目标地址一致：
    a. 有多个源地址：查询 addressess 表，那个地址存在就用那个地址，如果都不存在，记录为错误数据;
    b. 只有一个源地址：直接使用，不需要查询 addresses 表;
    c. 如果有可用的源地址，都需要记录下更新 SQL;
3.从链上拿不到数据;
4.有多个源地址(记录日志即可);
5.查询过程中发生错误的数据;
"""

import sys
import time
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

from config.config import config
from utils.logger import logger
from sqlalchemy import create_engine
from google.protobuf.json_format import MessageToDict
from utils.get_transaction import GetTransactionByTxHash
from utils.get_transaction_by_tokenview import get_transaction_by_tx_hash_from_trx, get_transaction_by_tx_hash_from_ltc, \
    get_transaction_by_tx_hash_from_sol

transaction = GetTransactionByTxHash()

POSTGRES_ADDRESS = config['CONFIG_POSTGRES']['HOST']
POSTGRES_PORT = config['CONFIG_POSTGRES']['PORT']
POSTGRES_USERNAME = config['CONFIG_POSTGRES']['USER']
POSTGRES_PASSWORD = config['CONFIG_POSTGRES']['PASSWORD']
POSTGRES_DBNAME = 'zerocap_uat'
postgres_str = ('postgresql://{username}:{password}@{ipaddress}:{port}/{dbname}'.format(
    username=POSTGRES_USERNAME,
    password=POSTGRES_PASSWORD,
    ipaddress=POSTGRES_ADDRESS,
    port=POSTGRES_PORT,
    dbname=POSTGRES_DBNAME))

# postgres_str = ('postgresql://{username}:{password}@{ipaddress}:{port}/{dbname}'.format(
#     username="postgres",
#     password="3?zn?aBCQkKSn",
#     ipaddress="54.66.161.26",
#     port="5432",
#     dbname="zerocap_fireblock_new"))
print(postgres_str)
conn = create_engine(postgres_str)


def get_txn_data(tx_hash_list=None):
    sql = """select asset_id, amount, fee_currency, tx_id, tx_hash, source_address, destination_address
             from transactionshistory where status='COMPLETED' and tx_hash != '' and source_address='None' 
             and asset_id in ('SOL');"""

    if tx_hash_list:
        sql = f"""select asset_id, amount, fee_currency, tx_id, tx_hash, source_address, destination_address
             from transactionshistory where status='COMPLETED' and tx_hash != '' and source_address='None' 
             tx_hash in '({','.join(tx_hash_list)})';"""

    result = conn.execute(sql).fetchall()
    return [dict(zip(res.keys(), res)) for res in result]


def get_address_data():
    # 获取 addresses 表中所有为 active 的地址
    sql = """select asset_id, lower(address) as address from addresses where status='active';"""
    result = conn.execute(sql).fetchall()
    return [{"asset_id": res[0], "address": res[1]} for res in result]


def check_data(data_list, address_list):
    no_data_from_chain = []  # 无法从链上获取数据
    different_destination_address = []  # 目标地址不一致
    identical_destination_address = []  # 目标地址一致
    many_source_address = []  # 有多个源地址
    many_source_address_not_exist = []  # 有多个源地址但都不在 addresses 表中
    error_data = []  # 发生异常的数据
    update_sql = "\n"
    update_sql_random = "\n"

    # blockchair api 请求有限制，每分钟 30 次
    # get_transaction 中有 8 个 blockchair 链，每分钟最多请求 3 次
    num = len(data_list)
    for index, data in enumerate(data_list, start=1):
        print(f"进度：{index}/{num}")
        try:

            if data['asset_id'] in ('DOT', 'LUNA'):
                result, _ = transaction.async_get_transcation(
                    asset_id=data['asset_id'], tx_hash=data['tx_hash'],
                    source_url='https://polkadot.webapi.subscan.io/api/scan/extrinsic')
            else:
                result, _ = transaction.async_get_transcation(
                    asset_id=data['asset_id'], tx_hash=data['tx_hash'])

            if result:
                chain_data = MessageToDict(result[0], including_default_value_fields=True, preserving_proto_field_name=True)
                source_address = chain_data['source_address']
                # 从链上获取的目标地址结果是列表，将所有的目标地址转为小写进行对比
                destination_address = [address.lower() for address in chain_data['destination_address']]
                if ("staking" in destination_address or "utility" in destination_address) and len(source_address) == 1:
                    update_sql += f"update transactionshistory set source_address='{source_address[0]}' where tx_id = '{data['tx_id']}';\n"
                    continue

                # 如果有多个 source address 的地址需要单独记录
                if len(source_address) > 1:
                    many_source_address.append({
                        "tx_id": data['tx_id'],
                        "asset_id": data['asset_id'],
                        "tx_hash": data['tx_hash'],
                        "source_address": source_address,
                    })

                # transactions history 表记录的 destination_address 包含在从链上获取的地址列表中
                if data['destination_address'].lower() in destination_address:
                    # 将源地址一致的数据记录下来
                    identical_destination_address.append({
                        'tx_id': data['tx_id'],
                        'asset_id': data['asset_id'],
                        'tx_hash': data['tx_hash'],
                        'source_address': source_address,
                        'destination_address': destination_address
                    })

                    # 目标地址一致，并且只有一个源地址, 直接记录 SQL;
                    if len(source_address) == 1:
                        update_sql += f"update transactionshistory set source_address='{source_address[0]}' where tx_id = '{data['tx_id']}';\n"
                        continue

                    # 有多个源地址, 需要根据 币种和地址 检查是否在 addresses 表中存在
                    # 如果多个源地址都存在, 随机使用一个
                    # 如果多个源地址都不存在, 随机使用一个
                    if len(source_address) > 1:
                        check_result = 0
                        for addr in source_address:
                            check = {'asset_id':data['asset_id'], "address": addr.lower()}
                            if check in address_list:
                                update_sql += f"update transactionshistory set source_address='{addr}' where tx_id = '{data['tx_id']}';\n"
                                check_result += 1
                                break

                        # 多个源地址都不在 addresses 表中, 随机一个
                        if check_result == 0:
                            many_source_address_not_exist.append({
                                'tx_id': data['tx_id'],
                                'asset_id': data['asset_id'],
                                'tx_hash': data['tx_hash'],
                                'source_address': source_address
                            })
                            update_sql_random += f"update transactionshistory set source_address='{source_address[0]}' where tx_id = '{data['tx_id']}';\n"

                # 链上 destination_address 与表中记录的 destination_address 不一致
                else:
                    different_destination_address.append({
                        'tx_id': data['tx_id'],
                        'asset_id': data['asset_id'],
                        'tx_hash': data['tx_hash'],
                        'source_address': source_address,
                        'history_destination_address': data['destination_address'],
                        'chain_destination_address': destination_address
                    })
            # 从链上没有获取到数据
            else:
                no_data_from_chain.append({
                    'tx_id': data['tx_id'],
                    'asset_id': data['asset_id'],
                    'tx_hash': data['tx_hash']
                })
            print(f"校验完成: tx_hash: {data['tx_hash']} asset_id: {data['asset_id']}")
        except Exception as e:
            error_data.append({
                'tx_id': data['tx_id'],
                'asset_id': data['asset_id'],
                'tx_hash': data['tx_hash'],
            })
            logger.error(f"tx_hash: {data['tx_hash']} asset_id: {data['asset_id']}, error: {e}")
        time.sleep(19)   # 请求频率有限制, 每分钟最多三次

    logger.info(f"无法从链上获取数据的记录共 {len(no_data_from_chain)} 条")
    logger.info(f"无法从链上获取数据的记录: {no_data_from_chain}")

    logger.info(f"与链上数据目标地址不一致的记录共 {len(different_destination_address)} 条")
    logger.info(f"与链上数据目标地址不一致的记录: {different_destination_address}")

    logger.info(f"与链上目标地址一致的记录共 {len(identical_destination_address)} 条")
    logger.info(f"与链上目标地址一致的记录: {identical_destination_address}")

    logger.info(f"有多条源地址的数据共 {len(many_source_address)} 条")
    logger.info(f"有多条源地址的数据: {many_source_address}")

    logger.info(f"有多个源地址都不在 addresses 表中存在的记录共 {len(many_source_address_not_exist)} 条")
    logger.info(f"有多个源地址都不在 addresses 表中存在的记录: {many_source_address_not_exist}")

    logger.info(f"需要更新的 SQL {update_sql}")

    logger.info(f"需要更新的随机 SQL {update_sql_random}")

    logger.info(f"发生异常的数据共 {len(error_data)} 条")
    logger.info(f"发生异常的数据: {error_data}")


def run():
    all_data = get_txn_data()  # 共 10898 条数据, XLM 的数据有 32 条
    address_list = get_address_data()
    print(len(all_data))

    check_data(all_data, address_list)  # 单线程跑


if __name__ == '__main__':
    print("started")
    s_time = time.time()
    run()
    print("runtime : ", time.time() - s_time)
    print("finished")


import os
import time
import grpc
import decimal
from datetime import datetime, timezone
import sys
import pathlib

from google.protobuf.json_format import MessageToDict

sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))

import pandas as pd
from peewee import fn, operator
from functools import lru_cache, reduce
from sqlalchemy import create_engine
import numpy as np

from db.models import Users, RiskAlarm, Individuals, DmaConfig, DmaLadderConfig
from db.models_hq import UsdtAud1m
from db.base_models import db
from utils.calc import Calc
from config.config import config, CHANNEL_DEFAULT_ORDER  # 项目 config
from db.models import Risk, Transactions, Fills
from utils.consts import TreasuryAssets, USDT_LIS
from utils.date_time_utils import timer, timestamp_to_time
from utils.logger import logger
from utils.zc_exception import ZCException
import zerocap_market_data_pb2_grpc
import zerocap_market_data_pb2
from utils.slack_utils import send_slack


# zerocap 数据库相关配置
POSTGRES_ADDRESS = config['CONFIG_POSTGRES']['HOST']
POSTGRES_PORT = config['CONFIG_POSTGRES']['PORT']
POSTGRES_USERNAME = config['CONFIG_POSTGRES']['USER']
POSTGRES_PASSWORD = config['CONFIG_POSTGRES']['PASSWORD']
POSTGRES_DBNAME = config['CONFIG_POSTGRES']['DATABASE']
postgres_str = ('postgresql://{username}:{password}@{ipaddress}:{port}/{dbname}'.format(
    username=POSTGRES_USERNAME,
    password=POSTGRES_PASSWORD,
    ipaddress=POSTGRES_ADDRESS,
    port=POSTGRES_PORT,
    dbname=POSTGRES_DBNAME))
conn = create_engine(postgres_str)


def get_history_price(asset_id, date, symbol_ticker, historical_prices=None,):
    if asset_id == 'USD':
        return 1

    if historical_prices is None:
        # 默认初始时间是 2010-01-01;
        start_time = "2010-01-01"
        now_time = datetime.now()
        now_time_str = now_time.strftime("%Y-%m-%d")
        ticker_list = [{"base_asset": asset_id, "quote_asset": "USD"}]

        historical_price_data = {
            "ticker_list": ticker_list,
            "time_range": [{"start_time": start_time, "end_time": now_time_str}],
            "source_list": CHANNEL_DEFAULT_ORDER,
            "is_all_source_price": False
        }
        logger.info(f"get_history_price: {historical_price_data}")
        zmd_host = os.environ.get('ZEROCAP_MONITOR_GRPC_ZMD')
        with grpc.insecure_channel(zmd_host) as channel:
            stub = zerocap_market_data_pb2_grpc.ZerocapMarketDataStub(channel)
            res = stub.GetTickerDailyHistoryPrice(
                zerocap_market_data_pb2.GetTickerDailyHistoryPriceRequestV1(**historical_price_data))

            if res.status != "success":
                logger.error(res)
                logger.error("get_history_price GetTickerDailyHistoryPrice failed!")
                raise Exception("get_history_price GetTickerDailyHistoryPrice failed!")

        res_result = res.result
        historical_prices_result = []
        for i in res_result:
            for j in i.price:
                historical_prices_result.append([j.base_asset, j.price, i.date])

        historical_prices_result.sort(key=lambda a: a[2])
        historical_prices = pd.DataFrame(historical_prices_result, columns=["base_asset", "price", "created_at"])
        historical_prices['created_at'] = pd.to_datetime(historical_prices['created_at'])
        historical_prices['price'] = historical_prices['price'].fillna('0')
        historical_prices['price'] = list(map(decimal.Decimal, map(str, historical_prices['price'].to_list())))

    price_df = historical_prices[(historical_prices.base_asset == asset_id) & (historical_prices.created_at <= date)]
    if len(price_df) != 0:
        return price_df.iloc[-1].price

    ticker = ''
    if historical_prices[historical_prices.base_asset == asset_id].empty:
        ticker = symbol_ticker.get(asset_id, "")
        price_df = historical_prices[(historical_prices.base_asset == ticker) & (historical_prices.created_at <= date)]
        if len(price_df) > 0: return price_df.iloc[-1].price

        logger.error(f"get history price failed:{asset_id}, date:{date}")
        return 0

    logger.error(f"get history price failed:{asset_id} {date}")
    # 数据库里没有当天相应的价格则用最新的价格
    return historical_prices[historical_prices.base_asset == ticker].iloc[-1].price


def get_symbol_ticker_from_gck():
    sql = """select base_asset_id, ticker from symbols where source='gck' and platform ='ems' and status='active';"""
    logger.info(
        {
            "type": "sql_record",
            "func": "get_symbol_ticker",
            "sql_name": "sql",
            "sql": sql
        }
    )
    res_data = conn.execute(sql).fetchall()
    return {res[0]: res[1].split("/")[0] for res in res_data}


def get_ticker_ems_symbols(assets):
    """处理 base_asset_id 和 ticker 前半部分不一致的问题，historical price 表是以 ticker 来记录的"""

    if len(assets) == 0:
        return ()

    assets = tuple({asset for asset in assets})
    sql = f"select ticker from ems_symbols where base_asset_id in {assets} " \
          f"union all SELECT ticker FROM symbols WHERE platform = 'ems' and base_asset_id in {assets};"

    logger.info(
        {
            "type": "sql_record",
            "func": "get_asset_ticker",
            "sql_name": "sql",
            "sql": sql
        }
    )
    res_data = conn.execute(sql).fetchall()

    ticker_list = []
    for res in res_data:
        ticker = res[0].split("/")
        if len(ticker) != 2:
            continue

        if ticker[0] not in ticker_list:
            ticker_list.append(ticker[0])
    return tuple(set(list(assets) + ticker_list))

@timer
def get_treasury_df(start_timestamp=None, end_timestamp=None):
    if start_timestamp is None:
        start_timestamp = 0
    if end_timestamp is None:
        end_timestamp = datetime.now(timezone.utc).timestamp() * 1000

    # 获取treasury表数据
    treasury_sql = f"select asset_id, fee_amount, fee_amount,  trader_identifier, created_at \
                   from treasury \
                   where created_at >= {start_timestamp} and created_at <= {end_timestamp} and status='completed'\
        and trader_identifier not in (SELECT users.user_id FROM users LEFT JOIN individuals " \
                   f"on users.entity_id=individuals.entity_id where individuals.tenant='viva') " \
                   f"order by created_at desc;"
    logger.info(
        {
            "type": "sql_record",
            "func": "get_treasury_df",
            "sql_name": "treasury_sql",
            "sql": treasury_sql
        }
    )
    treasury_result = conn.execute(treasury_sql).fetchall()
    treasury_df = pd.DataFrame(treasury_result,
                        columns=["asset_id", "vol", "position", "trader_identifier", "created_at"])
    treasury_df['datetime'] = pd.to_datetime(treasury_df['created_at'], unit='ms')
    treasury_df['date'] = pd.to_datetime(treasury_df['datetime'].apply(lambda x: x.date()))
    treasury_df['vol'] = treasury_df['vol'].fillna('0')
    treasury_df['vol'] = list(map(decimal.Decimal, map(str, treasury_df['vol'].to_list())))
    treasury_df['position'] = list(map(decimal.Decimal, map(str, treasury_df['position'].to_list())))

    return treasury_df

@timer
def get_merged_df(start_timestamp=None, end_timestamp=None, entity='zerocap'):
    if start_timestamp is None:
        start_timestamp = 0
    if end_timestamp is None:
        end_timestamp = datetime.now(timezone.utc).timestamp() * 1000
        
    # transactions表是以客户角度，记录的数据，但risk页面数据展示要以交易员的角度，所以，买卖记录的side要做调换，side_n（"buy": -1, "sell": 1）
    txns_sql = f"select base_asset, quote_asset, side, quantity, total, trader_identifier, created_at \
        from transactions \
        where status != 'deleted' and created_at >= {start_timestamp} and created_at <= {end_timestamp} \
        and trader_identifier not in " \
               f"(SELECT users.user_id FROM users LEFT JOIN individuals on users.entity_id=individuals.entity_id " \
               f"where individuals.tenant='viva') and entity = '{entity}' \
        and base_asset != 'AAA' AND  quote_asset != 'AAA'  and order_type in ('Market', 'Limit')     \
        order by created_at desc;" 

    # fills表是以交易员角度，记录的数据，risk页面数据展示也要以交易员的角度，所以只需注意side_n（"buy": 1, "sell": -1）
    fills_sql = f"select base_asset, quote_asset, side, quantity, quote_quantity, trader_identifier, \
        created_at from fills \
        where status != 'deleted' and created_at >= {start_timestamp} and created_at <= {end_timestamp} \
        and trader_identifier not in " \
                f"(SELECT users.user_id FROM users LEFT JOIN individuals on users.entity_id=individuals.entity_id " \
                f"where individuals.tenant='viva') and entity = '{entity}' \
        and base_asset != 'AAA' AND  quote_asset != 'AAA'       \
        order by created_at desc;"
    logger.info(
        {
            "type": "sql_record",
            "func": "get_merged_df",
            "sql_name": "txns_sql",
            "sql": txns_sql
        }
    )
    txns_result = conn.execute(txns_sql).fetchall()
    txns = pd.DataFrame(txns_result, columns=["base_asset", "quote_asset", "side", "quantity", "quote_quantity", "trader_identifier", "created_at"])

    logger.info(
        {
            "type": "sql_record",
            "func": "get_merged_df",
            "sql_name": "fills_sql",
            "sql": fills_sql
        }
    )
    fills_result = conn.execute(fills_sql).fetchall()
    fills = pd.DataFrame(fills_result, columns=["base_asset", "quote_asset", "side", "quantity", "quote_quantity", "trader_identifier", "created_at"])

    # 如果客户买的话，对我们来说是卖单
    txn_side_map = {"buy": "sell", "sell": "buy"}
    txns['side'] = txns['side'].replace(txn_side_map)

    # 合并一下fills和txns，因为全部都是影响风险敞口的记录
    merged_df = pd.concat([txns, fills]).sort_values('created_at')
    merged_df.loc[merged_df['base_asset'].isin(USDT_LIS), "base_asset"] = "USDT"
    merged_df.loc[merged_df['quote_asset'].isin(USDT_LIS), "quote_asset"] = "USDT"

    merged_df['datetime'] = pd.to_datetime(merged_df['created_at'], unit='ms')
    merged_df['date'] = pd.to_datetime(merged_df['datetime'].apply(lambda x: x.date()))

    merged_df['quantity'] = merged_df['quantity'].fillna('0')
    merged_df['quote_quantity'] = merged_df['quote_quantity'].fillna('0')
    merged_df['quantity'] = list(map(decimal.Decimal, map(str, merged_df['quantity'].to_list())))
    merged_df['quote_quantity'] = list(map(decimal.Decimal, map(str, merged_df['quote_quantity'].to_list())))

    side_pos_map = {"buy": 1, "sell": -1}
    merged_df['side_n'] = merged_df['side'].replace(side_pos_map)
    merged_df['position'] = merged_df['side_n'] * merged_df['quantity']
    merged_df['proceeds'] = merged_df['side_n'] * merged_df['quote_quantity'] * -1
    
    # 获取 base_asset 和 quote_asset 列，并去重
    base_list = merged_df['base_asset'].drop_duplicates().to_list()
    quote_list = merged_df['quote_asset'].drop_duplicates().to_list()
    assets = set(base_list + quote_list)
    ticker_time_list = []
    for asset in assets:
        time_points = merged_df.loc[(merged_df['base_asset'] == asset) | (merged_df['quote_asset'] == asset), 'date'].drop_duplicates().tolist()
        ticker_time_list.append({
            'base_asset': asset,
            'quote_asset': 'USD',
            'time_range': [tp.strftime('%Y-%m-%d') for tp in time_points]
        })
    historical_prices = get_historical_prices_df(ticker_time_list)

    return merged_df, historical_prices


def get_historical_prices_result(ticker_time_list):
    if not ticker_time_list:
        return []

    historical_price_data = {
        "ticker_list": [],
        "time_range": [],
        "ticker_time_list": ticker_time_list,
        "source_list": CHANNEL_DEFAULT_ORDER,
        "is_all_source_price": False
    }

    logger.info(f"get_historical_prices_result: {historical_price_data}")

    zmd_host = os.environ.get('ZEROCAP_MONITOR_GRPC_ZMD')
    with grpc.insecure_channel(zmd_host) as channel:
        stub = zerocap_market_data_pb2_grpc.ZerocapMarketDataStub(channel)
        res = stub.GetTickerDailyHistoryPrice(
            zerocap_market_data_pb2.GetTickerDailyHistoryPriceRequestV1(**historical_price_data))

        if res.status != "success":
            logger.error(res)
            logger.error("GetTickerDailyHistoryPrice failed!")
            raise Exception("GetTickerDailyHistoryPrice failed!")

    res_result = res.result
    historical_prices_result = {}
    for i in res_result:
        create_at = i.date
        for j in i.price:
            asset_tuple = (j.base_asset, create_at)
            if asset_tuple in historical_prices_result:
                old_price = historical_prices_result[asset_tuple]
                if Calc(old_price).value < Calc(j.price).value:
                    historical_prices_result[asset_tuple] = j.price
            else:
                historical_prices_result[asset_tuple] = j.price

    result = [[i[0], historical_prices_result[i], i[1]] for i in historical_prices_result]
    return result


# @lru_cache(maxsize=30)
def get_historical_prices_df(ticker_time_list):
    """为了使用 lru，这里的 ticker_time_list 是一个元组"""
    historical_prices_result = get_historical_prices_result(list(ticker_time_list))
    historical_prices = pd.DataFrame(historical_prices_result, columns=['base_asset', 'price', 'created_at'])
    # historical_prices = historical_prices.sort_values(by=['created_at'])
    historical_prices['created_at'] = pd.to_datetime(historical_prices['created_at'])
    historical_prices['date'] = pd.to_datetime(historical_prices['created_at'])
    historical_prices['price'] = historical_prices['price'].fillna('0')
    historical_prices['price'] = list(map(decimal.Decimal, map(str, historical_prices['price'].to_list())))

    symbol_ticker = get_symbol_ticker_from_gck()
    for symbol, ticker in symbol_ticker.items():
        if symbol == ticker:
            continue

        # 如果简称已存在，不转换，保留全称
        if not historical_prices[historical_prices['base_asset'] == symbol].empty:
            continue

        # 保留非 gck 源的数据，同时添加 gck 源的数据（gck 的 name 可能和其他源的简称一样）
        if not historical_prices[historical_prices['base_asset'] == ticker].empty:
            gck_price = historical_prices[historical_prices['base_asset'] == ticker].copy()
            gck_price['base_asset'] = symbol
            historical_prices = pd.concat([historical_prices, gck_price])

    return historical_prices


@lru_cache(maxsize=1)
def get_trader_info_df(traders_tuple):
    # trader_info_sql = f"select email,concat(firstname,' ',lastname) as name from users where email in {traders_tuple}".replace(",)", ")")

    trader_info_sql = f"SELECT t1.user_id, t1.email, concat(t2.first_name, '', t2.last_name) as name from users t1 LEFT JOIN individuals t2 ON (t1.entity_id = t2.entity_id and t2.status='active') where t1.user_id in {traders_tuple}".replace(",)", ")")
    logger.info(
        {
            "type": "sql_record",
            "func": "get_trader_info_df",
            "sql_name": "trader_info_sql",
            "sql": trader_info_sql
        }
    )
    traders_result = conn.execute(trader_info_sql).fetchall()
    traders = pd.DataFrame(traders_result, columns=["trader_identifier", "email", "name"])
    traders = traders.fillna('')
    return traders


def check_txn_time_interval(interval=60):
    """
    检查创建时间间隔
    为防止以外，redis的risk每60s运行一次，间隔时间拉长到70s
    间隔小于间隔秒数，间隔时间内有数据更新，需要重新计算risk,返回为True;
    如果没有则不计算
    如果跨日期，则正常计算;
    """
    txn_time_interval_sql = "SELECT cast(max(created_at) as int8) as created_at  from (SELECT max(created_at) as created_at  from transactions union all SELECT max(created_at) as created_at from fills)t1;"
    logger.info(
        {
            "type": "sql_record",
            "func": "check_txn_time_interval",
            "sql_name": "txn_time_interval_sql",
            "sql": txn_time_interval_sql
        }
    )
    res_data = conn.execute(txn_time_interval_sql).fetchall()
    if res_data:
        max_create_at = res_data[0][0]
        now_timestamp = int(time.time() * 1000)
        now_today = datetime.today().strftime("%Y-%m-%d")
        max_create_at_date = time.strftime('%Y-%m-%d', time.localtime(max_create_at/1000))
        if now_timestamp - float(max_create_at) <= (interval+10) * 1000 or max_create_at_date != now_today: # 单位都是毫秒级，60 * 100
            return True
    return False


@timer
def get_risk_pos(start_timestamp, end_timestamp, entity='zerocap', cal_date=None):
    df, historical_prices = get_merged_df(
        start_timestamp=start_timestamp,
        end_timestamp=end_timestamp,
        entity=entity,
    )

    df_base = df[[
        'trader_identifier',
        'base_asset',
        'quantity',
        'position',
        # 'vol_usd',
        'date',
        'created_at',
    ]].rename(
        columns={
            'base_asset': 'asset_id',
            'quantity': 'vol',
        }
    )

    df_quote = df[[
        'trader_identifier',
        'quote_asset',
        'quote_quantity',
        'proceeds',
        # 'vol_usd',
        'date',
        'created_at',
    ]].rename(
        columns={
            'quote_asset': 'asset_id',
            'quote_quantity': 'vol',
            'proceeds': 'position'
        }
    )

    treasury_df = get_treasury_df(start_timestamp=start_timestamp, end_timestamp=end_timestamp)

    df_treasury = treasury_df[[
        'trader_identifier',
        'asset_id',
        "vol",
        "position",
        'date',
        'created_at',
    ]]

    df_treasury = pd.merge(
        df_treasury,
        historical_prices[['date', 'price', 'base_asset']],
        how='left',
        left_on=['date', 'asset_id'],
        right_on=['date', 'base_asset']
    )

    df_base = pd.merge(
        df_base,
        historical_prices[['date', 'price', 'base_asset']],
        how='left',
        left_on=['date', 'asset_id'],
        right_on=['date', 'base_asset']
    )
    df_base.loc[df_base["asset_id"] == "USD", 'price'] = decimal.Decimal("1")

    df_quote = pd.merge(
        df_quote,
        historical_prices[['date', 'price', 'base_asset']],
        how='left',
        left_on=['date', 'asset_id'],
        right_on=['date', 'base_asset']
    )
    df_quote.loc[df_quote["asset_id"] == "USD", 'price'] = decimal.Decimal("1")

    df_base['vol_usd'] = df_base['vol'] * df_base['price']
    df_quote['vol_usd'] = df_quote['vol'] * df_quote['price']
    df_treasury['vol_usd'] = df_treasury['vol'] * df_treasury['price']
    df = pd.concat([df_base, df_quote, df_treasury])
    if df.empty:
        return None, None, None

    trader_df = df.groupby(['trader_identifier', 'asset_id'], as_index=False).agg({"vol": np.sum, "position": np.sum,
                                                                                   "vol_usd": np.sum,
                                                                                   "created_at": np.max}).rename(
        columns={
            'position': 'exposure_quantity',
            'vol': 'trading_volume',
            'vol_usd': 'trading_volume_usd'
        }
    )
    traders_tuple = tuple(set(trader_df['trader_identifier']))
    trader_info_df = get_trader_info_df(traders_tuple)
    trader_df = pd.merge(
        trader_df,
        trader_info_df,
        how='left',
        left_on='trader_identifier',
        right_on='trader_identifier'
    )
    trader_df["name"] = trader_df.name.fillna('')
    trader_df["email"] = trader_df.email.fillna('')

    sum_df = df.groupby('asset_id').agg({"vol": np.sum, "position": np.sum,
                                         "vol_usd": np.sum,
                                         "created_at": np.max}).rename(
        columns={
            'position': 'exposure_quantity',
            'vol': 'trading_volume',
            'vol_usd': 'trading_volume_usd'
        }
    )

    # 默认today_date为当前日期，如果传了cal_date(date_time类型)
    cal_date = pd.to_datetime(cal_date) if cal_date else pd.to_datetime(datetime.now(timezone.utc).date())
    symbol_ticker = get_symbol_ticker_from_gck()
    no_price_assets = []
    for idx, row in trader_df.iterrows():
        price = get_history_price(row["asset_id"], cal_date, symbol_ticker, historical_prices=historical_prices)
        if price == 0:
            no_price_assets.append(row["asset_id"])
        trader_df.at[idx, 'exposure_quantity_usd'] = row['exposure_quantity'] * price

    # 计算当天 risk 没有获取到价格的币种发送 slack 消息
    current_timestamp = int(time.time())
    time_diff = (current_timestamp - int(start_timestamp) / 1000) / 3600
    now_hour, now_minute = datetime.now().hour, datetime.now().minute
    if no_price_assets and time_diff < 24 and (now_hour > 0 or now_minute > 30):
        send_slack(channel='SLACK_API_OPS',
                   subject="otc: can not get history price assets in risk",
                   content=no_price_assets)

    historical_prices['created_at'] = pd.to_datetime(historical_prices['created_at'])
    prices_sum = historical_prices.loc[historical_prices.groupby('base_asset')['created_at'].idxmax()]
    prices_sum = prices_sum.drop_duplicates()  # prices_sum 去重
    prices_sum = prices_sum[['base_asset', 'price']].set_index('base_asset')

    sum_df = pd.merge(sum_df, prices_sum, how='left', left_index=True, right_index=True)
    sum_df.loc[sum_df.index == "USD", 'price'] = decimal.Decimal("1")
    sum_df['exposure_quantity_usd'] = sum_df['exposure_quantity'] * sum_df['price']
    pnl_df = trader_df.groupby('trader_identifier')['exposure_quantity_usd'].sum()
    pnl_df['total'] = pnl_df.sum()

    return trader_df.fillna(0), sum_df.fillna(0), pnl_df.fillna(0)


def save_risk(risk_dic_lst):
    for risk_dic in risk_dic_lst:
        risk_dic['exposure_quantity'] = str(Calc(risk_dic['exposure_quantity'])) \
            if risk_dic['exposure_quantity'] != '' else risk_dic['exposure_quantity']
        risk_dic['exposure_value_usd'] = str(Calc(risk_dic['exposure_value_usd'])) \
            if risk_dic['exposure_value_usd'] != '' else risk_dic['exposure_value_usd']
        risk_dic['trading_volume'] = str(Calc(risk_dic['trading_volume'])) \
            if risk_dic['trading_volume'] != '' else risk_dic['trading_volume']
        risk_dic['trading_volume_usd'] = str(Calc(risk_dic['trading_volume_usd'])) \
            if risk_dic['trading_volume_usd'] != '' else risk_dic['trading_volume_usd']
        risk_dic['pnl'] = str(Calc(risk_dic['pnl'])) if risk_dic['pnl'] != '' else risk_dic['pnl']

    with db.atomic():
        # 根据Risk.trader_identifier, Risk.asset_id, Risk.risk_type, Risk.entity, Risk.date五个字段判断是插入还是更新
        Risk.insert_many(risk_dic_lst).on_conflict(
            conflict_target=[Risk.trader_identifier, Risk.asset_id, Risk.risk_type, Risk.entity, Risk.date],
            preserve=[Risk.exposure_quantity, Risk.exposure_value_usd, Risk.trading_volume, Risk.trading_volume_usd,
                      Risk.pnl, Risk.last_updated]).execute()

    return True


def get_oldest_txn_time():
    res_txn = Transactions.select(Transactions.created_at).order_by(Transactions.created_at.asc()).first()
    res_fill = Fills.select(Fills.created_at).order_by(Fills.created_at.asc()).first()
    return res_txn.created_at if res_txn.created_at < res_fill.created_at else res_fill.created_at


def get_close_pnl_by_dates(dates, entity='zerocap'):
    res_risk = Risk.select(Risk.pnl.cast('float'),
                           fn.to_char(fn.to_timestamp(Risk.last_updated / 1000), 'yyyy-MM-dd HH24').alias(
                               "last_updated"), Risk.exposure_value_usd).where(
        (fn.to_char(fn.to_timestamp(Risk.last_updated / 1000), 'yyyy-MM-dd HH24') << dates) & (
                Risk.entity == entity) & (Risk.risk_type == 'total_company'))

    return [{"last_updated": i.last_updated, "pnl": i.pnl, "exposure_value_usd": i.exposure_value_usd} for i in res_risk]


def get_user():
    """
    :return: result
    """
    result = Users.select(Users.email, Users.user_id, Users.entity_id, Individuals.first_name, Individuals.last_name).join(
        Individuals, on=(Users.entity_id == Individuals.entity_id)).where(Users.role >= 3)
    if result:
        return result
    return None


def save_risk_alarm(data):
    """
    :return: True
    """
    RiskAlarm.insert(data).execute()


def get_risk_limits_alarm():
    sql = """SELECT t1.trader_identifier, t1.alert_interval, t1.stop_loss_limit, t3.created_at, users.firstname, users.lastname 
    FROM risk_limits t1 LEFT JOIN (SELECT t2.trader_identifier, max(t2.created_at) as created_at FROM risk_alarm t2 
    GROUP BY t2.trader_identifier) as t3 on t1.trader_identifier = t3.trader_identifier LEFT JOIN users 
    on t1.trader_identifier = users.user_id WHERE t1.status = 'normal';"""
    logger.info(
        {
            "type": "sql_record",
            "func": "get_risk_limits_alarm",
            "sql_name": "sql",
            "sql": sql
        }
    )
    cursor = db.cursor()
    cursor.execute(sql)
    res_data = cursor.fetchall()
    cursor.close()

    return {res[0]: [str(i).replace(",", "") if i else '0' for i in res[1:-2]] + [f"{str(res[4]) if res[4] else ''} {str(res[5]) if res[5] else ''}"] for res in res_data}


def get_usdtaud_1m(start_date, end_date, start_timestamp=None, end_timestamp=None, symbols='USDT/AUD'):
    flt = [UsdtAud1m.symbols == symbols, UsdtAud1m.created_date >= start_date, UsdtAud1m.created_date <= end_date]
    if start_timestamp:
        flt.append(UsdtAud1m.time >= start_timestamp)

    if end_timestamp:
        flt.append(UsdtAud1m.time <= end_timestamp)

    res = UsdtAud1m.select().where(reduce(operator.and_, flt)).order_by(UsdtAud1m.time.asc())
    result = []
    for i in res:
        result.append({
            "open_price": i.open_price,
            "close_price": i.close_price,
            "high_price": i.high_price,
            "low_price": i.low_price,
            "vol": i.vol,
            "created_date": timestamp_to_time(i.time)
        })
    return result


def insert_into_usdtaud_1m():
    from utils.date_time_utils import timestamp_to_date_time
    data_dict = {
        "symbols": "USDT/AUD",
        "open_price": "103",
        "close_price": "98",
        "high_price": "105.22",
        "low_price": "96.88",
        "vol": "1012",
        "time": 1687339440000,
        "created_date": "2023-06-21",
        "created_at": 1687339440000
    }
    start_time = int(time.time()*1000) - int(time.time()*1000) % 60000
    for i in range(1440):
        created_at = start_time - i * 60 * 1000
        data_dict['created_at'] = created_at
        data_dict['time'] = created_at
        created_date = timestamp_to_date_time(created_at)
        data_dict['created_date'] = created_date

        UsdtAud1m.insert(data_dict).execute()


def get_dma_config(symbol=None):
    sql_head = f"""SELECT t3.symbol, 
                    t3.price_stream, 
                    t3.place_orders, 
                    t3.px_sig, 
                    t3.qty_sig, 
                    t3.max_order, 
                    t3.min_order, 
                    t3.buy_spread, 
                    t3.sell_spread, 
                    t3.created_at,
                    string_agg(t3.quantity_spread, ';') as quantity_spread 
            FROM
                (SELECT t1.symbol, 
                        t1.price_stream, 
                        t1.place_orders, 
                        t1.px_sig, 
                        t1.qty_sig, 
                        t1.max_order, 
                        t1.min_order, 
                        t1.buy_spread, 
                        t1.sell_spread, 
                        t1.created_at, 
                        concat(t2.id, ',', t2.quantity, ',', t2.spread) as quantity_spread 
                from dma_config t1 
                LEFT JOIN dma_ladder_config t2 
                ON t1.symbol = t2.symbol and t2.status='active'
                WHERE t1.status='active' """
    sql_tail = """ORDER BY t2.id ASC) as t3 
                  GROUP BY (  t3.symbol, 
                            t3.price_stream, 
                            t3.place_orders, 
                            t3.px_sig, 
                            t3.qty_sig, 
                            t3.max_order, 
                            t3.min_order, 
                            t3.buy_spread, 
                            t3.sell_spread, 
                            t3.created_at);"""

    sql = sql_head + sql_tail
    if symbol:
        sql_mid = f"and t1.symbol like '%%{symbol.upper()}%%' "
        sql = sql_head + sql_mid + sql_tail

    logger.info(
        {
            "type": "sql_record",
            "func": "get_asset_ticker",
            "sql_name": "sql",
            "sql": sql
        }
    )
    res_data = conn.execute(sql).fetchall()

    result = []
    for res in res_data:
        result.append(
            {
                'symbol': res[0],
                'price_stream': res[1],
                'place_orders': res[2],
                'px_sig': str(res[3]),
                'qty_sig': str(res[4]),
                'max_order': res[5],
                'min_order': res[6],
                'buy_spread': res[7],
                'sell_spread': res[8],
                'dma_ladder': [{'id': i.split(',')[0], 'quantity': i.split(',')[1], 'spread': i.split(',')[2]} for i in res[10].split(';') if i != ',,']
            }
        )
    return result


def check_update_price_admin_parameter(request):
    # 将 grpc 的 message 转为字典
    # including_default_value_fields 将未传的参数也会转化
    # preserving_proto_field_name 保留原本的参数名，不会进行大小写转换
    parameter = MessageToDict(request, including_default_value_fields=True, preserving_proto_field_name=True)
    need_check_quantity = ['buy_spread', 'sell_spread']
    need_check_enable = ['price_stream', 'place_orders']
    quantity = 0
    spread = -100000
    max_order = 0
    min_order = 0
    for key, val in parameter.items():

        if key != 'dma_ladder' and not val:
            logger.error(f"update_price_admin invalid argument, {key} is empty!")
            text = f"{key} is empty!"
            raise ZCException(text)

        if key in need_check_enable and val not in ['Enabled', 'Disabled']:
            logger.error(f"update_price_admin: {key} type incorrect!")
            raise ZCException(f"{key} incorrect!")

        if key in need_check_quantity and (not val.lstrip('-').isdigit() or not -10000 <= float(val) <= 10000):
            logger.error(f"update_price_admin invalid argument, {key} must be a integer between -10000 and 10000!")
            text = f"{key} must be a integer between -10000 and 10000!"
            raise ZCException(text)

        if key in ['px_sig', 'qty_sig'] and (not 2 <= float(val) <= 6 or not val.isdigit()):
            logger.error(f"update_price_admin invalid argument, {key} must be a positive integer between 2 and 6")
            text = f"{key} must be a positive integer  between 2 and 6"
            raise ZCException(text)

        if key in ['max_order', 'min_order'] and (not 1 <= float(val) or not val.isdigit()):
            logger.error(f"update_price_admin invalid argument, {key} must be a positive integer and greater than or equal to 1")
            text = f"{key} must be a positive integer and greater than or equal to 1"
            raise ZCException(text)

        if key == 'max_order':
            max_order = float(val)
        elif key == 'min_order':
            min_order = float(val)

        if key == 'dma_ladder' and val:
            for i in val:
                if not i['quantity'] or not i['spread']:
                    logger.error(f"update_price_admin invalid argument, quantity and spread is empty!")
                    text = f"quantity and spread is empty!"
                    raise ZCException(text)

                if i['quantity'] and (not i['quantity'].isdigit() or not 1 <= float(i['quantity']) <= 9999999):
                    logger.error(f"update_price_admin invalid argument, quantity must be a positive integer between 1 and 9999999")
                    text = "quantity must be a positive integer between 1 and 9999999"
                    raise ZCException(text)

                if i['spread'] and (not i['spread'].lstrip('-').isdigit() or not -10000 <= float(i['spread']) <= 10000):
                    logger.error(f"update_price_admin invalid argument, spread must be a intege between -10000 and 10000!")
                    text = "spread must be a intege between -10000 and 10000"
                    raise ZCException(text)

                if int(i['quantity']) <= quantity or int(i['spread']) <= spread:
                    logger.error(f"update_price_admin invalid argument, The lower level of quantity and spread must be larger than the higher level!")
                    text = "The lower level of quantity and spread must be larger than the higher level!"
                    raise ZCException(text)
                else:
                    quantity = int(i['quantity'])
                    spread = int(i['spread'])

    if min_order > max_order:
        logger.error(f"update_price_admin invalid argument, Maximum order must be greater than or equal to minimum order")
        text = f"Maximum order must be greater than or equal to minimum order"
        raise ZCException(text)


def update_dam_config_by_symbol(symbol, update_data):
    DmaConfig.update(update_data).where(DmaConfig.symbol == symbol).execute()


def get_dma_ladder_config_by_symbol(symbol):
    res = DmaLadderConfig.select(DmaLadderConfig.id, DmaLadderConfig.quantity, DmaLadderConfig.spread).\
        where(DmaLadderConfig.symbol == symbol, DmaLadderConfig.status == 'active')
    result = []
    result_id = []
    for i in res:
        result_id.append(str(i.id))
        result.append((str(i.id), i.quantity, i.spread))
    return result, result_id


def update_dma_ladder_config_to_inactive(id, update_data):
    DmaLadderConfig.update(update_data).where(DmaLadderConfig.id == id).execute()


def insert_dam_ladder_config(data):
    with db.atomic():
        DmaLadderConfig.insert_many(data).execute()
    return True


if __name__ == "__main__":
    # pd.set_option('display.max_columns', None)
    # pd.set_option('display.max_rows', None)
    # trader_df, sum_df, pnl_df = get_risk_pos(1659950268800, 1659950268800)
    # print("trader_df:", trader_df)
    # print("sum_df:", sum_df)
    # print("pnl_df:", pnl_df)
    # print(get_close_pnl_by_dates(['2022-08-09 06', '2022-08-08 06', '2022-08-02 06', '2022-07-10 06']))
    # print(datetime(2022, 8, 9, 6, tzinfo=timezone.utc).timestamp())
    # utc_now = datetime.now()
    # save_risk([{
    #     "created_at": utc_now,
    #     "last_updated": 1659938400000,
    #     "trader_identifier": "",
    #     "asset_id": "",
    #     "exposure_quantity": "",
    #     "exposure_value_usd": "1.21545e-8",
    #     "trading_volume": "5.6e+10",
    #     "trading_volume_usd": "2.0e+7",
    #     "pnl": "3.1545454e-6",
    #     "risk_type": "total_company",
    #     "entity": "zerocap",
    #     "date": "2022-08-09"
    # }])

    # get_user()

    # historical_price_data = {
    #     "ticker_list": [],
    #     "time_range": [],
    #     "ticker_time_list": [{"base_asset": "AIOZ", "quote_asset": "USD", "time_range": ["2023-05-30", "2023-05-31"]}],
    #     "source_list": CHANNEL_DEFAULT_ORDER,
    #     "is_all_source_price": False
    # }
    #
    # zmd_host = os.environ.get('ZEROCAP_MONITOR_GRPC_ZMD')
    # with grpc.insecure_channel(zmd_host) as channel:
    #     stub = zerocap_market_data_pb2_grpc.ZerocapMarketDataStub(channel)
    #     res = stub.GetTickerDailyHistoryPrice(
    #         zerocap_market_data_pb2.GetTickerDailyHistoryPriceRequestV1(**historical_price_data))
    #
    #     if res.status != "success":
    #         logger.error(res)
    #         logger.error("GetTickerDailyHistoryPrice failed!")
    #         raise Exception("GetTickerDailyHistoryPrice failed!")
    #
    #     res_result = res.result
    #     print(res_result)
    #
    # pass

    # insert_into_usdtaud_1m()
    print(get_dma_config())

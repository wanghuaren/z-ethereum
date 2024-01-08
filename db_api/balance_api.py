import time
from functools import reduce
from peewee import operator
from db.models import Balances
from utils.calc import Calc
from config.config import config, CHANNEL_DEFAULT_ORDER
from db_api.account_api import get_entity_id_by_user_id
from utils.date_time_utils import iso8601
from utils.get_market_price import get_symbol_price_by_ccxt_or_redis
from utils.redis_cli import RedisClient
from internal.rfq.data_helper import get_history_price_by_asset, get_lp_list
from utils.logger import logger

redis_cli = RedisClient()
rfq_market_list = list(get_lp_list('RFQ').keys())


def query_balances_by_account_id(account_id, vault_id, asset_id, asset_type="custody"):
    flt = [Balances.status == 'active']
    if account_id:
        flt.append(Balances.account_id == account_id)

    if vault_id:
        flt.append(Balances.vault_id == vault_id)

    if asset_id:
        flt.append(Balances.asset_id == asset_id)

    if asset_type:
        flt.append(Balances.type == asset_type)

    res = Balances.select(Balances.quantity, Balances.asset_id, Balances.account_id, Balances.vault_id, Balances.type).\
        where(reduce(operator.and_, flt))
    result = []
    for i in res:
        result.append({
            "quantity": i.quantity,
            "asset_id": i.asset_id,
            "account_id": i.account_id,
            "vault_id": i.vault_id,
            "asset_type": i.type,
        })
    return result


def get_price_by_redis_or_historical(asset_id):
    if asset_id == "USD":
        return 1

    price = ""
    depth = redis_cli.json_get(key=f"yahoo_quote_{asset_id}/USD_depth")
    if depth:
        timestamp = depth["timestamp"]
        if int(time.time()) - int(timestamp / 1000) < 60 * 90:
            # redis 价格在 90 分钟内
            price = redis_cli.json_get(key=f"yahoo_quote_{asset_id}/USD")
    else:
        # 价格超时，去 historical 获取价格
        price = get_history_price_by_asset(asset_id)

    if not price or price == "0":
        return 0
    return price


def add_balance(user_id, asset_id, account_id, vault_id, quantity, amount_usd):
    # 插入一条新的 balances 记录
    entity_id = get_entity_id_by_user_id(user_id)
    created_at = int(time.time() * 1000)
    balance_data = {
        "user_id": user_id,
        "asset_id": asset_id,
        "quantity": str(quantity),
        "created_at": created_at,
        "last_updated": created_at,
        "datetime": iso8601(created_at),
        "status": "active",
        "type": "custody",
        "yield_id": None,
        "amount_usd": str(amount_usd),
        "account_id": account_id,
        "vault_id": vault_id,
        "entity_id": entity_id
    }
    logger.info(f"update balance data: {balance_data}")
    Balances.insert(balance_data).execute()


def update_balance_by_account_id(account_id, vault_id, asset_id, amount, user_id, side, network=''):

    # 如果network不为空,则获取USDT的链数据
    if network:
        asset_id = config["USDT"][network]
    result = query_balances_by_account_id(account_id, vault_id, asset_id)

    if asset_id == "USD":
        price = 1
    else:
        price = get_price_by_redis_or_historical(asset_id)
        if not price:
            # 获取asset_id对应的USD的价格
            res_data = get_symbol_price_by_ccxt_or_redis(f"{asset_id}/USD", CHANNEL_DEFAULT_ORDER, "two_way")
            if res_data['buy_price']['price'] != 0:
                price = res_data['buy_price']['price']
            elif res_data['sell_price']['price'] != 0:
                price = res_data['sell_price']['price']
            else:
                # historical 获取价格
                price = get_history_price_by_asset(asset_id)

    if side == "payment" and not result:
        text = f"There is no corresponding balance record by {asset_id}!"
        raise Exception(text)
    elif side == "settlement" and not result:
        # 如果是 settlement 并且没有原 balances 记录，直接创建新纪录
        new_amount = Calc(Calc(amount) * Calc(-1))
        amount_usd = Calc(Calc(new_amount) * Calc(price))
        add_balance(user_id, asset_id, account_id, vault_id, new_amount, amount_usd)
        return

    origin_quantity = Calc(result[0]["quantity"])
    # 只有 payment 才检查余额
    # 六种法币可以透支本币种 -10000 额度，不需要换算 USD
    if side == "payment" and Calc(origin_quantity - Calc(amount)).value < Calc(-10000).value :
        raise Exception("Insufficient balance")

    new_quantity = Calc(origin_quantity - Calc(amount))
    amount_usd = Calc(Calc(new_quantity) * Calc(price))

    # 将原纪录置为 inactive
    update_data = {"status":"inactive"}
    Balances.update(update_data).where((Balances.account_id == account_id) &
                                       (Balances.vault_id == vault_id) &
                                       (Balances.asset_id == asset_id) &
                                       (Balances.status == "active") &
                                       (Balances.type == "custody")).execute()
    # 插入一条新的 balance 记录
    add_balance(user_id, asset_id, account_id, vault_id, new_quantity, amount_usd)


def get_balance_by_account_id_and_asset(account_id, asset_id):
    res = Balances.select(Balances.quantity).where(Balances.status == 'active',
                                             Balances.account_id == account_id,
                                             Balances.asset_id == asset_id,
                                             Balances.type == "custody").first()
    return res.quantity



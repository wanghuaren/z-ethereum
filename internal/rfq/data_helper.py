import uuid
import hashlib
import operator
import os
import pickle
import sys
import pytz
from datetime import datetime, timedelta


import grpc
import requests
from functools import wraps, reduce
from peewee import JOIN

from google.protobuf.json_format import MessageToDict

sys.path.append("../../")
from db_api.account_api import get_account_name
from internal.users.data_helper import get_email_by_user_id
from utils.date_time_utils import iso8601

import time

from sqlalchemy import create_engine
from playhouse.shortcuts import model_to_dict

from utils.calc import Calc, retain_significant_digits
from utils.logger import logger
from utils.consts import RedisTimeOut
from utils.get_market_price import get_symbol_price_by_ccxt_or_redis
from config.config import config, EntityTypeCompany, EntityTypeTrust, EntityTypeIndividual, CHANNEL_DEFAULT_ORDER, MARKETS_CATEGORY
from db.base_models import redis_cli
from db.models import Quotes, Symbols, Orders, OrderStatusEnum, CustomizeEnum, Transactions, EntityAccount, \
    EntityRelation, Individuals, Companys, Trusts, PrimeAgreementHistory, OtcCrm, Groups, Assets, Users, EMSSymbols, \
    Accounts, AccountInfo, Vaults, PrimeAgreement, Approvers, ApprovalGroup, OtcFee, CrmNotes, MarketsConfig
from utils.zc_exception import ZCException
from config.config import TALOS_CONFIG, Trader_Email_Abridge
import zerocap_market_data_pb2
import zerocap_market_data_pb2_grpc


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


class RedisCache:
    def __init__(self, redis_client):
        self._redis = redis_client

    def _compute_key(self, func, args, kw):
        key = pickle.dumps((func.__name__, args, kw))
        return hashlib.sha1(key).hexdigest()

    def cache(self, timeout=0):
        def decorator(func):
            @wraps(func)
            def wrap(*args, **kw):
                if timeout <= 0:
                    return func(*args, **kw)
                key = self._compute_key(func, args, kw)
                raw = self._redis.json_get(key)
                if not raw:
                    value = func(*args, **kw)
                    self._redis.json_set(key, value, timeout)
                    return value
                return raw
            return wrap
        return decorator


# 添加redis缓存
cache = RedisCache(redis_cli)


def query_quotes_data_by_alias(alias):
    """
    查询quotes记录对应的 two_way 标识，没有则为 None
    :param alias:
    :return:
    """
    res = Quotes.select().where(Quotes.quote_alias == alias).first()
    result = {}
    if res:
        result = {
            "quote_alias": res.quote_alias,
            "txn_alias": res.txn_alias,
            "userpubkey": res.userpubkey,
            "user_id": res.user_id,
            "trader_identifier": res.trader_identifier,
            "base_asset": res.base_asset,
            "quote_asset": res.quote_asset,
            "side": res.side,
            "quantity": res.quantity,
            "quote_quantity": res.quote_quantity,
            "total": res.total,
            "quantity_asset": res.quantity_asset,
            "quote_price": res.quote_price,
            "raw_price": res.raw_price,
            "markup": res.markup,
            "markup_type": res.markup_type,
            "fee": res.fee,
            "fee_type": res.fee_type,
            "fee_pct": res.fee_pct,
            "fee_total": res.fee_total,
            "pnl": res.pnl,
            "status": res.status,
            "created_at": res.created_at,
            "canceled_at": res.canceled_at,
            "timeout": res.timeout,
            "entity": res.entity,
            "dealers": res.dealers,
            "hedge": res.hedge,
            "fee_notional": res.fee_notional,
            "parent_quote_alias": res.parent_quote_alias,
            "two_way_quote_alias": res.two_way_quote_alias,
            "quote_type": res.quote_type,
            "account_id": res.account_id,
            "vault_id": res.vault_id,
            "normal_quote": res.normal_quote,
            "settlement_destination": res.settlement_destination
        }
    return result


def update_quotes_status_and_parent_alias(quotes_dic):
    """
    不存在2 way, 则根据quote_alias 置为canceled;
    存在2 way标识， 则根据2 way 标识, 更新status为 canceled;
    :param quote_alias:
    :param two_way_quote_alias:
    :return:
    """
    if 'two_way_quote_alias' in quotes_dic.keys():
        Quotes.update(quotes_dic).where((Quotes.two_way_quote_alias == quotes_dic['two_way_quote_alias']) &
                                        (Quotes.status == 'open')).execute()
    else:
        Quotes.update(quotes_dic).where((Quotes.quote_alias == quotes_dic['quote_alias']) &
                                        (Quotes.status == 'open')).execute()


def get_trader_id_or_group_name(trader_identifier):
    sql = f"""select t2.name 
              from tradergroupmembers as t1 
              left join tradesgroup as t2 
              on t1.group_id=t2.group_id 
              where t1.trader_identifier='{trader_identifier}'
              and t1.status='active'
              and t2.status='active';"""
    
    res_data = conn.execute(sql).fetchall()
    if res_data:
        return res_data[0][0]
    return trader_identifier


def get_single_trade_size_limit_by_userid_and_assetid(user_id, asset_id, asset_type):
    sql_1 = f"""select quantity from single_trade_limits 
                where trader_identifier='{user_id}' and asset_id='{asset_id}' and asset_type='{asset_type}' and status='active';"""
    sql_2 = f"""select quantity from single_trade_limits 
                    where trader_identifier='*' and asset_id='{asset_id}' and asset_type='{asset_type}' and status='active';"""
    res_data = conn.execute(sql_1).fetchall()
    if not res_data:
        res_data = conn.execute(sql_2).fetchall()
        if not res_data:
            return None
        return res_data[0][0]
    return res_data[0][0]


def get_symbol_ticker(base_asset, quote_asset):
    result = Symbols.select(Symbols.ticker).where((Symbols.base_asset_id==base_asset) & \
             (Symbols.quote_asset_id==quote_asset) & (Symbols.status=='active')).first()
    if result:
        return result.ticker
    return None


def get_trader_group_members(trader_identifier):
    sql = f"""select trader_identifier from tradergroupmembers where status='active' and group_id in (
              select t1.group_id  from tradergroupmembers as t1 join tradesgroup as t2 
              on t1.group_id=t2.group_id where t1.trader_identifier='{trader_identifier}' and t1.status='active' and t2.status='active');"""
    result = conn.execute(sql).fetchall()
    if result:
        return [res[0] for res in result]
    return [trader_identifier]


def get_exposure_limit_by_user_id(trader_id):
    sql = f"select quantity from exposure_limits where trader_identifier = '{trader_id}' and status = 'active';"
    result = conn.execute(sql).fetchall()
    if result:
        return result[0][0]
    return None


def get_user_id_or_group_name(user_id):
    result = Approvers.select(ApprovalGroup.name).join(ApprovalGroup, JOIN.INNER,
                                                       on=(Approvers.group_id == ApprovalGroup.group_id)).\
        where(Approvers.status == 'active', ApprovalGroup.status == 'active', Approvers.user_id == user_id).first()

    if result:
        return result.name
    return user_id


def delete_extra_zero(num):
    num_list = str(num).split(".")
    if len(num_list) == 1:
        return num_list[0]
    result = num_list[0] + "." + num_list[1].rstrip("0")
    return result.rstrip(".")


def insert_quotes(quotes):

    # pnl为空,重新计算pnl
    fee_pct = quotes['fee_pct']
    group_name = quotes['user_id']
    pnl = quotes.get('pnl', "")
    if not quotes.get('pnl', ""):
        # if quotes['side'] == "sell":
        #     pnl = Calc(Calc(quotes['quantity']) * Calc(Calc(quotes['raw_price']) - Calc(quotes['quote_price'])))
        # elif quotes['side'] == "buy":
        #     pnl = Calc(Calc(quotes['quantity']) * Calc(Calc(quotes['quote_price']) - Calc(quotes['raw_price'])))

        if quotes['markup_type'] == 'pips':
            markup_notional = Calc(Calc(Calc(quotes['markup']) / 10000) * quotes['quantity'])
        else:
            markup_notional = Calc(Calc(Calc(quotes['raw_price']) * (Calc(quotes['markup']) / 10000)) * quotes['quantity'])
        pnl = Calc(markup_notional + quotes['fee_total'])
        pnl = delete_extra_zero(pnl) # 去除无效的 0
        # 通过user_id获取group_name
        group_name = get_user_id_or_group_name(quotes['user_id'])

    if quotes['base_asset'] == 'AAA' and quotes['quote_asset'] == 'AAA':
        quotes['note'] = 'Temporary transaction pairs, using AAA-AAA entry.'

    Quotes.insert(
        quote_alias=quotes['quote_alias'],
        txn_alias=quotes['txn_alias'],
        userpubkey=quotes['userpubkey'],
        user_id=group_name,
        trader_identifier=quotes['trader_identifier'],
        base_asset=quotes['base_asset'],
        quote_asset=quotes['quote_asset'],
        side=quotes['side'],
        quantity=quotes['quantity'],
        quote_quantity=quotes['quote_quantity'],
        total = quotes['total'],
        quantity_asset=quotes['quantity_asset'],
        quote_price=quotes['quote_price'],
        raw_price=quotes['raw_price'],
        markup=quotes['markup'],
        markup_type=quotes['markup_type'],
        fee=quotes['fee'],
        fee_type=quotes['fee_type'],
        fee_pct=fee_pct,
        fee_total=quotes['fee_total'],
        pnl=pnl,
        status=quotes['status'],
        created_at=quotes['created_at'],
        timeout=quotes['timeout'],
        entity=quotes['entity'],
        dealers=quotes['dealers'],
        hedge=quotes['hedge'],
        fee_notional=quotes['fee_notional'],
        parent_quote_alias=quotes.get('parent_quote_alias', None),
        two_way_quote_alias=quotes.get('two_way_quote_alias', ""),
        quote_type=quotes['quote_type'],
        is_edit=quotes.get('is_edit', None),
        account_id=quotes['account_id'],
        vault_id=quotes['vault_id'],
        normal_quote=quotes.get('normal_quote', False),
        note=quotes.get('note', ''),
        settlement_destination=quotes.get('settlement_destination', ''),
        price_mode=quotes.get('price_mode')
    ).execute()


def query_quotes_data_by_two_way_other_data(quote_alias, two_way_quote_alias):
    res = Quotes.select().where((Quotes.quote_alias != quote_alias) & (Quotes.two_way_quote_alias == two_way_quote_alias)).first()
    result = {}
    if res:
        result = {'quote_alias': res.quote_alias, 'parent_quote_alias': res.parent_quote_alias, 'side': res.side}
    return result


def check_redis_time_key(symbol, side, dealers):
    # 获取价格更新时间
    time_key = "talos_last_update"
    price_last_update = int(str(redis_cli.json_get(time_key)).split(".")[0]) * 1000
    now_time_stamp = int(time.time() * 1000)

    # 如果价格更新时间与当前时间超过 1.5 秒，抛出价格超时错误
    if now_time_stamp - price_last_update > 1500:
        logger.error("edit_rfq_quote: price stale, please try again")
        raise ZCException("price stale, please try again")

    bid_or_ask = {"buy":"ask", "sell":"bid"}
    # 获取当前交易对的价格，如果获取不到价格抛出错误
    raw_price = redis_cli.json_get(f"{dealers}_quote_{symbol}_{bid_or_ask[side]}")
    if not raw_price:
        logger.error(f"edit_rfq_quote: finally could not get price: {dealers}_quote_{symbol}_{bid_or_ask[side]}")
        raise ZCException("finally could not get price")


def check_redis_talos_time_key():
    # 获取价格更新时间
    time_key = "talos_last_update"
    price_last_update = int(str(redis_cli.json_get(time_key)).split(".")[0]) * 1000
    now_time_stamp = int(time.time() * 1000)

    # 如果价格更新时间与当前时间超过 1.5 秒，抛出价格超时错误
    if now_time_stamp - price_last_update > 1500:
        logger.error("get_quote: price stale, please try again")
        raise ZCException("price stale, please try again")


def get_symbol_by_asset(base_asset, quote_asset, source):

    sql = f"""SELECT 
                ticker, 
                "min"(qty_sig) as qty_sig, 
                "min"(px_sig) as px_sig 
            FROM 
                (SELECT 
                    ticker, CAST(source as VARCHAR), base_asset_id, quote_asset_id, qty_sig, px_sig 
                FROM 
                    ems_symbols 
                WHERE base_asset_id='{base_asset}' and quote_asset_id='{quote_asset}' and status = 'active' 
                UNION 
                SELECT 
                    ticker, CAST(source as VARCHAR), base_asset_id, quote_asset_id, qty_sig, px_sig
                FROM symbols 
                WHERE base_asset_id='{base_asset}' and quote_asset_id='{quote_asset}' and status = 'active' and platform like '%%ems%%') as t1 
            WHERE t1.base_asset_id='{base_asset}' and quote_asset_id='{quote_asset}' AND CAST(source as VARCHAR) in ('{source}')
            GROUP BY ticker, base_asset_id, quote_asset_id;"""
    res_data = conn.execute(sql).fetchall()
    symbol = ""
    if res_data:
        for i in res_data:
            symbol = i[0]
            return symbol
    return symbol


def check_single_trader_size_limit(quote):
    # 获取组用户id或组名以及单笔交易限额
    id_or_group_name = get_trader_id_or_group_name(quote["trader_identifier"])
    usd_limit = get_single_trade_size_limit_by_userid_and_assetid(id_or_group_name, "USD", "quote")

    # if not usd_limit:
    #     logger.error("edit_rfq_quote: could not get single trade limit info")
    #     raise ZCException("could not get single trade limit info")

    # 获取当前交易对 base_asset 的价格
    # 根据币种价格 * 交易数量计算交易额
    # 如果获取不到价格，则根据 symbols 表中记录的 ticker 前半部分币种再次尝试获取
    # 拿到价格后根据价格 * 交易数量计算交易额
    # 如果拿不到 ticker 直接抛出 ticker 获取异常错误
    # 如果 ticker 前半部分币种也获取不到价格，尝试使用整个 ticker 来获取价格
    # 如果整个 ticker 同样获取不到价格抛出价格异常错误
    # ticker 获取到价格后，尝试获取 quote_asset 币种价格
    # quote_asset 币种获取不到价格抛出价格异常错误
    # 根据 ticker价格/quote价格*交易量 计算交易额

    # 获取base/USD的价格(币种美金价格)
    res_data = get_symbol_price_by_ccxt_or_redis(f"{quote['base_asset']}/USD", CHANNEL_DEFAULT_ORDER, "two_way")
    if res_data['buy_price']['price'] != 0:
        base_quote_price = res_data['buy_price']['price']
    elif res_data['sell_price']['price'] != 0:
        base_quote_price = res_data['sell_price']['price']
    else:
        logger.error(f"chenck_single_trader_size_limit: could not get price: {quote['base_asset']}/USD")

        ticker = quote["symbol"]
        base_ticker = ticker.split("/")[0]

        res_data = get_symbol_price_by_ccxt_or_redis(f"{base_ticker}/USD", CHANNEL_DEFAULT_ORDER, "two_way")

        if res_data['buy_price']['price'] != 0:
            base_quote_price = res_data['buy_price']['price']
        elif res_data['sell_price']['price'] != 0:
            base_quote_price = res_data['sell_price']['price']
        else:
            logger.error(f"chenck_single_trader_size_limit: could not get price: {base_ticker}/USD")
            return False

    usd_quantity = Calc(str(base_quote_price)) * Calc(quote["quantity"])

    logger.info(f"chenck_single_trader_size_limit: base_asset: {quote['base_asset']}, quote_asset: {quote['quote_asset']}, "
                f"quantity: {str(quote['quantity'])}, usd_quantity: {str(usd_quantity)}, usd_limit:{usd_limit}")

    result = True
    # 有单笔交易限额则检测，没有的话返回 True
    if usd_limit:
        if Calc(usd_quantity).value > Calc(usd_limit).value:
            result = False
            logger.info(f"check_single_trader_size_limit: Exceeded single trade limit. usd_quantity: {str(usd_quantity)}, "
                        f"usd_limit:{str(usd_limit)}, quantity: {str(quote['quantity'])}")

    return result


def get_other_market_price(origin_market, asset):
    for market in TALOS_CONFIG["MARKETS_ACCOUNTS"]["zerocap"]:
        if market == origin_market:
            continue
        result_price = redis_cli.json_get(f"{market}_quote_{asset}/USD")
        if result_price:
            return result_price


def check_exposure_limit(quote):
    # 根据交易员获取交易组成员 id
    trader_group_members = get_trader_group_members(quote["trader_identifier"])

    all_positions = []
    # 获取交易组成员的仓位信息
    for trade in trader_group_members:
        trade_position = redis_cli.json_get(f"ems_positions_{trade}")
        if trade_position:
            all_positions.append(trade_position)

    # 获取交易组 name
    trader_id_or_group_name = get_trader_id_or_group_name(quote["trader_identifier"])
    if not trader_id_or_group_name:
        logger.error("CheckExposureLimit: could not get trader id or group name")
        raise ZCException("could not get trader id or group name")

    # 根据交易组名称获取交易组交易限额，如果不能获取交易限额直接返回 True
    exposure_limit = get_exposure_limit_by_user_id(trader_id_or_group_name)
    if not exposure_limit:
        return True

    used = Calc("0")
    for trader_positions in all_positions:
        for key, val in trader_positions.items():
            # 如果币种为法币，跳出
            if key in ('USD', 'AUD', 'GBP', 'EUR'):
                continue

            # 获取base/USD的价格(币种美金价格)
            res_data = get_symbol_price_by_ccxt_or_redis(f"{key}/USD", CHANNEL_DEFAULT_ORDER, "two_way")
            if res_data['buy_price']['price'] != 0:
                raw_price_res = res_data['buy_price']['price']
            elif res_data['sell_price']['price'] != 0:
                raw_price_res = res_data['sell_price']['price']
            else:
                logger.error(f"CheckExposureLimit: could not get price: {key}/USD")

                # 从history_price中获取,对key对USD的价格
                raw_price_res = get_history_price_by_asset(key)
                if raw_price_res == "0":
                    logger.error(f"get_history_price_by_asset: could not get price: {key}")
                    return False

            # 根据币种价格计算交易额度
            raw_price = Calc(str(raw_price_res))
            position_val = Calc(str(val))
            temp_usd = position_val * raw_price
            used += temp_usd

    # 已被使用的交易额度+当前交易额度
    used = Calc(Calc(str(used)) + Calc(quote["quote_quantity"]))
    exposure_limit = Calc(str(exposure_limit))
    balance = exposure_limit - used

    # 如果剩余交易额度大于 0，返回 True
    if balance > 0:
        return True
    logger.info(f"Exceeded exposure limit: used: {str(used)} limit_quantity: {str(exposure_limit)}")
    return False


def check_trader_price_and_limit(quote):
    # check_redis_time_key(quote['symbol'], quote['side'], quote['market'])

    result = check_single_trader_size_limit(quote)
    if not result:
        logger.error("check_single_trader_size_limit: trade exceeds single trade limit")
        raise ZCException("trade exceeds single trade limit")

    # 固定询价的不做日限额检查
    if quote['quote_type'] != 'Fixed':
        result = check_exposure_limit(quote)
        if not result:
            logger.error("check_exposure_limit: trade exceeds exposure limit")
            raise ZCException("trade exceeds exposure limit")


def check_trader_size_limit_and_exposure_limit(quote):
    quote["symbol"] = f'{quote["base_asset"]}/{quote["quote_asset"]}'
    # 验证单个用户交易限额
    single_trade_size_limit_result = check_single_trader_size_limit(quote)

    # 验证用户总交易限额
    exposure_limit_result = check_exposure_limit(quote)

    return single_trade_size_limit_result, exposure_limit_result


def get_ems_symbol_by_open_orders():
    # 获取orders表，status为open的数据
    open_orders = []
    all_orders = Orders.select(Orders.base_asset, Orders.quote_asset, Orders.dealers).where(Orders.status == OrderStatusEnum.get_const_obj("open"))
    if all_orders:
        for i in all_orders:
            res = [i.base_asset, i.quote_asset, "", i.dealers]
            if res in open_orders:
                continue
            open_orders.append(res)

    flt = []
    flt_ems = []
    for i in open_orders:

        flt.append(((Symbols.base_asset_id == i[0]) & (Symbols.quote_asset_id == i[1])))
        flt_ems.append(((EMSSymbols.base_asset_id == i[0]) & (EMSSymbols.quote_asset_id == i[1])))
    result = {}
    if flt and flt_ems:
        res = Symbols.select(Symbols.base_asset_id, Symbols.quote_asset_id, Symbols.ticker, Symbols.source).\
            where(reduce(operator.and_, ((Symbols.platform == 'ems'),
                                         (Symbols.source == 'gck'),
                                         (Symbols.status == 'active'),
                                         reduce(operator.or_, flt))))
        for i in res:
            base_asset = i.base_asset_id
            quote_asset = i.quote_asset_id

            result[f"{base_asset}/{quote_asset}"] = {"base_asset_id": i.base_asset_id,
                                                     "quote_asset_id": i.quote_asset_id,
                                                     "ticker": {"gck": i.ticker}}

        res_ems = EMSSymbols.select(EMSSymbols.base_asset_id, EMSSymbols.quote_asset_id, EMSSymbols.ticker, EMSSymbols.source).\
            where(reduce(operator.and_, ((EMSSymbols.status == 'active'),
                                         reduce(operator.or_, flt_ems))))
        for i in res_ems:
            base_asset = i.base_asset_id
            quote_asset = i.quote_asset_id

            if f"{base_asset}/{quote_asset}" in result:
                result[f"{base_asset}/{quote_asset}"]["ticker"]["ems"] = i.ticker
            else:
                result[f"{base_asset}/{quote_asset}"] = {"base_asset_id": i.base_asset_id,
                                                         "quote_asset_id": i.quote_asset_id,
                                                         "ticker": {"ems": i.ticker}}
    return result


def get_orders_data(limit, page, status, trader_identifier=None):
    """
    获取 orders 表数据
    """
    # 要查询的字段
    fields = [Orders.order_alias, Orders.order_id, Orders.txn_alias, Orders.user_id, Orders.trader_identifier, 
              Orders.base_asset, Orders.quote_asset, Orders.quantity, Orders.quantity, Orders.leaves_quantity,
              Orders.filled_quantity, Orders.created_at, Orders.side, Orders.status, Orders.price, Orders.avg_price, 
              Orders.fee, Orders.fee_type, Orders.fee_total, Orders.fee_notional, Orders.dealers, Orders.total, 
              Orders.entity, Orders.notional, Orders.raw_price, Orders.fee_pct, Orders.markup, Orders.markup_type,
              Orders.note, Orders.account_id, Orders.vault_id, Orders.hedge]
    flt = [Orders.status != OrderStatusEnum.Deleted]
    if status:
        if status == "filled":  # 包含完全成交的和部分成交的
            flt.append(Orders.status.in_([OrderStatusEnum.get_const_obj("filled"), 
            OrderStatusEnum.get_const_obj("partially filled")]))
        else:
            flt.append(Orders.status == OrderStatusEnum.get_const_obj(status))

    if trader_identifier:
        flt.append(Orders.trader_identifier == trader_identifier)

    if flt:
        orders = Orders.select(*fields).where(*flt).order_by(Orders.created_at.desc())

    count = orders.count()

    if limit and page:
        orders = orders.paginate(int(page), int(limit))

    open_orders = get_ems_symbol_by_open_orders()

    order_list = []
    for order in orders:
        obj = model_to_dict(order, fields_from_query=Orders.select(*fields))
        symbol = f"{obj.get('base_asset', '')}/{obj.get('quote_asset', '')}"
        subscribe = ""
        # Orders 对象转字典
        update_dic = {
            "trader_email": "",
            "user_email": "",
            "account_name": "",
            "subscribe": "",
            "symbol": symbol
        }
        for key, value in obj.items():
            if isinstance(value, CustomizeEnum):    # 读取 enum 对象的值
                obj[key] = value.value
            if key == "trader_identifier" and value:
                trader_email = get_email_by_user_id(value)
                update_dic["trader_email"] = trader_email if trader_email else ""
            if key == "user_id" and value:
                user_email = get_email_by_user_id(value)
                update_dic["user_email"] = user_email if user_email else ""
            if key == "account_id" and value:
                account_name = get_account_name(value)
                update_dic["account_name"] = account_name
            if key == "hedge" and value:
                update_dic["hedge_type"] = obj["hedge"]
            if key == "dealers" and value and obj.get('status', '') == 'open':
                dealers = value.split(',')
                for k in dealers:
                    ticker_gck = open_orders[symbol]['ticker'].get('gck', '')
                    ticker_ems = open_orders[symbol]['ticker'].get('ems', '')
                    if k == "gck" and ticker_gck:
                        depth = redis_cli.json_get(f"{k}_quote_{ticker_gck}_depth")
                        if not depth:
                            continue
                        if 'timestamp' in depth and int(time.time() - int(depth['timestamp']) / 1000) > RedisTimeOut:
                            continue
                        subscribe = f"{k}_{ticker_gck}"
                    elif k != "gck" and ticker_ems:
                        depth = redis_cli.json_get(f"{k}_quote_{ticker_ems}_depth")
                        if not depth:
                            continue
                        if 'timestamp' in depth and int(time.time() - int(depth['timestamp']) / 1000) > RedisTimeOut:
                            continue
                        subscribe = f"{k}_{ticker_ems}"
                update_dic["subscribe"] = subscribe
        obj.update(update_dic)
        obj.pop("hedge")

        com_side = -1 if obj['side'] == "sell" else 1
        if obj['notional'] == 'base':
            markup_notional = str(Calc(Calc((Calc(obj['price']) - obj['avg_price']) * com_side) * obj['filled_quantity']))
        else:
            base_quantity = Calc(Calc(obj['filled_quantity'])/obj['price'])
            markup_notional = str(Calc(Calc((Calc(obj['price']) - obj['avg_price']) * com_side) * base_quantity))

        obj['markup_notional'] = markup_notional

        if Calc(obj["filled_quantity"]) == 0:
            obj["filled_pct"] = "0"
        else:
            obj["filled_pct"] = str(Calc(Calc(obj["filled_quantity"]) / Calc(obj["quantity"])))
        order_list.append(obj)

    return order_list, count


def check_parameter(request):
    # 将 grpc 的 message 转为字典
    # including_default_value_fields 将未传的参数也会转化
    # preserving_proto_field_name 保留原本的参数名，不会进行大小写转换
    parameter = MessageToDict(request, including_default_value_fields=True, preserving_proto_field_name=True)
    need_check_quantity = ['quantity', 'limit_price']
    for key, val in parameter.items():

        if not val:
            logger.error(f"SendLimitQuoteFill invalid argument, {key} is empty!")
            text = f"{key} is empty!"
            raise ZCException(text)

        if key in need_check_quantity and float(val) <= 0:
            logger.error(f"SendLimitQuoteFill invalid argument, {key} must be greater than 0!")
            text = f"{key} must be greater than 0!"
            raise ZCException(text)

        if key == "side" and val != "buy" and val != "sell":
            logger.error("SendLimitQuoteFill invalid argument, side type incorrect")
            text = "side type incorrect"
            raise ZCException(text)

        if key == "fee_type" and val != "separate":
            logger.error("SendLimitQuoteFill: fee_type type incorrect!")
            raise ZCException("fee_type type incorrect!")

        if key == "request_type" and val != "live hedge":
            logger.error("SendLimitQuoteFill: request type is not exist")
            raise ZCException("request type is not exist!")

        if key == "entity" and val not in ["zerocap", "vesper"]:
            logger.error("SendLimitQuoteFill: Invalid entity!")
            raise ZCException("Invalid entity!")


def check_get_quote_parameter(request):
    # 将 grpc 的 message 转为字典
    # including_default_value_fields 将未传的参数也会转化
    # preserving_proto_field_name 保留原本的参数名，不会进行大小写转换
    parameter = MessageToDict(request, including_default_value_fields=True, preserving_proto_field_name=True)
    need_check_empty = ['user_id', 'account_id', 'vault_id', 'symbol', 'quote_type', 'quantity', 'notional', 'entity',
                        'side', 'markup_type', 'fee_notional', 'fee_type', 'raw_price', 'price_mode']
    # fee、markup、quote_price
    need_check_quantity = ['quantity']
    need_check_isdigit = ['markup']
    for key, val in parameter.items():

        # 需要校验参数need_check_empty不能为空
        if key in need_check_empty and not val:
            logger.error(f"GetQuote invalid argument, {key} is empty!")
            text = f"{key} is empty!"
            raise ZCException(text)

        # 需要校验参数need_check_isdigit为正整数
        if key in need_check_isdigit and val and not val.isdigit():
            logger.error(f"GetQuote invalid argument, {key} must be a positive integer")
            text = f"{key} must be a positive integer"
            raise ZCException(text)

        # fee_notional,检查fee
        if key == "fee_notional":

            # 不填写 fee 默认为 0
            if not parameter["fee"]:
                parameter["fee"] = "0"
            
            if val == 'bps' and not parameter["fee"].isdigit():
                logger.error(f"GetQuote invalid argument, {key} must be a positive integer")
                text = f"{key} must be a positive integer"
                raise ZCException(text)
            if (val == 'base' or val == 'quote') and float(parameter["fee"]) <= 0:
                logger.error(f"GetQuote invalid argument, fee must be greater than 0!")
                text = f"fee must be greater than 0!"
                raise ZCException(text)

        # 需要校验quantity
        if key in need_check_quantity:
            if not val:
                logger.error(f"GetQuote invalid argument, {key} is empty!")
                text = f"{key} is empty!"
                raise ZCException(text)
            if not Calc.is_num(val):
                logger.error(f"GetQuote invalid argument, {key} is not a number!")
                text = f"{key} is not a number!"
                raise ZCException(text)
            if float(val) <= 0:
                logger.error(f"GetQuote invalid argument, {key} must be greater than 0!")
                text = f"{key} must be greater than 0!"
                raise ZCException(text)

        # # fee_notional为base时,fee_type不能选included
        # if key == "fee_notional" and val == "base" and parameter["fee_type"] == "included":
        #     logger.error(f"GetQuote invalid argument, fee type invalid!")
        #     text = f"fee type invalid!"
        #     raise ZCException(text)

        # 固定询价,检查quote_price
        if key == "quote_type" and val == "Fixed":
            if not parameter["quote_price"]:
                logger.error(f"GetQuote invalid argument, quote_price is empty!")
                text = f"quote_price is empty!"
                raise ZCException(text)
            if not Calc.is_num(parameter["quote_price"]):
                logger.error(f"GetQuote invalid argument, quote_price is not a number!")
                text = f"quote_price is not a number!"
                raise ZCException(text)
            if float(parameter["quote_price"]) <= 0:
                logger.error(f"GetQuote invalid argument, quote_price must be greater than 0!")
                text = f"quote_price must be greater than 0!"
                raise ZCException(text)

        if key == "side" and val != "buy" and val != "sell" and val != "two_way":
            logger.error(f"GetQuote invalid argument, side type incorrect")
            text = "side type incorrect"
            raise ZCException(text)

        if key == "fee_type" and val != "separate" and val != "included":
            logger.error("GetQuote: fee_type type incorrect!")
            raise ZCException("fee_type type incorrect!")

        if key == "entity" and val not in ["zerocap", "vesper"]:
            logger.error("GetQuote: Invalid entity!")
            raise ZCException("Invalid entity!")

        if key == "markup_type" and val not in ["bps", "pips"]:
            logger.error("GetQuote: Invalid markup_type!")
            raise ZCException("Invalid markup_type!")

        if key == "settlement_destination" and val not in ["EXT Bank", "EXT Wallet", "Portal", ""]:
            logger.error("GetQuote: Invalid settlement_destination!")
            raise ZCException("Invalid settlement_destination!")

        if key == "price_mode" and val not in ["spread", "mid"]:
            logger.error("GetQuote: Price mode must be spread or mid!")
            raise ZCException("Price mode must be spread or mid!")


def check_limit_single_trader_size(check_data):
    # 获取组用户id或组名以及单笔交易限额
    id_or_group_name = get_trader_id_or_group_name(check_data["trader_identifier"])
    usd_limit = get_single_trade_size_limit_by_userid_and_assetid(id_or_group_name, "USD", "quote")

    # 计算单笔交易量
    usd_quantity = Calc(check_data["price"]) * Calc(check_data["quantity"])
    result = True
    if usd_limit:
        if Calc(usd_quantity).value > Calc(usd_limit).value:
            result = False
    return result


def check_single_and_exposure_limit(symbol, dealers, trader_identifier, quantity, side, notional, limit_price):
    markets = dealers.split(",")

    check_data = {
        "base_asset": symbol.split("/")[0],
        "quote_asset": symbol.split("/")[1],
        "trader_identifier": trader_identifier,
        "price": limit_price,
        "quantity": quantity,
        "symbol": symbol,
        "side": side,
    }

    if notional == "base":
        quote_quantity = Calc(quantity) * Calc(limit_price)
        check_data["quote_quantity"] = str(quote_quantity)
    elif notional == "quote":
        check_data["quote_quantity"] = quantity
    else:
        logger.error("SendLimitQuoteFill: notional type incorrect!")
        raise ZCException("notional type incorrect!")

    for market in markets:
        check_data["market"] = market

        single_result = check_limit_single_trader_size(check_data)
        if not single_result:
            logger.error("SendLimitQuoteFill: trade exceeds single trade limit")
            raise ZCException("trade exceeds single trade limit")

        # exposure_result = check_exposure_limit(check_data)
        # if not exposure_result:
        #     logger.error("SendLimitQuoteFill: trade exceeds exposure limit")
        #     raise ZCException("trade exceeds exposure limit!")


def calculate_fee_total(fee, notional, fee_notional, quantity, limit_price, side):
    # 根据 limit_price 计算 fee_total, quantity, total
    if notional == "base":
        quote_quantity = Calc(Calc(quantity) * Calc(limit_price))
    else:
        quote_quantity = quantity

    fee_pct = None
    if fee_notional == "bps":
        fee_pct = Calc(float(fee) / 10000)
        fee_total = Calc(Calc(quote_quantity) * Calc(fee_pct))
    elif fee_notional == "base":
        fee_total = Calc(Calc(fee) * Calc(limit_price))
    elif fee_notional == "quote":
        fee_total = fee
    else:
        logger.error("SendLimitQuoteFill: fee notional type incorrect!")
        raise ZCException("fee notional type incorrect!")

    if side == "buy":
        total = Calc(Calc(quote_quantity) + Calc(fee_total))
    elif side == "sell":
        total = Calc(Calc(quote_quantity) - Calc(fee_total))
    else:
        logger.error("SendLimitQuoteFill: side type incorrect!")
        raise ZCException("side type incorrect!")
    return str(fee_total), str(quote_quantity), str(total), str(fee_pct)


def calculate_raw_price(limit_price, markup, markup_type, side):
    # raw_price: 实际去 talos 下单的价格
    if markup_type == "bps":
        if side == "buy":
            new_markup = Calc(1) - Calc(Calc(markup)/Calc(10000))
        else:
            new_markup = Calc(1) + Calc(Calc(markup)/Calc(10000))
        raw_price = Calc(limit_price) * Calc(new_markup)
    elif markup_type == "pips":
        if side == "buy":
            raw_price = Calc(limit_price) - Calc(Calc(markup)/Calc(10000))
        else:
            raw_price = Calc(limit_price) + Calc(Calc(markup)/Calc(10000))
    else:
        logger.error("SendLimitQuoteFill: markup_type type incorrect!")
        raise ZCException("markup_type type incorrect!")

    if Calc(raw_price).value <= Calc(0).value:
        logger.error("SendLimitQuoteFill: raw_price must be greater than 0!")
        raise ZCException("raw_price must be greater than 0!")

    return str(raw_price)


def insert_orders(order):
    order_lst = [order]
    Orders.insert_many(order_lst).execute()


def update_order(update_data, order_id):
    Orders.update(update_data).where(Orders.order_id == order_id).execute()


def cancel_same_quote(quote):
    update_data = {"canceled_at": int(time.time() * 1000), "status": 'canceled'}
    operate = quote.get("operate", "")
    if operate == "edit_quote":
        old_alias = quote.get("old_alias", "")
        Quotes.update(update_data).where(Quotes.quote_alias == old_alias).execute()
    else:
        Quotes.update(update_data).where(Quotes.user_id == quote["user_id"],
                                         Quotes.base_asset == quote["base_asset"],
                                         Quotes.quote_asset == quote["quote_asset"],
                                         Quotes.quantity == quote["quantity"],
                                         Quotes.side == quote["side"],
                                         Quotes.status == "open").execute()


def get_fees(fee_notional, fee, base_asset, quote_asset):
    # 生成交易凭据的 fees 计算
    if fee_notional == "bps":
        fee_pct = Calc(fee) / Calc(100)
        fees = f"{str(fee_pct)} %"
    elif fee_notional == "base":
        fees = f"{fee} {base_asset}"
    elif fee_notional == "quote":
        fees = f"{fee} {quote_asset}"
    else:
        logger.error("SendLimitQuoteCancel: fee notional invalid!")
        raise ZCException("fee notional invalid!")
    return fees


def get_txn_by_order_id(order_id):
    order_res = Orders.select(Orders.txn_alias, Orders.quantity).where(Orders.order_id == order_id).first()
    if order_res:
        txn_alias = order_res.txn_alias
        txn_res = Transactions.select().where(Transactions.txn_alias == txn_alias).first()
        if txn_res:
            return order_res, txn_res
        return None, None
    logger.error("SendLimitQuoteCancel: invalid order id!")
    raise ZCException("invalid order id!")


def get_receipt_data(txn_res):

    fee_notional = txn_res.fee_notional
    fee = txn_res.fee
    base_asset = txn_res.base_asset
    quote_asset = txn_res.quote_asset

    receipt_data = {
        "txn_alias": txn_res.txn_alias,
        "account_id": txn_res.account_id,
        "user_id": txn_res.user_id,
        "base_asset": base_asset,
        "quote_asset": quote_asset,
        "created_at": txn_res.created_at,
        "side": txn_res.side,
        "quantity": txn_res.quantity,
        "price": txn_res.quote_price,
        "quote_quantity": txn_res.quote_quantity,
        "fees": "",
        "total":txn_res.total,
        "entity":txn_res.entity,
        "trader_identifier": txn_res.trader_identifier,
        "hedge": txn_res.hedge,
        "fee_notional": txn_res.fee_notional,
        "order_type": txn_res.order_type.value
    }

    fees = get_fees(fee_notional, fee, base_asset, quote_asset)
    receipt_data["fees"] = fees

    return receipt_data


def update_order_by_alias(order_alias, update_data):
    order = Orders.get_or_none(Orders.order_alias == order_alias)
    if not order:
        logger.error("SendLimitQuoteCancel: invalid order alias!")
        raise ZCException("invalid order alias!")
    Orders.update(update_data).where(Orders.order_alias == order_alias).execute()


def get_kyc_and_pa_and_name_by_account(account_id):
    """
        1.根据表中的 account id 查询 entity account. 获取到 entity_id;
        2.然后查 entity_relation，定位 parent_entity_id 和 parent_entity_type，
          然后到对应的 company、trust、group kyc_status; 如果是group则在individual查kyc_status 以及name
        3.如果 entity_relation 中没有，则从 individual表查 kyc_status,name;
        4:根据 account_id 到 PrimeAgreementHistory 查询pa_agreed
        """
    response = EntityAccount.select(EntityAccount.entity_id).where(EntityAccount.account_id == account_id,
                                                                   EntityAccount.status == 'active').first()

    if not response:
        logger.error(f"account_id: {account_id} is not exist in EntityAccount")
        raise ZCException(f"account_id: {account_id} is not exist in EntityAccount")
    entity_id = response.entity_id

    response = EntityRelation.select(EntityRelation.parent_entity_id, EntityRelation.parent_entity_type,
                                     EntityRelation.entity_id).where(
        EntityRelation.parent_entity_id == entity_id, EntityRelation.status == "active").first()
    if not response:
        res = Individuals.select(Individuals.kyc_status, Individuals.first_name, Individuals.last_name).where(
            Individuals.entity_id == entity_id).first()
        if not res:
            logger.error(f"entity_id: {entity_id} is not exist in Individuals")
            raise ZCException(f"entity_id: {entity_id} is not exist in Individuals")
        kyc_approved = res.kyc_status
        first_name = res.first_name if res.first_name else ""
        last_name = res.last_name if res.last_name else ""
        name = first_name + " " + last_name
    else:
        parent_entity_id = response.parent_entity_id
        parent_entity_type = response.parent_entity_type

        if parent_entity_type == "group":
            group_res = Groups.select(Groups.group_name).where(Groups.entity_id == parent_entity_id,
                                                               Groups.status == 'active').first()
            name = group_res.group_name
            kyc_approved = True

        elif parent_entity_type == "company":
            res = Companys.select(Companys.kyc_status, Companys.company_name).where(
                Companys.entity_id == parent_entity_id, Companys.status == 'active').first()
            kyc_approved = res.kyc_status
            name = res.company_name

        elif parent_entity_type == "trust":
            res = Trusts.select(Trusts.kyc_status, Trusts.trust_name).where(
                Trusts.entity_id == parent_entity_id, Trusts.status == 'active').first()
            kyc_approved = res.kyc_status
            name = res.trust_name
        else:
            logger.error("Invalid parent entity type!")
            raise ZCException("Invalid parent entity type!")
    pa_obj = PrimeAgreementHistory.select(PrimeAgreementHistory.pa_agreed).where(
        PrimeAgreementHistory.account_id == account_id).first()

    pa_agreed = pa_obj.pa_agreed if pa_obj else False

    return kyc_approved, pa_agreed, name


def get_customerinfo_account_id(account_id):
    """
    OtcFee.trade_entity != '*',
    OtcFee.fee_type != '*',
    OtcFee.above_markup_type != '*',
    OtcFee.under_markup_type != '*'
    """
    if account_id and account_id != '*':
        response = OtcFee.select().where(
            OtcFee.status == 'active',
            OtcFee.account_id == account_id,
            ).order_by(
            OtcFee.created_at.desc())
    else:
        response = OtcFee.select().where(
            OtcFee.status == 'active',
            OtcFee.account_id == '*',
            ).order_by(
            OtcFee.created_at.desc())
    result = []

    def filter_nan(item_str):
        return item_str if item_str != "nan" else ""

    kyc_approved, pa_agreed, counterpart = (False, False, "")
    if account_id and account_id != "*":
        try:
            kyc_approved, pa_agreed, counterpart = get_kyc_and_pa_and_name_by_account(account_id)
            account_name = get_account_name(account_id)
        except Exception as e:
            account_name = ''
    else:
        account_name = ''

    key = ["yahoo_quote_EUR/USD", "yahoo_quote_AUD/USD", "yahoo_quote_GBP/USD"]
    eur_price, aud_price, gpb_price = 0, 0, 0
    price_list = redis_cli.jsonmget('.', key)
    if price_list:
        [eur_price, aud_price, gpb_price] = price_list
    
    # 先根据otc的结果给result填充数据
    for item in response:
        filter_amount = float(item.filter_amount)
        filter_amount_usd = float(filter_amount)
        # 计算对应的 USD 价值
        notional_unit = item.notional_unit
        if notional_unit == 'EUR' and eur_price:
            filter_amount_usd = filter_amount * eur_price
        elif notional_unit == 'AUD' and aud_price:
            filter_amount_usd = filter_amount * aud_price
        elif notional_unit == 'GBP' and gpb_price:
            filter_amount_usd = filter_amount * gpb_price

        filter_amount_usd = retain_significant_digits(filter_amount, 2)
        result.append({
            "counterpart": counterpart,
            "trade_entity": filter_nan(item.trade_entity).lower(),
            "symbol_type": filter_nan(item.symbol_type).lower(),
            "markup_under": filter_nan(item.markup_under),
            "above_markup_type": filter_nan(item.above_markup_type).lower(),
            "under_markup_type": filter_nan(item.under_markup_type).lower(),
            "markup_above": filter_nan(item.markup_above),
            "fee_under": filter_nan(item.fee_under),
            "fee_above": filter_nan(item.fee_above),
            "fee_type": filter_nan(item.fee_type).lower(),
            "above_fee_unit": filter_nan(item.above_fee_unit).lower(),
            "under_fee_unit": filter_nan(item.under_fee_unit).lower(),
            "created_at": iso8601(item.created_at),
            "last_updated": iso8601(item.last_updated),
            "status": filter_nan(item.status),
            "filter_amount": str(filter_amount),
            "filter_amount_usd": filter_amount_usd,
            "notional_unit": notional_unit,
            "account_id": item.account_id,
            "trade_identifier": item.trade_identifier
        })

    return result, kyc_approved, pa_agreed, account_name


def get_all_active_symbols(source, platform):
    return Symbols.select().where(
        Symbols.status == 'active',
        Symbols.source == source,
        Symbols.platform.contains(platform),
    )


def get_all_active_ems_symbols(quote, sources):

    sql = """SELECT 
                COALESCE ( t1.base_asset_id, t2.base_asset_id ) as base_asset_id,
                COALESCE ( t1.quote_asset_id, t2.quote_asset_id ) as quote_asset_id,
                COALESCE ( t1.ticker, t2.ticker ) as ticker,
                COALESCE ( t1.is_quote, '{}' ) as is_quote,
                COALESCE ( t2.no_quote, '{}' ) as no_quote
            FROM 
                (select base_asset_id, quote_asset_id, ticker,array_agg(source) as is_quote from ems_symbols 
                WHERE is_quote=TRUE AND status='active' %s 
                group by ticker, base_asset_id, quote_asset_id) as t1 
            full outer JOIN 
                (select base_asset_id, quote_asset_id, ticker,array_agg(source) as no_quote from ems_symbols 
                WHERE is_quote=FALSE AND status='active' %s
                group by ticker, base_asset_id, quote_asset_id) as t2 
            ON t1.ticker = t2.ticker;"""

    if quote == 'limit':
        sql = """select 
                    base_asset_id, 
                    quote_asset_id, 
                    ticker,array_agg(source) as is_quote, 
                    COALESCE ( '{}' ) as no_quote 
                from 
                    ems_symbols 
                WHERE is_quote=TRUE AND status='active' AND supplier='talos' AND source in %s group by ticker, base_asset_id, quote_asset_id""" % str(sources)
    elif quote == 'rfq':
        sql = sql % ("AND (supplier='talos' OR supplier='ccxt') AND source in %s" % str(sources),
                     "AND (supplier='talos' OR supplier='ccxt') AND source in %s" % str(sources))
    elif quote == 'calculator':
        sql = sql % ("AND (supplier='talos' OR supplier='ccxt' OR ticker='AAA/AAA') AND source in %s" % str(sources),
                     "AND (supplier='talos' OR supplier='ccxt' OR ticker='AAA/AAA') AND source in %s" % str(sources))
    elif quote == 'all':
        sql = sql % ("AND source in %s" % str(sources), "AND source in %s" % str(sources))

    all_symbols = conn.execute(sql).fetchall()

    result = []
    base_result = {}
    quote_result = {}
    tickers = {}
    if all_symbols:
        for i in all_symbols:
            base_asset_id = i[0]
            quote_asset_id = i[1]
            ticker = i[2]
            is_quote = i[3]
            no_quote = i[4]
            if i[4] == ["custom"]:
                no_quote = []

            if ticker not in tickers:
                tickers[ticker] = no_quote

            result.append({
                "base_asset_id": base_asset_id,
                "quote_asset_id": quote_asset_id,
                "ticker": ticker,
                "is_quote": is_quote,
                "no_quote": no_quote})

            if base_asset_id in base_result:
                base_result[base_asset_id].append(quote_asset_id)
            else:
                base_result[base_asset_id] = [quote_asset_id]

            if quote_asset_id in quote_result:
                quote_result[quote_asset_id].append(base_asset_id)
            else:
                quote_result[quote_asset_id] = [base_asset_id]

    # 查询talos和gck的共同数据
    if quote == "all":
        # 获取symbol表中，platform包含ems,source为gck的数据
        res = get_all_active_symbols('gck', 'ems')

        for i in res:
            if f"{i.base_asset_id}/{i.quote_asset_id}" not in tickers:
                result.append({
                    "base_asset_id": i.base_asset_id,
                    "quote_asset_id": i.quote_asset_id,
                    "ticker": f"{i.base_asset_id}/{i.quote_asset_id}",
                    "is_quote": [],
                    "no_quote": [i.source]})
            else:
                tickers[f"{i.base_asset_id}/{i.quote_asset_id}"].append(i.source)

            if i.base_asset_id in base_result:
                base_result[i.base_asset_id].append(i.quote_asset_id)
            else:
                base_result[i.base_asset_id] = [i.quote_asset_id]

            if i.quote_asset_id in quote_result:
                quote_result[i.quote_asset_id].append(i.base_asset_id)
            else:
                quote_result[i.quote_asset_id] = [i.base_asset_id]

        # ems_symbol与symbol重复交易对,结果no_quote新增gck
        for data in result:
            if data["ticker"] in tickers:
                data["no_quote"] = tickers[data["ticker"]]

    all_base = []
    all_quote = []
    ticker_list = []
    # 获取对应的币种的名字
    all_symbols_name = get_all_symbols_name()
    for i in result:
        all_base.append(i['base_asset_id'])
        all_quote.append(i['quote_asset_id'])

        # 说明 cumberland 支持该交易对, 需要将 no_quote 中的 cumberland 移除, 并添加到 is_quote 中
        if "cumberland" in i['no_quote']:
            i['no_quote'].remove("cumberland")
            i['is_quote'].append("cumberland")

        d = dict(
            b=i['base_asset_id'],
            q=i['quote_asset_id'],
            b_n=all_symbols_name.get(i['base_asset_id'], None),
            q_n=all_symbols_name.get(i['quote_asset_id'], None),
            s=f"{i['ticker'].replace('/', '-')}",
            t=i['ticker'],
            is_q=sorted(i['is_quote']),
            no_q=sorted(i['no_quote'])
        )
        ticker_list.append(d)
    all_base = list(set(all_base))
    all_quote = list(set(all_quote))

    bases = []
    for base in all_base:
        d = dict(
            b=base,
            b_n=all_symbols_name.get(base, None),
            a=list(set(base_result[base]))
        )
        bases.append(d)

    quotes = []
    for quote in all_quote:
        d = dict(
            q=quote,
            q_n=all_symbols_name.get(quote, None),
            a=list(set(quote_result[quote]))
        )
        quotes.append(d)

    # 按照symbol排序
    ticker_list.sort(key=lambda x: x['s'])

    return bases, quotes, ticker_list


def get_all_symbols_name():
    results = {}
    response = Assets.select()

    if response:
        for i in response:
            results[i.id] = i.name
        return results
    return None


def get_asset_id_map(all_symbols):
    asset_id_list = list(set([a['base_asset_id'] for a in all_symbols])) + list(set([a['quote_asset_id'] for a in all_symbols]))
    asset_id_list = list(map(lambda x: "USDT_ERC20" if x == 'USDT' else x, asset_id_list))
    response = Assets.select(Assets.id, Assets.name).where(Assets.id.in_(asset_id_list))
    result = []
    all_asset = []
    for symbol in all_symbols:
        if 'gck' in symbol["source"]:
            result.append({
                "asset_id": symbol['base_asset_id'],
                "name": symbol['ticker'].split('/')[0]
            })
            all_asset.append(symbol['base_asset_id'])

    for i in response:
        asset_id = 'USDT' if i.id == 'USDT_ERC20' else i.id
        if asset_id not in all_asset:
            result.append({
                "asset_id": asset_id,
                "name": i.name
            })
    return result


def query_user_id_by_ems(account_id, operate):
    users_list = []

    role_dict = {1: "viewer", 2: "kyc", 3: "trader", 4: "admin", 0: "client"}
    # 通过account_id查询users
    if account_id:
        users = get_users_by_account(account_id)
    else:
        users = Users.select(Users, Individuals).join(Individuals, JOIN.INNER,
                                                      on=(Users.entity_id == Individuals.entity_id)) \
            .where(~Users.email.contains('removed'),
                   Users.status == 'active', Individuals.status == 'active')


    if operate == "emsgetquote":
        users_list.extend(
            {
                "created_at": str(user.created_at),
                "email": user.email,
                "role": role_dict.get(user.role, ""),
                "updated_at": str(user.updated_at),
                "user_id": user.user_id,
                "firstname": user.individuals.first_name,
                "lastname": user.individuals.last_name,
            }
            for user in users
        )
    elif operate == 'risk':
        users = users.where(Users.role >= 3,
                            (Users.tenant != 'viva'))
        users_list.extend(
            {
                "user_id": user.user_id,
                "email": user.email,
                "firstname": user.individuals.first_name,
                "lastname": user.individuals.last_name,
                "role": role_dict.get(user.role, ""),
            }
            for user in users
        )
    return users_list


def get_users_by_account(account_id):
    """
    1.根据表中的 account id 查询 entity account. 获取到 entity_id;
    2.然后查 entity_relation，定位 parent_entity_id 并获得对应的entity_id;
    3.如果 entity_relation 中没有，直接使用entity_id查询user;
    4.通过存在 则使用对应的entity_id到users表里获取user
    """
    response = EntityAccount.select(EntityAccount.entity_id).where(EntityAccount.account_id == account_id, 
                                                                   EntityAccount.status == "active").first()
    if not response:
        logger.error(f"account_id: {account_id} is not exist in EntityAccount")
        raise ZCException(f"account_id: {account_id} is not exist in EntityAccount")
    entity_id = response.entity_id

    response = EntityRelation.select(EntityRelation.parent_entity_id, EntityRelation.parent_entity_type,
                                     EntityRelation.entity_id).where(
        EntityRelation.parent_entity_id == entity_id, EntityRelation.status == "active")
    entity_list = [entity.entity_id for entity in response]
    base_users = Users.select(Users, Individuals).join(Individuals, JOIN.INNER,
                                                       on=(Users.entity_id == Individuals.entity_id)) \
        .where(~Users.email.contains('removed'),
               Users.status == 'active',
               Individuals.status == 'active')
    if not entity_list:
        users = base_users.where(Users.entity_id == entity_id)
    else:
        users = base_users.where(Users.entity_id.in_(entity_list))
    return users


def get_company_info(entity_id):
    entity = Companys.select().where((Companys.entity_id == entity_id) & (Companys.status == "active")).first()
    if not entity:
        raise ZCException(1008, f"Company Entity ID: {entity_id} is not exist.")
    entity_dict = {
        "entity_id": entity.entity_id,
        "company_name": entity.company_name,
        "company_number": entity.company_number,
        "address": entity.address,
        "person_control": entity.person_control,
        "country": entity.country,
        "kyc_status": entity.kyc_status,
        "sp_wsc": entity.sp_wsc,
        "status": entity.status,
        "created_at": entity.created_at,
        "last_updated": entity.last_updated,
    }
    return entity_dict


def get_trust_info(entity_id):
    entity = Trusts.select().where((Trusts.entity_id == entity_id) & (Trusts.status == "active")).first()
    if not entity:
        raise ZCException(1008, f"Trust Entity ID: {entity_id} is not exist.")
    entity_dict = {
        "entity_id": entity.entity_id,
        "trust_name": entity.trust_name,
        "trustee_name": entity.trustee_name,
        "address": entity.address,
        "beneficiary_name": entity.beneficiary_name,
        "phone": entity.phone,
        "country": entity.country,
        "kyc_status": entity.kyc_status,
        "sp_wsc": entity.sp_wsc,
        "status": entity.status,
        "created_at": entity.created_at,
        "last_updated": entity.last_updated,
    }
    return entity_dict


def get_group_info(entity_id):
    entity = Groups.select().where((Groups.entity_id == entity_id) & (Groups.status == "active")).first()
    if not entity:
        raise ZCException(1008, f"Group Entity ID: {entity_id} is not exist.")
    entity_dict = {
        "entity_id": entity.entity_id,
        "group_name": entity.group_name,
        "status": entity.status,
        "created_at": entity.created_at,
        "last_updated": entity.last_updated,
    }
    return entity_dict


def get_individual_info(entity_id):
    entity = Individuals.select().where((Individuals.entity_id == entity_id) & (Individuals.status == "active")). \
        first()
    entity_dict = {}
    if entity:
        entity_dict = {
            "entity_id": entity.entity_id,
            "first_name": entity.first_name,
            "last_name": entity.last_name,
            "tenant": entity.tenant,
            "address": entity.address,
            "phone": entity.phone,
            "country": entity.country,
            "kyc_status": entity.kyc_status,
            "sp_wsc": entity.sp_wsc,
            "status": entity.status,
            "created_at": entity.created_at,
            "last_updated": entity.last_updated,
        }
    return entity_dict


def get_individual_kyc_status_sp_wsc(individual_list, entity_list=None):
    if not individual_list:
        return {}, entity_list

    individual_status_dict = {}
    individuals = Individuals.select(Individuals.entity_id, Individuals.kyc_status, Individuals.sp_wsc).where(
        (Individuals.entity_id.in_(individual_list)) & (Individuals.status == "active"))

    if not individuals and entity_list:
        entity_list = list(set(entity_list).difference(set(individual_list)))

    for idv in individuals:
        individual_status_dict[idv.entity_id] = {
            "kyc_status": idv.kyc_status,
            "sp_wsc": idv.sp_wsc
        }
    return individual_status_dict, entity_list


def get_company_kyc_status_sp_wsc(company_list, entity_list):
    if not company_list:
        return {}, entity_list

    company_status_dict = {}
    companies = Companys.select(Companys.entity_id, Companys.kyc_status, Companys.sp_wsc).where(
        (Companys.entity_id.in_(company_list)) & (Companys.status == "active"))

    if not companies:
        entity_list = list(set(entity_list).difference(set(company_list)))

    for cmp in companies:
        company_status_dict[cmp.entity_id] = {
            "kyc_status": cmp.kyc_status,
            "sp_wsc": cmp.sp_wsc
        }
    return company_status_dict, entity_list


def get_trust_kyc_status_sp_wsc(trust_list, entity_list):
    if not trust_list:
        return {}, entity_list

    trust_status_dict = {}
    trusts = Trusts.select(Trusts.entity_id, Trusts.kyc_status, Trusts.sp_wsc).where(
        (Trusts.entity_id.in_(trust_list)) & (Trusts.status == "active"))

    if not trusts:
        entity_list = list(set(entity_list).difference(set(trust_list)))

    for trust in trusts:
        trust_status_dict[trust.entity_id] = {
            "kyc_status": trust.kyc_status,
            "sp_wsc": trust.sp_wsc
        }
    return trust_status_dict, entity_list


def get_group_kyc_status_sp_wsc(group_list, entity_list):
    if not group_list:
        return {}, entity_list

    group_status_dict = {}

    response = EntityRelation.select(EntityRelation.entity_id, EntityRelation.parent_entity_id,
                    Individuals.kyc_status, Individuals.sp_wsc).join(Individuals,
                    on=((Individuals.entity_id==EntityRelation.entity_id) & (Individuals.status=='active'))).\
                    where((EntityRelation.parent_entity_id.in_(group_list)) & (EntityRelation.status == "active"))

    if not response:
        return group_status_dict, []

    group_res = Groups.select(Groups.group_name).where((Groups.entity_id.in_(group_list)) & (Groups.status == "active") )
    if not group_res:
        entity_list = list(set(entity_list).difference(set(group_list)))

    for res in response.objects():
        kyc_sp = {
            "kyc_status": res.kyc_status,
            "sp_wsc": res.sp_wsc,
        }
        group_status_dict[res.parent_entity_id] = kyc_sp
    return group_status_dict, entity_list


def get_valid_account_info(account_id_list):
    normal_account = Accounts.select(Accounts.id, Accounts.account_id).where((Accounts.account_id.in_(account_id_list)) &
                                             (Accounts.status == "active") & (Accounts.account_status == "open"))
    normal_account_id = []
    normal_account_dict = {}
    for act in normal_account:
        normal_account_id.append(act.account_id)
        normal_account_dict[act.account_id] = act.id

    account_info = AccountInfo.select(AccountInfo.account_id, AccountInfo.account_name).where(
        (AccountInfo.account_id.in_(normal_account_id)) & (AccountInfo.status == "active"))

    # 真实有效账户信息
    valid_account_info_dict = {}
    valid_account_id_list = []
    for info in account_info:
        valid_account_info_dict[info.account_id] = {
            "account_name": info.account_name,
            "id": normal_account_dict[info.account_id]
        }
        valid_account_id_list.append(info.account_id)
    return valid_account_info_dict, valid_account_id_list


def get_valid_vault_info(account_id_list):
    vaults = Vaults.select(Vaults.account_id, Vaults.vault_id).where(Vaults.account_id.in_(account_id_list) & (Vaults.status == "active"))
    vault_dict = {}
    for val in vaults:
        if val.account_id not in vault_dict:
            vault_dict[val.account_id] = []
        vault_dict[val.account_id].append(val.vault_id)
    return vault_dict


def get_vaild_pa_info(account_id_list):
    pa = PrimeAgreement.select(PrimeAgreement.pa_alias).where(PrimeAgreement.status == "active").order_by(
        PrimeAgreement.created_at.desc()).first()
    if not pa:
        return {}

    pa_history = PrimeAgreementHistory.select(PrimeAgreementHistory.account_id).where(
        (PrimeAgreementHistory.pa_alias == pa.pa_alias) & (PrimeAgreementHistory.account_id.in_(account_id_list)) &
        (PrimeAgreementHistory.pa_agreed == True))

    pa_info = {}
    for ph in pa_history:
        pa_info[ph.account_id] = True
    return pa_info


def get_all_account_info():

    entity_account_sql = """
    -- 获取所有可用 account id 对应的数据
    -- 使用 MAX 的原因是，一个 vault id 只会对应一个 account id
    select acc.account_id, MAX(ai.account_name) as account_name, MAX(v.vault_id) as vault_id,
           -- 以 vault id 分组，整合所有的 entity id(个人)
           string_agg(t.entity_id || '', ',') as entity_ids,
           -- 以 vault id 分组，整合个人的所有实体类型(individual、company、trust、group)
           string_agg(distinct t.parent_entity_id || '', ',') as parent_entity_ids
    from accounts acc
    -- 排除 account_info 中 status 不是 active 的数据
    join account_info ai on acc.account_id = ai.account_id and ai.status='active'
    -- 排除 vaults 中 status 不是 active 的数据
    join vaults v on v.account_id = acc.account_id and v.status='active'
    -- 获取所有用户对应的 account_id，entity_id，和所属的实体类型
    join (
            -- 查询个人对应的 account_id，entity_id
            select ea.account_id, ea.entity_id, '0' as parent_entity_id  from entity_account ea
            join individuals ind on ind.entity_id=ea.entity_id and ind.status='active'
            where ea.status='active'
            union
            -- 查询个人所属实体对应的 account_id，entity_id，及实体类别
            select ea.account_id, er.entity_id, er.parent_entity_id from entity_account ea
            join entity_relation er on er.parent_entity_id=ea.entity_id and er.status='active'
            where ea.status='active'
        ) t on t.account_id=acc.account_id
    -- 排除 accounts 中 status 不是 active 或者 account_status 不是 open 的数据
    where acc.status='active' and acc.account_status='open'
    -- 以 vault id 分组
    group by acc.account_id;
    """
    kyc_sp_sql = """
    -- 获取已经签署 kyc 或者 sp_wsc 的实体
    -- 公司的查询逻辑：获取公司内是否有成员签署了，只要有一个成员签署，则认为该组签署了
    select t.entity_id, (t.kyc_status > 0) as kyc_status, (t.sp_wsc > 0) as sp_wsc, 'company' as entity_type from (
    select entity_id, sum(kyc_status::int) as kyc_status, sum(sp_wsc::int) as sp_wsc
    from companys where kyc_status=TRUE or sp_wsc=TRUE group by entity_id) t
    union
    -- 信托的查询逻辑：获取信托内是否有成员签署了，只要有一个成员签署，则认为该组签署了
    select f.entity_id, (f.kyc_status > 0) as kyc_status, (f.sp_wsc > 0) as sp_wsc, 'trust' as entity_type from (
    select entity_id, sum(kyc_status::int) as kyc_status, sum(sp_wsc::int) as sp_wsc
    from trusts where kyc_status=TRUE or sp_wsc=TRUE group by entity_id) f
    union
    -- 组的查询逻辑：获取组内是否有成员签署了，只要有一个成员签署，则认为该组签署了
    select h.entity_id, (h.kyc_status > 0) as kyc_status, (h.sp_wsc > 0) as sp_wsc, 'group' as entity_type FROM (
    select g.entity_id, sum(ind.kyc_status::int) as kyc_status, sum(ind.sp_wsc::int) as sp_wsc from individuals ind
    join entity_relation er on ind.entity_id = er.entity_id and er.parent_entity_type='group' and er.status='active'
    join groups g on g.entity_id =er.parent_entity_id and g.status='active'
    where (ind.kyc_status=TRUE or ind.sp_wsc=TRUE) and ind.status='active' group by g.entity_id) h;
    """

    entity_account_response = conn.execute(entity_account_sql).fetchall()
    kyc_sp_response = conn.execute(kyc_sp_sql).fetchall()
    kyc_sp_dict = {res[0]: {"kyc_status": res[1],
                            "sp_wsc": res[2],
                            "entity_id":res[0]}
                   for res in kyc_sp_response}

    result = {}
    account_ind_entity = {}
    for ea in entity_account_response:
        account_id = ea[0]
        account_name = ea[1]
        vault_id = ea[2]
        parent_entity_id = ea[4]
        item = {
            "account_id": account_id,
            "account_name": account_name,
            "vault_id": vault_id,
            "role": "approver",
        }

        if parent_entity_id == "0":  # 为 0 代表是个人，需要再查询 individuals 表获取 kyc & sp
            account_ind_entity[account_id] = ea[3]

        kyc_sp = kyc_sp_dict.get(parent_entity_id)
        if not kyc_sp:  # 未找到对应的实体的 kyc & sp 信息则默认全为 false
            entity_ids = ea[3].split(",")
            kyc_sp = {
                "kyc_status": False,
                "sp_wsc": False,
                "entity_id": entity_ids[0]
            }

        item.update(kyc_sp)
        result[ea[0]] = item

    ind_kyc_sp_data, _ = get_individual_kyc_status_sp_wsc(list(account_ind_entity.values()))
    for account_id, entity_id in account_ind_entity.items():
        kyc_sp = ind_kyc_sp_data.get(entity_id)
        if not kyc_sp:
            kyc_sp = {
                "kyc_status": False,
                "sp_wsc": False,
            }
        kyc_sp["entity_id"] = entity_id
        result[account_id].update(kyc_sp)

    return result.values()


def get_account_info_by_ems(request):

    if not request.email:
        result = get_all_account_info()
        return result

    # 通过 email 获取 users的 entity_id
    user = Users.select(Users.entity_id).where((Users.email == request.email) & (Users.status == "active")).first()
    if not user or not user.entity_id:
        return []

    # 通过 entity_id 获取 EntityRelation parent_entity_id, parent_entity_type
    relation = EntityRelation.select(EntityRelation.parent_entity_id, EntityRelation.parent_entity_type, EntityRelation.role).where(
        (EntityRelation.entity_id == user.entity_id) & (EntityRelation.status == "active"))
    entity_info_list = [{"entity_id": user.entity_id, "entity_type": EntityTypeIndividual, "role": "approver"}]
    entity_list = [user.entity_id]

    # 对实体分类
    individual_list = [user.entity_id]
    company_list = []
    trust_list = []
    group_list = []

    for rel in relation:
        if rel.parent_entity_id and rel.parent_entity_id != rel.entity_id:
            entity_info_list.append(
                {"entity_id": rel.parent_entity_id, "entity_type": rel.parent_entity_type, "role": rel.role})
            entity_list.append(rel.parent_entity_id)
            if rel.parent_entity_type == EntityTypeCompany:
                company_list.append(rel.parent_entity_id)
            elif rel.parent_entity_type == EntityTypeTrust:
                trust_list.append(rel.parent_entity_id)
            else:
                group_list.append(rel.parent_entity_id)

    # 获取组，公司，信托下所有成员的kyc和sp_wsc状态
    individual_status_dict, entity_list = get_individual_kyc_status_sp_wsc(individual_list, entity_list)
    company_status_dict, entity_list = get_company_kyc_status_sp_wsc(company_list, entity_list)
    trust_status_dict, entity_list = get_trust_kyc_status_sp_wsc(trust_list, entity_list)
    group_status_dict, entity_list = get_group_kyc_status_sp_wsc(group_list, entity_list)

    entity_account = EntityAccount.select(EntityAccount.entity_id, EntityAccount.account_id).where(
        (EntityAccount.entity_id.in_(entity_list)) & (EntityAccount.status == "active"))

    entity_account_dict = {}
    account_id_list = []
    for ent in entity_account:
        if ent.entity_id not in entity_account_dict:
            entity_account_dict[ent.entity_id] = []
        entity_account_dict[ent.entity_id].append(ent.account_id)
        account_id_list.append(ent.account_id)

    valid_account_info_dict, valid_account_id_list = get_valid_account_info(account_id_list)
    vault_dict = get_valid_vault_info(valid_account_id_list)

    pa_info = get_vaild_pa_info(valid_account_id_list)

    result = []
    for entity_info in entity_info_list:
        entity_id = entity_info["entity_id"]
        entity_type = entity_info["entity_type"]
        role = entity_info["role"]

        kyc_and_sp_wsc = {
            "kyc_status": False,
            "sp_wsc": False
        }

        if entity_type == EntityTypeIndividual:
            if entity_id in individual_status_dict:
                kyc_and_sp_wsc = individual_status_dict[entity_id]

        elif entity_type == EntityTypeCompany:
            if entity_id in company_status_dict:
                kyc_and_sp_wsc = company_status_dict[entity_id]

        elif entity_type == EntityTypeTrust:
            if entity_id in trust_status_dict:
                kyc_and_sp_wsc = trust_status_dict[entity_id]

        else:  # group
            if entity_id in group_status_dict:
                kyc_and_sp_wsc = group_status_dict[entity_id]

        if entity_id not in entity_account_dict:
            continue

        account_id_list = entity_account_dict[entity_id]
        for act_id in account_id_list:

            # 剔除无效账户信息，不可删除
            if act_id not in valid_account_info_dict:
                continue

            pa_status = act_id in pa_info

            if act_id in vault_dict:
                for val_id in vault_dict[act_id]:
                    rst = {
                        "entity_id": entity_id,
                        "account_id": act_id,
                        "account_name": valid_account_info_dict[act_id]["account_name"],
                        "vault_id": val_id,
                        "id": valid_account_info_dict[act_id]["id"],
                        "kyc_status": kyc_and_sp_wsc["kyc_status"],
                        "sp_wsc": kyc_and_sp_wsc["sp_wsc"],
                        "role": role,
                        "pa_status": pa_status
                    }
                    result.append(rst)
            else:
                rst = {
                    "entity_id": entity_id,
                    "account_id": act_id,
                    "account_name": valid_account_info_dict[act_id]["account_name"],
                    "vault_id": "",
                    "id": valid_account_info_dict[act_id]["id"],
                    "kyc_status": kyc_and_sp_wsc["kyc_status"],
                    "sp_wsc": kyc_and_sp_wsc["sp_wsc"],
                    "role": role,
                    "pa_status": pa_status
                }
                result.append(rst)
    sort_result = sorted(result, key=lambda x: x["id"])
    result = []
    for rst in sort_result:
        del rst["id"]
        result.append(rst)
    rel_result = []
    if len(result) > 1:  # 用户拥有超过1个账号的时候， 只能获取有签署pa记录的账户
        account_id_list = [a['account_id'] for a in result]
        account_pa_list = PrimeAgreementHistory.select().where(PrimeAgreementHistory.account_id.in_(account_id_list))
        pa_accout_list = [a.account_id for a in account_pa_list]  # 签署过pa的账户
        for account_tmp in result:
            if account_tmp['account_id'] in pa_accout_list:  # 只返回有pa签署历史的账户
                rel_result.append(account_tmp)
    else:  # 如果只拥有一个账户 就直接返回
        rel_result = result
    return rel_result


def get_price_from_redis_by_gck_ticker(base_asset_id, quote_asset_id, bid_or_ask):

    res = Symbols.select(Symbols.ticker).where((Symbols.base_asset_id == base_asset_id) &
                                               (Symbols.quote_asset_id == quote_asset_id) &
                                               (Symbols.source == 'gck')).first()
    if not res:
        logger.error(f"GetQuote: Can not get gck ticker by symbols :{base_asset_id}/{quote_asset_id}")
        return None

    ticker = res.ticker
    depth_data = redis_cli.json_get(f"gck_quote_{ticker}_depth")
    if not depth_data:
        logger.error(f"GetQuote: gck redis is null: symbol-{base_asset_id}/{quote_asset_id}, gck ticker-{ticker}")
        return None
    if 'timestamp' in depth_data and int(time.time() - int(depth_data['timestamp']) / 1000) > 60 * 10:
        logger.error(f"GetQuote: gck timeout: symbol-{base_asset_id}/{quote_asset_id}, gck ticker-{ticker}")
        return None

    price = redis_cli.json_get(f"gck_quote_{ticker}_{bid_or_ask}")
    if not price:
        logger.error(f"GetQuote: Can not get gck ticker price :{base_asset_id}/{quote_asset_id}, gck ticker-{ticker}")
        return None

    return Calc(price).value


def get_price_from_coingecko(gck_ids):
    coingecko_api = "https://api.coingecko.com/api/v3"
    url = f"{coingecko_api}/simple/price?ids={gck_ids}&vs_currencies=usd"
    try:
        response = requests.get(url, timeout=3)
    except Exception as e:
        logger.error(f"get_price_from_coingecko: Can not get gck rest api price, error: {e}")
        return None
    if response.status_code == 200:
        data = response.json()
        if data.get(gck_ids, None):
            price = data[gck_ids]["usd"]
            return price
    return None


def get_asset_gck_ids(asset):
    sql = f"""
    select r.gck_id from (
    select id as gck_id from gckdata where upper(id)='{asset}'
    union
    select coingecko_id as gck_id from fb_supported_assets where id='{asset}' and coingecko_id is not null
    union
    select lower(SPLIT_PART(ticker, '/', 1)) as gck_id FROM symbols where base_asset_id='{asset}' and source='gck' and status='active'
    union
    select max(id) as gck_id from gckdata where upper(symbol)='{asset}' group by symbol having count(1)=1) r limit 1;
    """
    res = conn.execute(sql).fetchall()
    if not res:
        logger.error(f"GetQuote: Can not get {asset} gck ids!")
        return None
    return res[0][0]


def get_gck_id_by_asset(asset):
    res = Assets.select(Assets.coingecko_id).where(Assets.id == asset).first()
    if res:
        return res.coingecko_id
    return None


def get_symbol_price_by_rest(base_asset_id, quote_asset_id):
    # 从asset表获取base_asset_id对应的gck_id
    base_gck_ids = get_gck_id_by_asset(base_asset_id)
    if not base_gck_ids:
        base_gck_ids = get_asset_gck_ids(base_asset_id)
        if not base_gck_ids:
            logger.error(f"GetQuote: Can not get gck api, base_asset_id: {base_asset_id}")
            return None
    base_asset_price = get_price_from_coingecko(base_gck_ids)
    if not base_asset_price:
        logger.error(f"GetQuote: Can not get {base_asset_price} price by gck api, gck ids: {base_gck_ids}")
        return None
    if quote_asset_id == "USD":
        return Calc(base_asset_price).value

    # 从asset表获取base_asset_id对应的gck_id
    quote_gck_ids = get_gck_id_by_asset(quote_asset_id)
    if not quote_gck_ids:
        quote_gck_ids = get_asset_gck_ids(quote_asset_id)
        if not quote_gck_ids:
            logger.error(f"GetQuote: Can not get gck api, quote_asset_id: {quote_asset_id}")
            return None
    quote_asset_price = get_price_from_coingecko(quote_gck_ids)
    if not quote_asset_price:
        logger.error(f"GetQuote: Can not get {quote_asset_price} price by gck api, gck ids: {quote_gck_ids}")
        return None

    symbol_price = Calc(Calc(base_asset_price)/Calc(quote_asset_price))
    return symbol_price.value


def get_price_by_symbol(market, symbol, side):
    depth = redis_cli.json_get(f"{market}_quote_{symbol}_depth")
    if not depth:
        return None
    if 'timestamp' in depth and int(time.time() - int(depth['timestamp']) / 1000) > 10 * 60:
        return None

    raw_price_result = redis_cli.json_get(f"{market}_quote_{symbol}_{side}")
    if not raw_price_result:
        return None
    return raw_price_result


def get_history_price_by_asset(asset):
    now_time = datetime.now()
    now_time_str = now_time.strftime("%Y-%m-%d")
    ticker_list = [{"base_asset": asset, "quote_asset": "USD"}]

    historical_price_data = {
        "ticker_list": ticker_list,
        "time_range": [{"start_time": now_time_str, "end_time": now_time_str}],
        "source_list": CHANNEL_DEFAULT_ORDER,
        "is_all_source_price": False
    }
    logger.info(f"get_history_price_by_asset: {historical_price_data}")
    zmd_host = os.environ.get('ZEROCAP_MONITOR_GRPC_ZMD')
    with grpc.insecure_channel(zmd_host) as channel:
        stub = zerocap_market_data_pb2_grpc.ZerocapMarketDataStub(channel)
        res = stub.GetTickerDailyHistoryPrice(
            zerocap_market_data_pb2.GetTickerDailyHistoryPriceRequestV1(**historical_price_data))

        if res.status != "success":
            logger.error(res)
            logger.error("get_history_price_by_asset GetTickerDailyHistoryPrice failed!")
            raise Exception("get_history_price_by_asset GetTickerDailyHistoryPrice failed!")

    res_result = res.result
    historical_prices_result = "0"
    for i in res_result:
        for j in i.price:
            historical_prices_result = j.price
    return historical_prices_result


def handle_timestamp(timestamp):
    time_stamp = int(timestamp) / 1000
    # 转换为其他日期格式,如:"%Y-%m-%d %H:%M:%S"
    time_array = time.localtime(time_stamp)
    alp_format_time = time.strftime("%b %d, %Y", time_array)

    return alp_format_time


def get_transaction_flow_by_account_id(account_id):
    today = datetime.now()
    thirty_days_ago = today - timedelta(days=30)
    timestamp = int(time.mktime(thirty_days_ago.timetuple())) * 1000

    # 获取该 account id 三十天前的交易数据, 根据 created_at 降序排序
    response = Transactions.select(
        Transactions.side, Transactions.base_asset, Transactions.quote_asset,
        Transactions.quote_price, Transactions.quantity, Transactions.quote_dollar_value,
        Transactions.fee, Transactions.fee_notional, Transactions.markup, Transactions.markup_type,
        Transactions.created_at
    ).where(Transactions.account_id == account_id, Transactions.status != 'deleted',
            Transactions.created_at >= timestamp).order_by(Transactions.created_at.desc())

    thirty_day_volume = Calc(0)
    transaction_flow = []
    for index, res in enumerate(response):
        quote_dollar_value = res.quote_dollar_value if res.quote_dollar_value else 0
        if index <= 4:
            thirty_day_volume = Calc(thirty_day_volume) + Calc(quote_dollar_value)
            flow = {
                "side": "B" if res.side == "buy" else "S",
                "base_asset": res.base_asset,
                "quote_asset": res.quote_asset,
                "price": res.quote_price,
                "base_quantity": res.quantity,
                "quote_quantity": res.quote_dollar_value,
                "fee": res.fee,
                "fee_notional": res.fee_notional,
                "markup": res.markup,
                "markup_type": res.markup_type,
                "date": handle_timestamp(res.created_at)
            }
            transaction_flow.append(flow)
        else:
            thirty_day_volume = Calc(thirty_day_volume) + Calc(quote_dollar_value)

    return str(Calc(thirty_day_volume)), transaction_flow


def handle_aest_time(created_at):
    time_stamp = int(created_at) / 1000
    tz = pytz.timezone('Australia/Sydney')  # 时区
    utc_date = datetime.utcfromtimestamp(time_stamp)
    utc_loc_time = pytz.utc.localize(utc_date)  # 转为 UTC 时间

    aest = utc_loc_time.astimezone(tz)  # AEST 时区的时间
    aest_date = aest.strftime("%b %d, %Y")
    am_or_pm = aest.strftime("%I%p")  # 上午还是下午
    aest_str = f"{aest_date} {am_or_pm.lower()} AEST"
    return aest_str


def get_crm_notes_by_account_id(account_id):
    response = CrmNotes.select(CrmNotes.content, CrmNotes.trade_identifier, CrmNotes.created_at).\
               where(CrmNotes.status == 'active', CrmNotes.account_id == account_id).\
               order_by(CrmNotes.created_at.desc())

    crm_note_data = []
    for res in response:
        trade_identifier = Trader_Email_Abridge.get(res.trade_identifier)
        item = {
            "content": res.content,
            # 能获取到缩写就使用缩写，获取不到直接使用邮箱
            "trade_identifier": trade_identifier or res.trade_identifier,
            "created_at": handle_aest_time(res.created_at)
        }
        crm_note_data.append(item)
    return crm_note_data


def create_crm_note(account_id, emial, content, timestamp=None):
    if not timestamp:
        timestamp = int(time.time() * 1000)

    data = {
        "account_id": account_id,
        "trade_identifier": emial,
        "content": content,
        "status": "active",
        "note_id": uuid.uuid4(),
        "created_at": timestamp,
        "last_updated": timestamp
    }
    CrmNotes.create(**data)


def get_open_quotes():
    # if not id_list:
    #     return None
    all_quotes = Quotes.select().where(
        Quotes.status == 'open'
    )
    result = []
    if all_quotes:
        for i in all_quotes:
            res = [i.base_asset, i.quote_asset, i.quote_type, i.dealers]
            if res in result:
                continue
            result.append(res)
        return result
    return None


def get_open_orders():
    all_orders = Orders.select().where(Orders.status == OrderStatusEnum.get_const_obj("open"))
    result = []
    if all_orders:
        for i in all_orders:
            res = [i.base_asset, i.quote_asset, "", i.dealers]
            if res in result:
                continue
            result.append(res)
        return result
    return None


def aggregation_ems_symbol_data(all_symbols):
    ems_symbols_data = {}
    all_ticker_list = []
    for item in all_symbols:
        ticker = item.ticker

        if ticker not in all_ticker_list:
            all_ticker_list.append(item.ticker)
            ems_symbols_data[ticker] = {
                "base_asset_id": item.base_asset_id,
                "quote_asset_id": item.quote_asset_id,
                "ticker": ticker,
                "source": [item.source]
            }
        else:
            ems_symbols_data[ticker]["source"].append(item.source)
    return ems_symbols_data



def get_active_ems_symbol(ticker_list, page):
    flt = [EMSSymbols.ticker.in_(ticker_list) & (EMSSymbols.status == 'active')]

    all_symbols = EMSSymbols.select(EMSSymbols.base_asset_id, EMSSymbols.quote_asset_id,
                                    EMSSymbols.ticker, EMSSymbols.source).where(reduce(operator.and_, flt))
    ems_symbols_data = aggregation_ems_symbol_data(all_symbols)
    result = list(ems_symbols_data.values())
    if page:
        page_result = []
        for i in range(0, len(result), 10):
            page_result.append(result[i : i+10])
        return page_result[int(page) - 1]
    return result


def get_ems_symbol_by_b_q(b_q_id_list, page):
    ticker_lst = [f"{item[0]}/{item[1]}" for item in b_q_id_list]
    result = get_active_ems_symbol(ticker_lst, page)
    return result


def get_active_symbol(base_asset, quote_asset, source='gck'):
    flt = [(Symbols.base_asset_id == base_asset) & (Symbols.status == 'active') & (Symbols.quote_asset_id == quote_asset) &
           (Symbols.source == source)]
    all_symbols = Symbols.select(Symbols.base_asset_id, Symbols.quote_asset_id, Symbols.ticker, Symbols.source)\
        .where(reduce(operator.and_, flt))
    symbols_data = aggregation_ems_symbol_data(all_symbols)
    result = list(symbols_data.values())
    return result

def check_market_config_parameters(request):
    # 将 grpc 的 message 转为字典
    # including_default_value_fields 将未传的参数也会转化
    # preserving_proto_field_name 保留原本的参数名，不会进行大小写转换
    parameters = MessageToDict(request, including_default_value_fields=True, preserving_proto_field_name=True)
    check_empty = ["account_name", "category", "status"]

    for key, val in parameters.items():
        # exchange_category 不是必传, 不需要校验是否为空
        if key in check_empty and not val:
            text = f"{key} can not empty!"
            raise ZCException(text)

        if key == "category" and val not in MARKETS_CATEGORY:
            text = f"category {val} is invalid!"
            raise ZCException(text)

        if key == "status" and val not in ["active", "inactive"]:
            text = f"status {val} is invalid!"
            raise ZCException(text)


def update_or_add_market_config(request):
    account_name = request.account_name  # 大写的市场名称
    # 小写的市场名称, 将 account_name 全部转为小写并去掉空格
    market_name = account_name.lower().replace(" ", "")
    category = request.category
    status = request.status
    timestamp = int(time.time() * 1000)

    # 根据市场名称、分类查询数据是否存在
    response = MarketsConfig.select(MarketsConfig.category).where(
        MarketsConfig.market_name == market_name, MarketsConfig.category == category).first()

    # 如果可以查到数据, 更新 status
    if response:
        MarketsConfig.update({"status": status}).where(
            MarketsConfig.market_name == market_name, MarketsConfig.category == category).execute()

    # 如果没有查到数据, 则新增一条数据
    else:
        # 不能插入 inactive 的数据
        if status == "inactive":
            raise ZCException("Unable to insert inactive data!")

        MarketsConfig.insert(
            market_name=market_name,
            account_name=account_name,
            category=category,
            status=status,
            created_at=timestamp,
            updated_at=timestamp
        ).execute()


def get_lp_list(category):
    if category == "all":
        sql = """select distinct market_name, account_name from markets_config 
        where category != 'SUPPLEMENT' and status='active';"""
    else:
        sql = f"""SELECT market_name, account_name FROM markets_config
        WHERE category='{category}' and status='active';"""

    response = conn.execute(sql).fetchall()
    if not response:
        raise ZCException("no data!")

    result = {res[0]: res[1] for res in response}
    return result


if __name__ == '__main__':
    # quote = {
    #     "base_asset": "ADA",
    #     "quote_asset": "BTC",
    #     "trader_identifier": "qinghua.zhao@eigen.capital",
    #     "market": "b2c2",
    #     "quantity": "30",
    #     "symbol":"ADA/BTC",
    #     "side":"buy",
    #     "quote_quantity":"10"
    # }
    # start = time.time()
    # check_trader_price_and_limit(quote)
    # print(time.time() - start)

    # quote = "all"
    #
    # start = time.time()
    # all_base, all_quote, ticker_list = get_all_active_ems_symbols(quote)
    # print(len(ticker_list))
    # # print(time.time() - start)
    # # account_id = 'ee9d3d62-a295-4fcf-b6ba-ae0c04966b71'   # 多个
    # # account_id = '73e90ddd-8b9b-4068-b9ab-4e3531fbcf15'   # 个人
    # # operate = "risk"
    # # users = query_user_id_by_ems(account_id, operate)
    # # print(users)
    #
    # # result = get_all_account_info()
    #
    # # start = time.time()
    # # res = get_symbol_price_by_rest("$ACM_$CHZ", "BTC")
    # # print(res)
    # # print(time.time() - start)
    # # import otc_pb2
    # # request = otc_pb2.GetUserAccountsInfoByEMSRequestV1(email='joys.karen@foxmail.com')
    # # get_account_info_by_ems(request)
    # # print(get_history_price_by_asset('CHF'))
    # print(redis_cli.jsonmget('timestamp', ["kucoin_quote_BSW/USDT_ask", "galaxy_quote_MATIC/USD_bid"]))

    # print(get_transaction_flow_by_account_id("bced65fe-4f23-4386-bc11-1a431046114e"))
    print(handle_aest_time(1686903507000))

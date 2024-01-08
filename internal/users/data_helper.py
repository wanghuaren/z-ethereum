"""
user query
eg user/group/vault/workspace
"""
import datetime
import os
import time
import random
import copy
import grpc
from functools import reduce

from peewee import JOIN, operator
from playhouse.shortcuts import model_to_dict

import sys
import pathlib
sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))

from db.models import Users, RiskLimits, db, Transactions, Quotes, LPConfig, Individuals, Fills, Treasury
from utils.consts import Role
from utils.logger import logger
from config.config import CHANNEL_DEFAULT_ORDER

import zerocap_market_data_pb2
import zerocap_market_data_pb2_grpc


def get_user_info_by_user(user_id):
    """
    :param user_id:
    :return: user
    """

    user = Users.get_or_none(Users.user_id == user_id)
    if user:
        return user
    return None


def update_risk_limits(args):
    """
    :param  args:  user_id:
                   role:
                   alert_interval:
                   stop_loss_limit:
                   note:
                   manager_email:
                   created_at:
                   status:
    :return: True
    """
    update_at = int(time.mktime(time.localtime(time.time())))
    try:
        with db.atomic():
            response = RiskLimits.insert(trader_identifier=args["trader_identifier"],
                                          role=args["role"],
                                          alert_interval=args["alert_interval"],
                                          stop_loss_limit=args["stop_loss_limit"],
                                          note=args["note"],
                                          manager_email=args["manager_email"],
                                          created_at=args["created_at"],
                                          update_at=update_at,
                                          status=args["status"]).on_conflict(
                conflict_target=[RiskLimits.trader_identifier, RiskLimits.status],
                update=dict(alert_interval=args["alert_interval"],
                            stop_loss_limit=args["stop_loss_limit"],
                            note=args["note"],
                            update_at=update_at),
                where=(RiskLimits.trader_identifier == args["trader_identifier"]))
            response.execute()
    except Exception as e:
        raise e
    return True


def get_trader_list():
    """
    :return: result
    """
    response = Users.select(Users, RiskLimits, Individuals).where(
        ((Users.role == 3) | (Users.role == 4)))\
        . join(Individuals, JOIN.LEFT_OUTER, on=(reduce(operator.and_, ((Users.entity_id == Individuals.entity_id),))))\
        .join(RiskLimits, JOIN.LEFT_OUTER, on=(reduce(operator.and_, ((Users.email == RiskLimits.trader_identifier),
                                                                       RiskLimits.status == "normal"))))



    result = []
    for i in response:
        alert_interval = ''
        stop_loss_limit = ''
        if not hasattr(i, 'individuals'):
            continue
        if hasattr(i.individuals, 'risk_limits'):
            stop_loss_limit = i.individuals.RiskLimits.stop_loss_limit
            alert_interval = i.individuals.RiskLimits.alert_interval
        individual = i.individuals
        individual_dict = model_to_dict(individual)
        res = model_to_dict(i)
        res.update(individual_dict)
        # 需要返回的参数
        keys = ['email', 'first_name', 'last_name', 'address', 'tenant', 'user_id']
        res = {i: res[i] for i in res if i in keys}

        # 需要新加的参数
        res['stop_loss_limit'] = stop_loss_limit
        res['alert_interval'] = alert_interval
        res['role'] = Role[i.role]
        res['created_at'] = str(i.created_at)
        res['updated_at'] = str(i.updated_at)
        res['firstname'] = res.pop('first_name')
        res['lastname'] = res.pop('last_name')

        result.append(res)
    return result


def get_risk_limits_by_user(user_id):
    """
    :param user_id:
    :return: risk_limit
    """

    risk_limit = RiskLimits.get_or_none(RiskLimits.trader_identifier == user_id)
    if risk_limit:
        return risk_limit
    return None


def get_fills_by_alias(fill_alias):
    response = Fills.select().where(Fills.fill_alias == fill_alias).first()
    return response


def get_treasury_by_alias(treasury_alias):
    response = Treasury.select().where(Treasury.treasury_alias == treasury_alias).first()
    return response


def get_quotes(quote_alias):
    response = Quotes.select().where(Quotes.quote_alias == quote_alias).first()
    return response


def get_lp_config():
    flt = [LPConfig.status == "active"]
    res = LPConfig.select().where(reduce(operator.and_, flt))
    response = {}
    for i in res:
        response[i.liquidity_provider_name] = i.minimum_settlement_amount
    return response


def get_historical_prices(base_asset):
    """
    获取历史价格函数
    :param base_asset:
    :return:
    """
    # 获取哪些市场支持
    now_time = datetime.datetime.now()
    now_time_str = now_time.strftime("%Y-%m-%d")
    historical_price_data = {
        "ticker_list": [{"base_asset": base_asset, "quote_asset": "USD"}],
        "time_range": [{"start_time": now_time_str, "end_time": now_time_str}],
        "source_list": CHANNEL_DEFAULT_ORDER,
        "is_all_source_price": False
    }

    zmd_host = os.environ.get('ZEROCAP_MONITOR_GRPC_ZMD')
    with grpc.insecure_channel(zmd_host) as channel:
        stub = zerocap_market_data_pb2_grpc.ZerocapMarketDataStub(channel)
        res = stub.GetTickerDailyHistoryPrice(zerocap_market_data_pb2.GetTickerDailyHistoryPriceRequestV1(**historical_price_data))

        if res.status != "success":
            logger.error(res)
            logger.error("GetTickerDailyHistoryPrice failed!")
            raise Exception("GetTickerDailyHistoryPrice failed!")

    result = res.result
    if result and result[0].price:
        return {"price": result[0].price[0].price}
    else:
        return None


def get_timestamp(timeStamp):
    # 获取当前时间戳当天开始时间戳和结束时间戳
    timeStamp = timeStamp
    timeArray = time.localtime(timeStamp)
    otherStyleTime = time.strftime("%Y-%m-%d", timeArray)
    timeArray = time.strptime(otherStyleTime, "%Y-%m-%d")
    timeStamp = int(time.mktime(timeArray))
    return (timeStamp*1000,(timeStamp+86400)*1000)


def check_repeat_exists(res):
    user_id = res.user_id
    txn_alias = res.txn_alias
    created_at = res.created_at
    day_start, day_end = datetime.datetime.combine(res.add_date, datetime.time.min), datetime.datetime.combine(res.add_date, datetime.time.max)
    response = Transactions.select().where((Transactions.user_id==user_id) & (Transactions.created_at==created_at) &
        (Transactions.add_date>=day_start) & (Transactions.add_date<=day_end) & (Transactions.txn_alias!=txn_alias))
    # 如果存在一天内同一用户，同一created_at的数据
    if response:
        return True
    return False


def update_transaction_created_at(res):
    # 将当前数据的 created_at 随机加上 1-60 秒
    origin = res.created_at/1000
    random_num = random.randint(1,60)
    new_created_at = (origin + random_num)*1000
    res.created_at = new_created_at
    # 再次检查表中是否存在同一用户同一时间戳的数据
    if not check_repeat_exists(res):
        # 不存在则更新表记录
        Transactions.update({"created_at": new_created_at}).where(Transactions.txn_alias == res.txn_alias).execute()
        new_res = copy.deepcopy(res)
        new_res.created_at = new_created_at
        return new_res
    # 存在重复记录则继续次过程
    new_res = update_transaction_created_at(res)
    return new_res


def get_email_by_user_id(user_id):
    try:
        user = Users.select(Users.email).where(Users.user_id == user_id, Users.status == 'active').first()
        if user:
            return user.email
        return None
    except Exception as e:
        logger.error(f"user not exist user_id:{user_id}", exc_info=True)
        raise Exception(f"user not exist user_id:{user_id}")



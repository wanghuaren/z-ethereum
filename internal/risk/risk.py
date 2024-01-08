"""
risk相关的业务逻辑
"""
import json
from datetime import datetime, timezone
import sys
import pathlib
import time
sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))

from config.config import config
from internal.users.data_helper import get_user_info_by_user
from internal.risk.data_helper import get_risk_pos, get_oldest_txn_time, get_usdtaud_1m, get_dma_config, \
    check_update_price_admin_parameter, update_dam_config_by_symbol, insert_dam_ladder_config, \
    get_dma_ladder_config_by_symbol, update_dma_ladder_config_to_inactive
from utils.calc import Calc
from utils.logger import logger
from utils.redis_cli import RedisClient
from utils.zc_exception import ZCException
from utils.consts import ResponseStatusSuccessful, Channel
from utils.date_time_utils import timestamp_to_date_time, iso8601


def get_risk(request):
    role = -1
    user_info = None
    # 获取用的用户的role权限
    if request.user_id:
        user_info = get_user_info_by_user(request.user_id)
    if user_info:
        role = user_info.role
    # user_info的权限role等于4，risk展示所有数据;等于3只展示zerocap与用户本身的数据
    if role == 3:
        request.trader_identifier = request.user_id
    if role != 3 and role != 4:
        raise ZCException("The role permission of the user is abnormal")

    if not request.limit:
        request.limit = 20

    if not request.page:
        request.page = 1

    if not request.start_timestamp:
        # 如果未传start_timestamp默认取最早的交易记录对应的时间
        request.start_timestamp = get_oldest_txn_time()

    if not request.end_timestamp:
        request.end_timestamp = int(datetime.now(timezone.utc).timestamp() * 1000)

    trader_df, sum_df, pnl_df = get_risk_pos(request.start_timestamp, request.end_timestamp)
    if sum_df is None:
        return dict(status=ResponseStatusSuccessful, total=0,
                    trader_risks=[])
    trading_volume_usd_total_all = Calc.get_num_by_prec(str(sum_df["trading_volume_usd"].sum()), 2)
    exposure_value_usd_total_all = Calc.get_num_by_prec(str(sum_df["exposure_quantity_usd"].sum()), 2)
    last_updated_all = datetime.fromtimestamp(sum_df["created_at"].max() / 1000).strftime(
        "%Y-%m-%d %H:%M:%S")

    if request.asset_id:
        trader_df = trader_df[trader_df.asset_id == request.asset_id]
        sum_df = sum_df[(sum_df.index == request.asset_id)]

    if request.trader_identifier:
        trader_df = trader_df[trader_df.trader_identifier == request.trader_identifier]

    if trader_df.empty:
        return dict(status=ResponseStatusSuccessful, total=0,
                    trader_risks=[])

    asset_risks_total = [{"asset_id": sum_index,
                          "exposure_quantity": Calc.get_num_by_prec(str(row["exposure_quantity"]), 4),
                          "exposure_value_usd": Calc.get_num_by_prec(str(row["exposure_quantity_usd"]), 2),
                          "trading_volume": Calc.get_num_by_prec(str(row["trading_volume"]), 4),
                          "trading_volume_usd": Calc.get_num_by_prec(str(row["trading_volume_usd"]), 2),
                          "last_updated": datetime.fromtimestamp(row["created_at"] / 1000).strftime(
                              "%Y-%m-%d %H:%M:%S")} for
                         sum_index, row in sum_df.iterrows()]

    total_risks = [{"trader_identifier": "zerocap",
                    "trader_email": "zerocap",
                    "exposure_value_usd_total": exposure_value_usd_total_all,
                    "trading_volume_usd_total": trading_volume_usd_total_all,
                    "pnl_usd_total": Calc.get_num_by_prec(str(pnl_df["total"]), 2),
                    "last_updated": last_updated_all,
                    "asset_risks": asset_risks_total}]
    trader_risks = []

    for trader_identifier in trader_df["trader_identifier"]:
        if trader_identifier in [risk["trader_identifier"] for risk in trader_risks]:
            continue

        single_trader_df = trader_df[trader_df.trader_identifier == trader_identifier]
        asset_risks = [{"asset_id": asset_row["asset_id"],
                        "exposure_quantity": Calc.get_num_by_prec(str(asset_row["exposure_quantity"]), 4),
                        "exposure_value_usd": Calc.get_num_by_prec(str(asset_row["exposure_quantity_usd"]), 2),
                        "trading_volume": Calc.get_num_by_prec(str(asset_row["trading_volume"]), 4),
                        "trading_volume_usd": Calc.get_num_by_prec(str(asset_row["trading_volume_usd"]), 2),
                        "last_updated": datetime.fromtimestamp(asset_row["created_at"] / 1000).strftime(
                            "%Y-%m-%d %H:%M:%S")} for _, asset_row in
                       single_trader_df.iterrows()]

        trader_risks.append({"trader_identifier": trader_identifier,
                             "trader_name": single_trader_df.iloc[0]["name"],
                             "trader_email": single_trader_df.iloc[0]["email"],
                             "exposure_value_usd_total": Calc.get_num_by_prec(str(single_trader_df["exposure_quantity_usd"].sum()), 2),
                             "trading_volume_usd_total": Calc.get_num_by_prec(str(single_trader_df["trading_volume_usd"].sum()), 2),
                             "pnl_usd_total": Calc.get_num_by_prec(str(pnl_df[trader_identifier]), 2),
                             "last_updated": datetime.fromtimestamp(
                                 single_trader_df["created_at"].max() / 1000).strftime("%Y-%m-%d %H:%M:%S"),
                             "asset_risks": asset_risks})

    trader_risks_page = trader_risks[(int(request.page) - 1) * int(request.limit): (int(
                    request.page) * int(request.limit))]
    trader_risks_total = total_risks + trader_risks_page if request.page == 1 else trader_risks_page
    total = len(trader_risks) + 1
    return dict(status=ResponseStatusSuccessful, total=total, trader_risks=trader_risks_total)


def get_k_line(request):
    redis_cli = RedisClient(db=11, host=config['CONFIG_DMA_REDIS']['HOST'], port=config['CONFIG_DMA_REDIS']['PORT'])
    if request.date_type not in ('1m', '3m', '5m', '15m', '30m', '1h', '2h', '4h', '6h', '8h', '12h', '1d'):
        raise Exception("invaild date type！")

    if request.date_type == '1m':
        try:
            if int(request.date_range) <= 0:
                raise Exception("invaild date range！")
        except ValueError:
            raise Exception("invaild date range！")

        now_timestamp = int(time.time() * 1000)
        date_range = int(request.date_range)
        end_timestamp = now_timestamp - now_timestamp % 60 * 1000 - 60 * 24 * 60 * 1000 * int(date_range - 1)
        start_timestamp = end_timestamp - 60 * 24 * 60 * 1000 * int(date_range)
        start_date = timestamp_to_date_time(start_timestamp)
        end_date = timestamp_to_date_time(end_timestamp)

        result = get_usdtaud_1m(start_date, end_date, start_timestamp, end_timestamp)
    else:
        try:
            if int(request.date_range) <= 0:
                raise Exception("invaild date range！")
            elif int(request.date_range) > 1:
                return dict(status=ResponseStatusSuccessful, k_line_data=[])
        except ValueError:
            raise Exception("invaild date range！")

        result = []
        symbol = "USDT/AUD"
        key = f"{symbol}_kline_{request.date_type}_list"
        symbol_kline_result = redis_cli.lrange(key)
        symbol_kline_result.sort(key=lambda x: x['created_at'])
        for each_symbol_kline_data in symbol_kline_result:
            result.append({
                "open_price": each_symbol_kline_data['open_price'],
                "close_price": each_symbol_kline_data['close_price'],
                "high_price": each_symbol_kline_data['high_price'],
                "low_price": each_symbol_kline_data['low_price'],
                "vol": each_symbol_kline_data['vol'],
                "created_date": each_symbol_kline_data['created_date']
            })

    return dict(status=ResponseStatusSuccessful, k_line_data=result)


def get_price_admin(request):
    if not request.trader_identifier:
        raise Exception("get_price_admin: trader_identifier can not be empty!")

    # 校验参数limit为正整数
    if request.limit and not str(request.limit).isdigit():
        logger.error(f"get_price_admin invalid argument, limit must be a positive integer")
        text = f"limit must be a positive integer"
        raise ZCException(text)

    # 校验参数limit为正整数
    if request.page and not str(request.page).isdigit():
        logger.error(f"get_price_admin invalid argument, page must be a positive integer")
        text = f"page must be a positive integer"
        raise ZCException(text)

    symbol = None
    if request.symbol:
        # 校验输入参数
        if not request.symbol.replace('/', '').isalpha():
            logger.error(f"get_price_admin invalid symbol")
            text = f"Invalid symbol, please enter the correct symbol or part. For example, USDT/AUD"
            raise ZCException(text)
        else:
            symbol = request.symbol
    data = get_dma_config(symbol)

    return dict(status=ResponseStatusSuccessful, symbols_admin=data)


def update_price_admin(request):
    # price admin页面的redis使用11号数据库
    redis_client = RedisClient(db=11)
    # 参数非空校验及数量校验
    logger.info(f"参数非空校验及数量校验等等")
    check_update_price_admin_parameter(request)

    update_data = {
        'px_sig': request.px_sig,
        'qty_sig': request.qty_sig,
        'max_order': request.max_order,
        'min_order': request.min_order,
        'buy_spread': request.buy_spread,
        'sell_spread': request.sell_spread,
        'price_stream': request.price_stream,
        'place_orders': request.place_orders
    }
    # 更新DmaConfig表数据
    update_dam_config_by_symbol(request.symbol, update_data)

    # 获取DmaLadderConfig表的数据
    db_data, db_data_id = get_dma_ladder_config_by_symbol(request.symbol)
    res_ladder_id = [i.id for i in request.dma_ladder]

    data = []
    ladder_data = []
    timestamp = int(time.time() * 1000)

    # 需要删除的
    for ladder_id in db_data_id:
        if ladder_id not in res_ladder_id:
            logger.info(f"dam_ladder_config表删除的数据id: {ladder_id}")
            update_dma_ladder_config_to_inactive(ladder_id, {'status': 'inactive'})

    for i in request.dma_ladder:
        ladder_data.append({'quantity': i.quantity, 'spread': i.spread})
        if i.id and (i.id, i.quantity, i.spread) not in db_data:
            # id为空,quantity和spread有变动,是需要更新的
            ladder_update_data = {'id': i.id, 'quantity': i.quantity, 'spread': i.spread}
            logger.info(f"dam_ladder_config表更新的数据data: {ladder_update_data}")
            update_dma_ladder_config_to_inactive(i.id, ladder_update_data)
        elif not i.id:
            # id为空,是需要新增的
            data.append({
                    'symbol': request.symbol,
                    'quantity': i.quantity,
                    'spread': i.spread,
                    'status': 'active',
                    "created_at": timestamp,
                    "last_updated": timestamp,
                    "add_date": iso8601(timestamp),
                })

    # 新增DmaLadderConfig表的数据
    logger.info(f"dam_ladder_config表插入的数据data: {data}")
    insert_dam_ladder_config(data)

    # utc时间字符串毫秒时间戳
    now = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.000000Z")
    time_stamp = int(datetime.strptime(now, '%Y-%m-%dT%H:%M:%S.%f%z').timestamp() * 1000)
    # utc时间字符串转格式化
    utc_date = int(datetime.strptime(now, "%Y-%m-%dT%H:%M:%S.%f%z").timestamp() * 1000)

    messages = {
        'symbol': request.symbol,
        'px_sig': request.px_sig,
        'qty_sig': request.qty_sig,
        'max_order': request.max_order,
        'min_order': request.min_order,
        'buy_spread': request.buy_spread,
        'sell_spread': request.sell_spread,
        'price_stream': request.price_stream,
        'place_orders': request.place_orders,
        'dma_ladder': ladder_data,
        'timestamp': time_stamp,
        'datetime': iso8601(utc_date)  # 2019-07-26 16:20:54  utc时间字符串
    }
    redis_client.json_set(f'PriceAdmin_{request.symbol}', messages)
    redis_client.publish_messages(Channel, json.dumps(messages))

    return dict(status=ResponseStatusSuccessful)


if __name__ == '__main__':
    import time
    from utils.dict_utils import ObjDict

    request = ObjDict({
        "date_type": "1m"
    })
    print(request, "///")
    start = time.time()
    print(get_k_line(request))
    print(time.time() - start)

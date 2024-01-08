"""
rfq相关的业务逻辑
"""
import copy
import json
import zlib
import time
import sys
import pathlib
from datetime import datetime
import uuid
import grpc
import os
import base64


sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))

from db.base_models import db
from db_api.symbols_api import query_symbols_by_base_quote_asset_id, get_asset_ticker_by_symbol_precision, \
    get_asset_precision_by_asset_ticker
from db_api.asset_api import query_asset_qty_prec_by_quote_asset_id
from internal.rfq.data_helper import query_quotes_data_by_alias, update_quotes_status_and_parent_alias, insert_quotes, \
    query_quotes_data_by_two_way_other_data, check_trader_price_and_limit, get_orders_data, get_customerinfo_account_id, \
    get_all_active_ems_symbols, query_user_id_by_ems, get_company_info, \
    get_trust_info, get_group_info, get_individual_info, get_account_info_by_ems, check_get_quote_parameter, \
    check_redis_talos_time_key, check_trader_size_limit_and_exposure_limit, cancel_same_quote, get_transaction_flow_by_account_id, \
    get_crm_notes_by_account_id, check_market_config_parameters, update_or_add_market_config, get_lp_list, create_crm_note, \
    get_ems_symbol_by_b_q, get_active_ems_symbol, get_active_symbol, get_open_orders, get_open_quotes

from internal.users.data_helper import get_quotes, get_lp_config, get_historical_prices, get_user_info_by_user
from utils.zc_exception import ZCException
from utils.logger import logger
from utils.slack_utils import send_slack
from utils.consts import QuoteTimeOut, ResponseStatusSuccessful, QUOTE_TIMEOUT
from utils.calc import Calc
from utils.redis_cli import RedisClient
from utils.get_market_price import get_symbol_price_by_ccxt_or_redis
from clients.talos_cilent import TalosClient

from internal.rfq.data_helper import check_parameter, check_single_and_exposure_limit, calculate_fee_total,\
    calculate_raw_price, get_txn_by_order_id, get_receipt_data, insert_orders, update_order, update_order_by_alias
from db.models import OrderTypeEnum, OrderStatusEnum, SideEnum, NotionalEnum, EntityEnum, FeeTypeEnum, FeeNotionalEnum, \
    OrderHedgeEnum, OrderMarkUpTypeEnum, EntityRelation, Users, Roles, Logins, TraderConfig
from config.config import config, TALOS_CONFIG, CHANNEL_DEFAULT_ORDER
import otc_pb2
import exec_pb2
import exec_pb2_grpc
# import market_data_pb2
# import market_data_pb2_grpc
import zerocap_market_data_pb2
import zerocap_market_data_pb2_grpc

all_markets = get_lp_list("all")

def edit_rfq_quote(request):
    with db.atomic():
        # 传入参数校验
        if not request.quote_alias or not request.quote_price or not request.trader_identifier:
            logger.error("EditRFQQuote invaild argument")
            raise ZCException("invaild argument")

        # 数字字符串且大于0;
        try:
            if float(request.quote_price) <= 0:
                logger.error("EditRFQQuote quote_price less than or equal to zero")
                raise ZCException("quote_price less than or equal to zero")
        except ValueError:
            logger.error("EditRFQQuote quote_price invaild type")
            raise ZCException("quote price invaild type")

        # 逻辑处理, 获取原有的数据;
        # 根据 quote_alias 查询对应的 2 way 标识
        quotes_data = query_quotes_data_by_alias(request.quote_alias)
        if not quotes_data:
            logger.error("EditRFQQuote quotes row not found")
            raise ZCException("quotes row not found")
        dealers = quotes_data.get("dealers")
        raw_price = quotes_data.get("raw_price")
        quote_type = quotes_data.get("quote_type")

        # 根据base_asset 和quote_asset, 获取到对应的交易对
        symbols_data = query_symbols_by_base_quote_asset_id(quotes_data['base_asset'], quotes_data['quote_asset'],
                                                            dealers)
        if not symbols_data:
            logger.error(
                f"EditRFQQuote symbols {quotes_data['base_asset']}, {quotes_data['quote_asset']} ticker not found")
            raise ZCException("symbols ticker not found")
        # two_way_other_way_quotes = two_way_other_way_get_quote()
        base_qty_prec, base_px_prec = symbols_data['qty_sig'], symbols_data['px_sig']

        # 当固定询价且raw_price为0时， 无需进行校验，无需进行询价
        # if raw_price != "0" or quote_type != "Fixed":

        # 询价前的校验
        quotes_data['market'] = quotes_data['dealers']
        quotes_data['symbol'] = symbols_data['ticker']
        check_trader_price_and_limit(quotes_data)

        quotes_dic = {'status': 'canceled'}

        if quotes_data['two_way_quote_alias']:
            side = 'two_way'
            quotes_dic['two_way_quote_alias'] = quotes_data['two_way_quote_alias']
        else:
            side = quotes_data['side']
            quotes_dic['quote_alias'] = quotes_data['quote_alias']
        update_quotes_status_and_parent_alias(quotes_dic)

        quote_qty_prec = query_asset_qty_prec_by_quote_asset_id(quotes_data['quote_asset'])
        if not quote_qty_prec:
            logger.error(f"EditRFQQuote asset {quotes_data['quote_asset']} ticker not found")
            raise ZCException("symbols ticker not found")

        # 如果市场在talos种,可以询价
        fetch_quote_res_data = {'buy': '0', 'sell': '0'}
        if quotes_data['dealers'] in TALOS_CONFIG["MARKETS_ACCOUNTS"]["zerocap"]:
            fetch_quote_res_data = get_raw_price(symbols_data, quotes_data, side, request.trader_identifier)
            logger.info(f"询价结果为 {fetch_quote_res_data};")

        # 新的2 way标识默认为空
        new_two_way_quote_alias = ''
        created_time = int(time.time() * 1000)

        # parent_quote_alios 继承获取quote_alias的数据中的 parent_quote_alios;
        new_quotes = {
            "user_id": quotes_data["user_id"],
            "trader_identifier": quotes_data["trader_identifier"],
            "base_asset": quotes_data["base_asset"],
            "quote_asset": quotes_data["quote_asset"],
            "quantity_asset": quotes_data["quantity_asset"],
            "markup": quotes_data["markup"],
            "markup_type": quotes_data["markup_type"],
            "fee": quotes_data["fee"],
            "fee_type": quotes_data["fee_type"],
            "fee_pct": quotes_data["fee_pct"],
            "status": "open",
            "created_at": created_time,
            "timeout": int(QuoteTimeOut),
            "entity": quotes_data["entity"],
            "dealers": quotes_data["dealers"],
            "hedge": quotes_data["hedge"],
            "fee_notional": quotes_data["fee_notional"],
            "txn_alias": "",
            "userpubkey": "",
            "quote_type": quotes_data["quote_type"],
            "account_id": quotes_data["account_id"],
            "vault_id": quotes_data["vault_id"],
            "settlement_destination": quotes_data["settlement_destination"]
        }

        # 如果是2 way
        if side == 'two_way':
            # 获取另一条数据的 alias
            two_way_other_data = query_quotes_data_by_two_way_other_data(request.quote_alias, quotes_data[
                'two_way_quote_alias'])

            if not two_way_other_data:
                logger.error(f"EditRFQQuote quotes two way other row not found! quote_alias: {request.quote_alias}, "
                             f"two_way_quote_alias: {quotes_data['two_way_quote_alias']}")
                raise ZCException("quotes two way other row not found!")

            two_way_other_way_side = two_way_other_data['side']

            # 未修改的数据，通过询价的raw_price, mark up 重新计算出一条 quotes数据
            two_way_other_way_raw_price = fetch_quote_res_data[two_way_other_data['side']]

            # 2 way新建 uuid
            new_two_way_quote_alias = str(uuid.uuid1())

            two_way_other_way_quotes = {}
            two_way_other_way_quotes.update(**new_quotes)
            two_way_other_way_quotes["side"] = two_way_other_way_side
            two_way_other_way_quotes["two_way_quote_alias"] = new_two_way_quote_alias
            two_way_other_way_quotes["raw_price"] = two_way_other_way_raw_price

            two_way_other_way_quotes['parent_quote_alias'] = two_way_other_data['quote_alias']

            # markup_type 默认分为 bps 和 usd， pips
            if two_way_other_way_quotes['markup_type'] == 'bps':
                if two_way_other_way_quotes['side'] == 'buy':
                    quote_price = Calc(Calc(two_way_other_way_raw_price) * (Calc(1) + Calc(two_way_other_way_quotes['markup'])/Calc(10000)))
                else:
                    quote_price = Calc(Calc(two_way_other_way_raw_price) * (Calc(1) - Calc(two_way_other_way_quotes['markup']) / Calc(10000)))
            elif two_way_other_way_quotes['markup_type'] == "pips":
                if two_way_other_way_quotes['side'] == 'buy':
                    quote_price = Calc(Calc(two_way_other_way_raw_price) + Calc(two_way_other_way_quotes['markup'])/Calc(10000))
                else:
                    quote_price = Calc(Calc(two_way_other_way_raw_price) - Calc(two_way_other_way_quotes['markup'])/Calc(10000))
            else:
                if two_way_other_way_quotes['side'] == 'buy':
                    quote_price = Calc(Calc(two_way_other_way_raw_price) + Calc(two_way_other_way_quotes['markup']))
                else:
                    quote_price = Calc(Calc(two_way_other_way_raw_price) - Calc(two_way_other_way_quotes['markup']))

            two_way_other_way_quotes = compute_data(two_way_other_way_quotes, base_qty_prec, base_px_prec, quote_qty_prec,
                                                    quote_price, quotes_data)

            two_way_other_way_quotes['quote_alias'] = str(uuid.uuid1())
            two_way_other_way_quotes['is_edit'] = 'false'

            # 创建数据
            insert_quotes(two_way_other_way_quotes)

        # 通过 quote_price 修改，算出一条quotes数据, mark_up不变;
        new_quotes['parent_quote_alias'] = quotes_data['quote_alias']
        new_quotes['side'] = quotes_data['side']
        new_quotes['two_way_quote_alias'] = new_two_way_quote_alias
        new_quotes['raw_price'] = fetch_quote_res_data[quotes_data['side']]
        new_quotes['quote_alias'] = str(uuid.uuid1())
        new_quotes['is_edit'] = 'true'

        # 如果是2 way，此条数据的 2 way标识需要继承
        new_quotes = compute_data(new_quotes, base_qty_prec, base_px_prec, quote_qty_prec, Calc(request.quote_price), quotes_data)
        # raw_price为0,markup为空
        new_quotes['markup'] = ""
        if fetch_quote_res_data[quotes_data['side']] != "0":
            new_quotes = compute_mark_up(new_quotes, fetch_quote_res_data[quotes_data['side']])
        if float(new_quotes['quote_price']) <= 0:
            logger.error(f"EditRFQQuote quote_price less than or equal to zero, origin {request.quote_price} modify {new_quotes['quote_price']}")
            raise ZCException(f"Quote Price must greater than {request.quote_price}")

        insert_quotes(new_quotes)
        # 构建返回参数
        return new_quotes


def get_quote(request):
    """
    询价接口
    1. 参数校验；
    2. 获取精度、小数位等配置；
    3. 获取市场价格；
    3. 使用市场价格，格式化询价参数；
    4. 使用格式化之后的参数，去 talos 询价；
    5. 校验额度(单笔、日限额)；
    6. 更新表等逻辑；
    """
    # 参数非空校验及数量校验
    logger.info(f"参数非空校验及数量校验等等")
    check_get_quote_parameter(request)

    if request.quote_type != 'Market':
        logger.error("GetQuote: Wrong quote type!")

    # 在ems_symbols与symbols中获取对应的价格精度与数量精度
    base_quantity = ""
    quote_quantity = ""
    base_qty_prec, base_px_prec, base_asset, quote_asset = get_asset_ticker_by_symbol_precision(request.symbol, request.dealers)

    # 在assets中获取quote_asset的数量精度
    quote_qty_prec, _ = get_asset_precision_by_asset_ticker(quote_asset)

    # 检查redis 价格更新时间
    logger.info(f"检查redis 价格更新时间是否超过1.5s")
    check_redis_talos_time_key()

    market = ""
    quotes = []
    raw_price = ""
    two_way_quote_alias = ""
    fixed_quote_error_message = ""
    dealers_string = ','.join(request.dealers)
    created_time = int(time.time() * 1000)
    fetch_quote_res_data = {
            'buy_price': {'market': '', 'price': 0},
            'sell_price': {'market': '', 'price': 0}
        }

    # 获取该交易对在多个市场的最优价格
    symbol = request.symbol
    user_id = request.user_id
    trader_identifier = request.trader_identifier
    quote_price = ""
    redis_no_found = True
    raw_price_benchmark = ""  # buy sell 中间价

    if request.side == "two_way":
        two_way_quote_alias = str(uuid.uuid1())

    res_data = get_symbol_price_by_ccxt_or_redis(symbol, request.dealers, request.side)

    logger.info(f"redis、ccxt价格的数据获取: res_data={res_data}")
    if res_data['buy_price']['price'] != 0:
        raw_price = res_data['buy_price']['price']
        redis_no_found = False
    if res_data['sell_price']['price'] != 0:
        raw_price = res_data['sell_price']['price']
        redis_no_found = False

    # 计算base_quantity、quote_quantity用于talos询价参数
    if raw_price:
        fetch_quote_res_data = res_data
        logger.info(f"talos询价之前的redis数据获取: fetch_quote_res_data={fetch_quote_res_data}")

        if request.notional == "base":
            base_quantity = request.quantity
            quote_quantity = Calc(Calc(base_quantity) * Calc(raw_price))
        elif request.notional == "quote":
            quote_quantity = request.quantity
            base_quantity = Calc(Calc(quote_quantity) / Calc(raw_price))
        else:
            logger.error("GetQuote: quantity asset type incorrect")
            raise ZCException("GetQuote: quantity asset type incorrect")
    elif request.quote_type == "Fixed":
        redis_no_found = True
    else:
        logger.error("get_quote: finally could not get price")
        raise ZCException("get_quote: finally could not get price")

    new_quote = {
        "rfq_alias": "",
        "txn_alias": "",
        "userpubkey": "",
        "base_asset": base_asset,
        "quote_asset": quote_asset,
        "user_id": user_id,
        "trader_identifier": trader_identifier,
        "quantity": base_quantity,
        "quote_quantity": quote_quantity,
        "quantity_asset": request.notional,
        "side": request.side,
        "status": "open",
        "entity": request.entity,
        "quote_price": quote_price,
        "hedge": "",
        "two_way_quote_alias": two_way_quote_alias,
        "created_at": created_time,
        "quote_type": request.quote_type,
        "account_id": request.account_id,
        "vault_id": request.vault_id,
        "settlement_destination": request.settlement_destination,
        "price_mode": request.price_mode,
    }

    process_quote = {
        "markup": request.markup,
        "fee": request.fee if request.fee else "0",
        "markup_type": request.markup_type,
        "side": request.side,
        "raw_price": raw_price,
        "quantity": request.quantity,
        "notional": request.notional,
        "fee_notional": request.fee_notional,
        "fee_type": request.fee_type,
        "market": market,
        "quote_qty_prec": quote_qty_prec,
        "base_qty_prec": base_qty_prec,
        "base_px_Prec": base_px_prec,
        "entity": request.entity
    }

    # 询价前,需要的参数准备
    symbols_data = {}
    quotes_data = {}

    # 防止fetch_quote之前,redis为拿不到价格,base_quantity为空字符串
    if base_quantity:
        quotes_data['quantity'] = base_quantity
        # 精度是0，就不做限制
        if int(base_qty_prec):
            quotes_data['quantity'] = Calc.get_num_by_prec(base_quantity, base_qty_prec)
    else:
        quotes_data['quantity'] = "0"
    symbols_data['ticker'] = symbol
    quotes_data['entity'] = request.entity
    quotes_data['dealers'] = copy.deepcopy(request.dealers)
    quotes_data['quote_type'] = request.quote_type

    if request.price_mode == "spread":
        side = request.side
    elif request.price_mode == "mid":
        side = "two_way"

    logger.info(f"---fetchQuoteV1: Amount={quotes_data['quantity']}, Symbol={ symbols_data['ticker']}, Side={side},"
                f"Markets={quotes_data['dealers']}, Entity={quotes_data['entity']}, baseQuantity={base_quantity}, "
                f"baseQtyPrec={base_qty_prec}, quoteQuantity={quote_quantity}, rawPrice={raw_price}")

    # 交易对允许询价,在talos中询价
    fixed_quote_error_message = "There is no talos market"
    normal_quote = {'buy': False, 'sell': False}
    # fetch_quote之前,redis为拿不到价格,quantity为"0",不做talos询价
    if quotes_data['quantity'] != "0":
        # 去除talos不能询价的市场
        for i in request.dealers:
            if i not in TALOS_CONFIG["MARKETS_ACCOUNTS"]["zerocap"]:
                quotes_data['dealers'].remove(i)

        # talos询价,dealer为空,不询价
        if quotes_data['dealers']:
            fetch_quote_res_data, fixed_quote_error_message, raw_price = get_talos_price(symbols_data, quotes_data, side, trader_identifier)

        if not fixed_quote_error_message:
            # talos获取的价格为空,则本次的询价使用之前的价格
            if not fetch_quote_res_data['sell_price']['price'] and not fetch_quote_res_data['buy_price']['price']:
                fixed_quote_error_message = "The price talos gets is empty"
                logger.info(f"talos询价结果: {fetch_quote_res_data}; error: {fixed_quote_error_message}")
                fetch_quote_res_data = res_data
            else:
                redis_no_found = False
                logger.info(f"talos询价结果: {fetch_quote_res_data};")
                normal_quote = {'buy': True, 'sell': True}

                # two_way 情况,talos只拿到一个价格,另一个价格从redis获取
                if request.side == 'two_way' and not fetch_quote_res_data['buy_price']['price']:
                    fetch_quote_res_data['buy_price'] = res_data['buy_price']
                    normal_quote['buy'] = False
                if request.side == 'two_way' and not fetch_quote_res_data['sell_price']['price']:
                    fetch_quote_res_data['sell_price'] = res_data['sell_price']
                    normal_quote['buy'] = False
        else:
            logger.info(f"talos询价结果: {fetch_quote_res_data}; error: {fixed_quote_error_message}")
            fetch_quote_res_data = res_data

    logger.info(f"fetch_quote_res_data: {fetch_quote_res_data}")

    # 用于检查单笔交易限额与交易总限额
    exposure_limit_res = {
        "rfq_alias": "",
        "txn_alias": "",
        "userpubkey": "",
        "base_asset": base_asset,
        "quote_asset": quote_asset,
        "user_id": user_id,
        "trader_identifier": trader_identifier,
        "quantity_asset": request.notional,
        "side": request.side,
        "status": "open",
        "entity": request.entity,
        "quote_price": quote_price,
        "hedge": "",
        "account_id": request.account_id,
        "vault_id": request.vault_id
    }

    # 获取询价后 raw_price
    for key in fetch_quote_res_data:
        if str(fetch_quote_res_data[key]['price']) != '0' and fetch_quote_res_data[key]['price']:
            raw_price = fetch_quote_res_data[key]['price']

    if request.price_mode == "mid":
        buy_raw_price = fetch_quote_res_data["buy_price"]["price"]
        sell_raw_price = fetch_quote_res_data["sell_price"]["price"]
        raw_price_benchmark = Calc(Calc(Calc(buy_raw_price) + Calc(sell_raw_price)) / 2)
        logger.info(f"raw_price_benchmark: {raw_price_benchmark}")

        # 计算 raw_price_benchmark 根据 side 剔除 fetch_quote_res_data 中不需要的询价数据
        if request.side == "buy":
            fetch_quote_res_data["sell_price"] = {"market": "", "price": 0}
        elif request.side == "sell":
            fetch_quote_res_data["buy_price"] = {"market": "", "price": 0}

    if request.notional == "base":
        base_quantity = request.quantity
        quote_quantity = Calc(Calc(base_quantity) * Calc(raw_price))
    elif request.notional == "quote":
        quote_quantity = request.quantity
        base_quantity = Calc(Calc(quote_quantity) / Calc(raw_price))
    else:
        logger.error("GetQuote: quantity asset type incorrect")
        raise ZCException("GetQuote: quantity asset type incorrect")

    exposure_limit_res["quantity"] = base_quantity
    exposure_limit_res["quote_quantity"] = quote_quantity

    # 检查单个交易员的交易限额与总限额
    single_trade_size_limit_result, exposure_limit_result = check_trader_size_limit_and_exposure_limit(exposure_limit_res)
    logger.info(f"交易金额数据检查结果: singleTradeSizeLimitResult={single_trade_size_limit_result}, exposureLimitResult={exposure_limit_result}")

    # 单笔限额检查,不过就抛错
    if not single_trade_size_limit_result:
        logger.error("check_single_trader_size_limit: trade exceeds single trade limit")
        raise ZCException("trade exceeds single trade limit")

    # 市价单的日限额必须得过、固定单的日限额不用
    if not exposure_limit_result:
        if request.quote_type == "Fixed":
            request.is_quote = False
        else:
            logger.error("check_exposure_limit: trade exceeds exposure limit")
            raise ZCException("trade exceeds exposure limit")

    if not redis_no_found:
        if fetch_quote_res_data['sell_price'] and fetch_quote_res_data['sell_price']['price'] != '0' and fetch_quote_res_data['sell_price']['price']:
            process_quote['side'] = "sell"
            process_quote['raw_price'] = raw_price_benchmark if request.price_mode == "mid" else fetch_quote_res_data['sell_price']['price']
            process_quote['market'] = fetch_quote_res_data['sell_price']['market']
            if not fetch_quote_res_data['sell_price']['market']:
                process_quote['market'] = ','.join(request.dealers)
            new_quote["normal_quote"] = normal_quote['sell']
            quote = process_quote_ask(process_quote, new_quote, fixed_quote_error_message)
            if quote:
                quotes.append(otc_pb2.QuoteOTCResponseV1(**quote))

        if fetch_quote_res_data['buy_price'] and fetch_quote_res_data['buy_price']['price'] != '0' and fetch_quote_res_data['buy_price']['price']:
            process_quote['side'] = "buy"
            process_quote['raw_price'] = process_quote['raw_price'] = raw_price_benchmark if request.price_mode == "mid" else fetch_quote_res_data['buy_price']['price']
            process_quote['market'] = fetch_quote_res_data['buy_price']['market']
            if not fetch_quote_res_data['buy_price']['market']:
                process_quote['market'] = ','.join(request.dealers)
            new_quote["normal_quote"] = normal_quote['buy']
            quote = process_quote_ask(process_quote, new_quote, fixed_quote_error_message)
            if quote:
                quotes.append(otc_pb2.QuoteOTCResponseV1(**quote))

    if request.quote_type == 'Market' and not quotes:
        text = f"Market GetQuote error: {fixed_quote_error_message}"
        logger.error(text)
        raise ZCException(text)

    return dict(status=ResponseStatusSuccessful,
                quotes=quotes,
                total=len(quotes))


def process_quote_ask(quote, new_quote, fixed_quote_error_message):
    quote_price = ""
    base_quantity = ""
    quote_quantity = ""
    markup = quote.get("markup", "0")
    fee = quote.get("fee", "0")
    fee_pct = Calc(fee)/Calc(10000)
    quote_qty_prec = quote.get("quote_qty_prec", "0")
    base_qty_prec = quote.get("base_qty_prec", "0")

    quote_alias = str(uuid.uuid1())

    if new_quote.get("quote_type") != "Fixed":
        if quote.get("markup_type") == "usd":
            if quote.get("side") == "buy":
                quote_price = Calc(Calc(quote.get("raw_price", "0")) + Calc(markup))
            else:
                quote_price = Calc(Calc(quote.get("raw_price", "0")) - Calc(markup))
        elif quote.get("markup_type") == "bps":
            if quote.get("side") == "buy":
                markup = Calc(Calc(1) + Calc(Calc(markup) / Calc(10000)))
            else:
                markup = Calc(Calc(1) - (Calc(markup) / Calc(10000)))
            quote_price = Calc(Calc(quote.get("raw_price", "0")) * Calc(markup))
        elif quote.get("markup_type") == "pips":
            if quote.get("side") == "buy":
                quote_price = Calc(Calc(quote.get("raw_price", "0")) + Calc(Calc(markup) / Calc(10000)))
            else:
                quote_price = Calc(Calc(quote.get("raw_price", "0")) - Calc(Calc(markup) / Calc(10000)))
        else:
            logger.error("GetQuote: markup type incorrect")
            raise ZCException("GetQuote: markup type incorrect")
    else:
        quote_price = new_quote.get("quote_price")

    if Calc(quote_price).value <= Calc(0).value:
        logger.error(f"GetQuote: The QuotePrice  must be greater than zero, quote_price={quote_price}")
        raise ZCException("GetQuote: The QuotePrice must be greater than zero")

    if quote.get("notional") == "base":
        base_quantity = quote.get("quantity", "0")
        quote_quantity = Calc(Calc(base_quantity) * Calc(quote_price))
    elif quote.get("notional") == "quote":
        quote_quantity = quote.get("quantity", "0")
        base_quantity = Calc(Calc(quote_quantity) / Calc(quote_price))
    else:
        logger.error("GetQuote: notional type incorrect")
        raise ZCException("GetQuote: notional type incorrect")

    total = quote_quantity

    # fee total 根据 fee notional 计算逻辑
    if quote.get("fee_notional") == "bps":
        fee_total = Calc(Calc(total) * Calc(fee_pct))
    elif quote.get("fee_notional") == "base":
        fee_total = Calc(Calc(fee) * Calc(quote_price))
    elif quote.get("fee_notional") == "quote":
        fee_total = fee
    else:
        logger.error("GetQuote: fee notional invalid")
        raise ZCException("GetQuote: fee notional invalid")

    if quote.get("fee_type", "") == "included":
        if quote.get("notional") == "quote" and quote.get("fee_notional") == "bps":
            if quote["side"] == "buy":
                quote_quantity = Calc(Calc(quote_quantity)/(Calc('1') + fee_pct))
            else:
                quote_quantity = Calc(Calc(quote_quantity)/(Calc('1') - fee_pct))
            # s25 新的 fee_total 计算方式
            fee_total = abs(Calc(Calc(total) - Calc(quote_quantity)).value)
        else:
            if quote["side"] == "buy":
                quote_quantity = Calc(Calc(quote_quantity) - Calc(fee_total))
            else:
                quote_quantity = Calc(Calc(quote_quantity) + Calc(fee_total))
        base_quantity = Calc(Calc(quote_quantity) / Calc(quote_price))
    elif quote.get("fee_type", "") == "separate":
        if quote["side"] == "buy":
            total = Calc(Calc(quote_quantity) + Calc(fee_total))
        else:
            total = Calc(Calc(quote_quantity) - Calc(fee_total))
    else:
        logger.error("GetQuote: fee type incorrect")
        raise ZCException("GetQuote: fee type incorrect")

    if new_quote.get("base_asset", "") == "ETH" and new_quote.get("quote_asset", "") == "BTC":
        base_qty_prec = 2
        quote_qty_prec = 8
    if new_quote.get("base_asset", "") == "BTC" and new_quote.get("quote_asset", "") == "UST":
        base_qty_prec = 2
    if new_quote.get("base_asset", "") == "BTC" and new_quote.get("quote_asset", "") == "USC":
        base_qty_prec = 2

    # 精度是0，就不做限制
    if int(base_qty_prec):
        base_quantity = Calc.get_num_by_prec(base_quantity, base_qty_prec)
    if int(quote_qty_prec):
        quote_quantity = Calc.get_num_by_prec(quote_quantity, quote_qty_prec)
        total = Calc.get_num_by_prec(total, quote_qty_prec)

    if Calc(0).value >= Calc(base_quantity).value or Calc(0).value >= Calc(quote_quantity).value:
        logger.error("GetQuote: The quantity is too small to get a quote,Please increase the quantity")
        raise ZCException("GetQuote: The quantity is too small to get a quote,Please increase the quantity")

    # 计算fee_pct
    if quote.get("fee_notional") == "bps":
        fee_pct = fee_pct
    elif quote.get("fee_type", "") == "included":
        fee_pct = Calc(Calc(fee_total) / Calc(total))
    elif quote.get("fee_type", "") == "separate":
        fee_pct = Calc(Calc(fee_total) / Calc(quote_quantity))

    new_quote["quote_alias"] = quote_alias
    new_quote["quantity"] = base_quantity
    new_quote["quote_quantity"] = quote_quantity
    new_quote["total"] = total
    new_quote["raw_price"] = quote["raw_price"]
    new_quote["quote_price"] = quote_price
    new_quote["markup"] = quote["markup"]
    new_quote["markup_type"] = quote["markup_type"]
    new_quote["fee"] = fee
    new_quote["fee_type"] = quote["fee_type"]
    new_quote["fee_pct"] = fee_pct
    new_quote["fee_total"] = fee_total
    new_quote["timeout"] = QUOTE_TIMEOUT
    new_quote["dealers"] = quote["market"]
    new_quote["fee_notional"] = quote["fee_notional"]
    new_quote["side"] = quote["side"]

    # 删除已存在相同quote数据
    cancel_same_quote(new_quote)

    # 创建一条新的quote数据
    insert_quotes(new_quote)

    quantitys = new_quote["quantity"]
    quote_quantitys = new_quote["quote_quantity"]
    totals = new_quote["total"]
    raw_prices = new_quote["raw_price"]
    quote_prices = new_quote["quote_price"]
    fee_totals = new_quote["fee_total"]

    quote_response = {
        "quote_alias": new_quote["quote_alias"],
        "user_id": new_quote["user_id"],
        "trader_identifier": new_quote["trader_identifier"],
        "base_asset": new_quote["base_asset"],
        "quote_asset": new_quote["quote_asset"],
        "quantity": str(quantitys),
        "quote_quantity": str(quote_quantity),
        "total": str(totals),
        "quantity_asset": new_quote["quantity_asset"],
        "raw_price": str(raw_prices),
        "quote_price": str(quote_price),
        "markup": str(quote["markup"]),
        "markup_type": new_quote["markup_type"],
        "fee": str(quote["fee"]),
        "fee_type": new_quote["fee_type"],
        "fee_pct": str(new_quote["fee_pct"]),
        "fee_total": str(fee_total),
        "side": new_quote["side"],
        "timeout": new_quote["timeout"],
        "status": new_quote["status"],
        "dealers": new_quote["dealers"],
        "two_way_quote_alias": new_quote["two_way_quote_alias"],
        "fixed_quote_error_message": fixed_quote_error_message,
    }
    return quote_response


def get_talos_price(symbols_data, quotes_data, side, trader_identifier):

    fixed_quote_error_message = ''
    if side == 'buy':
        fetch_quote_side = 'Buy'
    elif side == 'sell':
        fetch_quote_side = 'Sell'
    elif side == 'two_way':
        fetch_quote_side = ''
    else:
        raise ZCException('GetQuote side invaild!')

    try:
        request = otc_pb2.FetchQuoteRequestV1(
                symbol=symbols_data['ticker'],
                amount=quotes_data['quantity'],
                side=fetch_quote_side,
                entity=quotes_data['entity'],
                markets=quotes_data['dealers'],
                trader_identifier=trader_identifier
            )
        fetch_quote_res = fetch_quote(request)
        # 重新询价raw_price, 询价方式分为 buy,sell,2 way
        # with grpc.insecure_channel('localhost:5001') as channel:
        #     stub = market_data_pb2_grpc.MarketDataStub(channel)
        #     fetch_quote_res = stub.FetchQuote(market_data_pb2.FetchQuoteRequestV1(
        #         symbol=symbols_data['ticker'],
        #         amount=quotes_data['quantity'],
        #         side=fetch_quote_side,
        #         entity=quotes_data['entity'],
        #         markets=quotes_data['dealers'],
        #         trader_identifier=trader_identifier
        #     ))
    except Exception as e:
        fetch_quote_res_data = {
            'sell_price': {
                'market': '',
                'price': '0'
            },
            'buy_price': {
                'market': '',
                'price': '0'
            }
        }
        logger.error('get_talos_price fetch quote failed!')
        logger.error(f'get_talos_price error: {e}')
        return fetch_quote_res_data, "omd FetchQuote error", "0"

    fetch_quote_res_data = {}
    raw_price = "0"
    if fetch_quote_res["status"] == ResponseStatusSuccessful:
        fetch_quote_res_data = {
            'sell_price': {
                'market': fetch_quote_res["sell_price"]["market"].split('/')[0] if fetch_quote_res["sell_price"] else '',
                'price': fetch_quote_res["sell_price"]["price"] if fetch_quote_res["sell_price"] else '0'
            },
            'buy_price': {
                'market': fetch_quote_res["buy_price"]["market"].split('/')[0] if fetch_quote_res["buy_price"] else '',
                'price': fetch_quote_res["buy_price"]["price"] if fetch_quote_res["buy_price"] else '0'
            }
        }
    else:
        fixed_quote_error_message = fetch_quote_res["status"]
        raw_price = "0"
    return fetch_quote_res_data, fixed_quote_error_message, raw_price


def get_raw_price(symbols_data, quotes_data, side, trader_identifier):
    if side == 'buy':
        fetch_quote_side = 'Buy'
    elif side == 'sell':
        fetch_quote_side = 'Sell'
    elif side == 'two_way':
        fetch_quote_side = ''
    else:
        raise ZCException('EditRFQQuote side invaild!')

    # 重新询价raw_price, 询价方式分为 buy,sell,2 way
    # with grpc.insecure_channel('localhost:5001') as channel:
    #     stub = market_data_pb2_grpc.MarketDataStub(channel)
    #     fetch_quote_res = stub.FetchQuote(market_data_pb2.FetchQuoteRequestV1(
    #         symbol=symbols_data['ticker'],
    #         amount=quotes_data['quantity'],
    #         side=fetch_quote_side,
    #         entity=quotes_data['entity'],
    #         markets=[quotes_data['dealers']],
    #         trader_identifier=trader_identifier
    #     ))
    request = otc_pb2.FetchQuoteRequestV1(
        symbol=symbols_data['ticker'],
        amount=quotes_data['quantity'],
        side=fetch_quote_side,
        entity=quotes_data['entity'],
        markets=quotes_data['dealers'].split(","),
        trader_identifier=trader_identifier
    )
    fetch_quote_res = fetch_quote(request)

    if fetch_quote_res["status"] == ResponseStatusSuccessful:
        fetch_quote_res_data = {
            'buy': fetch_quote_res["buy_price"]["price"] if fetch_quote_res["buy_price"] else '0',
            'sell': fetch_quote_res["sell_price"]["price"] if fetch_quote_res["sell_price"] else '0'
        }
    else:
        logger.error('EditRFQQuote fetch quote failed!')
        # if quotes_data.get("normal_quote"):
        #     logger.error(f'EditRFQQuote fetch quote error: {fetch_quote_res.status}')
        #     raise ZCException(f'EditRFQQuote fetch quote failed!')
        # fetch_quote_res_data = {
        #     'buy': '0',
        #     'sell': '0'
        # }

        price_data = get_symbol_price_by_ccxt_or_redis(symbols_data['ticker'], fetch_quote_side, all_markets.keys())
        fetch_quote_res_data = {
            'buy': price_data['buy_price']['price'],
            'sell': price_data['sell_price']['price']
        }
    return fetch_quote_res_data


def compute_pnl(side, quantity, quote_price, raw_price):
    compute_side = 1 if side == "buy" else -1
    pnl = Calc(quantity * (quote_price - raw_price) * compute_side)
    return pnl


def compute_data(quotes, base_qty_prec, base_px_prec, quote_qty_prec, quote_price, quotes_data):
    """
    根据基础数据，计算 base_quantity，pnl等数据
    :param quotes:
    :param base_qty_prec:
    :param base_px_prec:
    :param quote_qty_prec:
    :param quote_price:
    :param quotes_data:
    :param side:
    :param raw_price:
    :return:
    """
    if quotes["quantity_asset"] == "base":
        base_quantity = Calc(quotes_data["quantity"])
        quote_quantity = Calc(base_quantity * quote_price)
    else:
        quote_quantity = Calc(quotes_data["quote_quantity"])
        base_quantity = Calc(quote_quantity / quote_price)

    # feet_total 根据fee notional 计算逻辑
    total = quote_quantity
    fee = Calc(quotes['fee'])
    raw_price = Calc(quotes["raw_price"])
    fee_pct = Calc(quotes['fee_pct'])

    if quotes['fee_notional'] == "bps":
        fee_total = Calc(total * fee_pct)
    elif quotes['fee_notional'] == "base":
        fee_total = Calc(fee * quote_price)
    else:
        fee_total = fee

    # fee_type分为included和sperated
    if quotes['fee_type'] == "included":
        if quotes.get("quantity_asset") == "quote" and quotes.get("fee_notional") == "bps":
            if quotes["side"] == "buy":
                quote_quantity = Calc(Calc(quote_quantity)/(Calc('1') + Calc(quotes['fee'])/10000))
            else:
                quote_quantity = Calc(Calc(quote_quantity)/(Calc('1') - Calc(quotes['fee'])/10000))
        else:
            if quotes["side"] == "buy":
                quote_quantity = Calc(Calc(quote_quantity) - Calc(fee_total))
            else:
                quote_quantity = Calc(Calc(quote_quantity) + Calc(fee_total))
        base_quantity = Calc(quote_quantity / quote_price)
    else:
        if quotes['side'] == 'buy':
            total = Calc(quote_quantity + fee_total)
        else:
            total = Calc(quote_quantity - fee_total)

    if quotes['base_asset'] == 'ETH' and quotes['quote_asset'] == 'BTC':
        base_qty_prec, base_px_prec, quote_qty_prec = 2, 6, 8
    elif quotes['base_asset'] == 'BTC' and quotes['quote_asset'] == 'UST':
        base_qty_prec = 2
    elif quotes['base_asset'] == 'BTC' and quotes['quote_asset'] == 'USC':
        base_qty_prec = 2

    # 位数保留
    base_quantity = Calc(str(round(float(str(base_quantity)), base_qty_prec)))
    quote_quantity = Calc(str(round(float(str(quote_quantity)), quote_qty_prec)))
    total = Calc(str(round(float(str(total)), base_px_prec)))
    raw_price = Calc(str(round(float(str(raw_price)), base_px_prec)))
    quote_price = Calc(str(round(float(str(quote_price)), base_px_prec)))

    # 数据默认保留12位
    default_save_px_sig = 12
    fee_total = fee_total.get_num_by_prec(str(fee_total), default_save_px_sig)

    quotes['quantity'] = str(base_quantity)
    quotes["quote_quantity"] = str(quote_quantity)
    quotes["fee_total"] = str(fee_total)
    quotes["total"] = str(total)
    quotes["raw_price"] = str(raw_price)
    quotes["quote_price"] = str(quote_price)
    return quotes


def compute_mark_up(quotes, raw_price):
    """
    make_up 计算
    bps:  buy: (quote_price/raw_price - 1) * 10000   sell: (1 - quote_price/raw_price) * 10000
    pips: buy: (quote_price - raw_price) * 10000     sell: (raw_price - quote_price) * 10000
    usd:  buy: quote_price - raw_price               sell: raw_price - quote_price
    :param quotes:
    :param raw_price:
    :return:
    """
    compute_side = 1 if quotes['side'] == "buy" else -1
    raw_price = Calc(raw_price)
    if quotes['markup_type'] == 'usd':
        init_mark_up = Calc((Calc(quotes['quote_price']) - Calc(raw_price)) * compute_side)
        mark_up = str(Calc(str(round(float(str(init_mark_up)), 2))))
    elif quotes['markup_type'] == 'pips':
        init_mark_up = Calc((Calc(quotes['quote_price']) - Calc(raw_price)) * compute_side * 10000)
        mark_up = str(round(float(str(init_mark_up))))
    else:
        if raw_price.numeric == 0:
            mark_up = 0
        else:
            init_mark_up = Calc(((Calc(quotes['quote_price'])/Calc(raw_price)) - 1) * compute_side * 10000)
            mark_up = str(round(float(str(init_mark_up))))
        quotes['markup_type'] = 'bps'
    quotes['markup'] = mark_up
    return quotes


def lp_warning(request):
    redis_cli = RedisClient()

    # 获取各大交易所的最低限额
    res_lp_config = get_lp_config()
    if not res_lp_config:
        raise ZCException("The exchange minimum price is not obtained in the Lp Config table")

    lp_warnings = []
    symbol_price = {}
    if not request.quote_alias:
        raise ZCException("The parameter quote_alias cannot be empty")
    for quote_alias in request.quote_alias:
        res_quotes = get_quotes(quote_alias)
        if not res_quotes:
            raise ZCException(f"The quote_alias {quote_alias} does not exist in the quotes table")

        # 获取quote_alias这条记录的交易所及交易市场的最低限额
        market = res_quotes.dealers
        side = res_quotes.side
        min_amount = res_lp_config.get(market, None)
        # 如果market不在lp_config内
        if market not in res_lp_config:
            logger.info(f"The {market} minimum is not obtained")
            continue
        # 如果minimum_settlement_amount为Null
        if not min_amount:
            continue
        min_amount_thousands = format(Calc(str(min_amount).replace(',', '')).value, ',')
        market_name = all_markets.get(market)
        lp_warning = {
            "warn_type": "minimum_settlement_amount",
            "message": "",
            "quote_alias": f"{quote_alias}"
        }

        # total 的值本身单位就是usd，直接与交易市场的最低限额比较
        if res_quotes.quote_asset == "USD":
            if Calc(str(min_amount)).value > Calc(str(res_quotes.total)).value:
                lp_warning["message"] = f"Note: Doesn't meet {market_name}'s minimum settlement amount of ${min_amount_thousands}"
                lp_warnings.append(lp_warning)
            continue

        # redis中获取的数据时效性判断，数据异常，historical_prices值为True
        historical_prices = False
        symbol = f"{res_quotes.quote_asset}/USD"
        if not symbol_price.get(symbol, None):
            depth = redis_cli.rejson_client.jsonget(f"{market}_quote_{symbol}_depth")
            if not depth:
                historical_prices = True
            elif 'timestamp' in depth and int(time.time() - int(depth['timestamp']) / 1000) > 3 * 60:
                historical_prices = True

        # historical_prices值为False,从redis中获取价格，反之，从Historical_Prices获取价格
        if not historical_prices:
            if symbol_price.get(symbol, None):
                price = symbol_price.get(symbol, None)
            else:
                price = redis_cli.rejson_client.jsonget(f"{market}_quote_{symbol}")
                symbol_price[symbol] = Calc(price)
            if Calc(str(min_amount)).value > Calc(str(res_quotes.total)).__mul__(str(price)):
                lp_warning["message"] = f"Note: Doesn't meet {market_name}'s minimum settlement amount of ${min_amount_thousands}"
                lp_warnings.append(lp_warning)
        else:
            res_historical_prices = get_historical_prices(res_quotes.quote_asset)

            if res_historical_prices:
                price = res_historical_prices.get('price')
            else:  # Historical_Prices 中也没有拿到价格
                price_data = get_symbol_price_by_ccxt_or_redis(symbol, [market], side)
                price = price_data[f'{side}_price']

            if not price:  # 无法获取到价格
                text = f"{quote_alias} did not get the price!"
                raise ZCException(text)

            if Calc(str(min_amount)).value > Calc(str(res_quotes.total)).__mul__(str(price)):
                lp_warning["message"] = f"Note: Doesn't meet {market_name}'s minimum settlement amount of ${min_amount_thousands}"
                lp_warnings.append(lp_warning)

    return dict(status=ResponseStatusSuccessful, lp_warnings=lp_warnings)


def lp_list(request):
    category = request.category # 分类

    # 可下单
    if category == "place":
        lp_dict = get_lp_list("PLACE")
    # 全部
    elif category == "all":
        lp_dict = get_lp_list("all")
    # 可询价
    elif category == "rfq":
        lp_dict = get_lp_list("RFQ")
    elif category == "calculator":
        lp_dict = get_lp_list("CALCULATOR")
    # 不可下单的
    elif category == "no_place":
        lp_dict = get_lp_list("NO_PLACE")
    else:
        raise ZCException(f"The category {category} is not supported")

    lp_dict = [{"name": v, "value": k} for k, v in lp_dict.items()]
    lp_dict.sort(key=lambda x: x['name'])
    return dict(status=ResponseStatusSuccessful, lp_list=lp_dict)


def get_orders(request):
    trader_identifier = request.trader_identifier
    user = get_user_info_by_user(trader_identifier)
    if not user:
        raise ZCException("User does not exist.")

    limit = request.limit
    page = request.page
    status = request.status
    role = user.role
    if role == 3:   # 交易员只可以看自己的单子
        orders, total = get_orders_data(limit, page, status, trader_identifier)
    elif role == 4: # 管理员可以看全部的单子
        orders, total = get_orders_data(limit, page, status)
    else:
        raise ZCException("illegal user.")

    return dict(status=ResponseStatusSuccessful, orders=orders, total=total)


def exec_hedge(hedge_data):
    exec_host = os.environ.get('EXEC_HOST')
    with grpc.insecure_channel(exec_host) as channel:
        stub = exec_pb2_grpc.ExecStub(channel)
        hedge_res = stub.Hedge(exec_pb2.FillV1(
            base_asset=hedge_data["base_asset"],
            quote_asset=hedge_data["quote_asset"],
            quote_price=hedge_data["quote_price"],
            quantity=hedge_data["quantity"],
            quote_quantity=hedge_data["quote_quantity"],
            status=hedge_data["status"],
            side=hedge_data["side"],
            user_id=hedge_data["user_id"],
            trader_identifier=hedge_data["trader_identifier"],
            created_at=hedge_data["created_at"],
            dealers=hedge_data["dealers"],
            total=hedge_data["total"],
            entity=hedge_data["entity"],
            order_type=hedge_data["order_type"],
            order_alias=hedge_data["order_alias"],
            currency=hedge_data["currency"],
            account_id=hedge_data["account_id"],
            vault_id=hedge_data["vault_id"]
        ))

        if hedge_res.status != "success":
            logger.error("SendLimitQuoteFill: create order failed!")
            raise ZCException("create order failed!")


def zmd_gen_receipt(receipt_data):
    zmd_host = os.environ.get('ZEROCAP_MONITOR_GRPC_ZMD')
    with grpc.insecure_channel(zmd_host) as channel:
        stub = zerocap_market_data_pb2_grpc.ZerocapMarketDataStub(channel)
        receipt_res = stub.GenTradeReceipt(zerocap_market_data_pb2.GenTradeReceiptRequestV1(**receipt_data))

        if receipt_res.status != "success":
            logger.error("SendLimitQuoteCancel: gen trader receipt failed!")
            raise ZCException("gen trader receipt failed!")


def send_limit_quote_fill(request):
    """
    限价单下单接口
    """
    # 参数非空校验及数量校验
    check_parameter(request)

    # 构建talos连接
    talos = TalosClient(entity=request.entity, trader_identifier=request.trader_identifier)

    # 检查单笔交易限额、日交易限额
    symbol = request.symbol
    check_single_and_exposure_limit(symbol, request.dealers, request.trader_identifier,
                 request.quantity, request.side, request.notional, request.limit_price)

    # 计算 fee_total, quote_quantity, total, fee_pct
    fee_total, quote_quantity, total, fee_pct = calculate_fee_total(request.fee, request.notional, request.fee_notional,
                                                           request.quantity, request.limit_price, request.side)
    # 计算 raw_price, 实际下单的价格
    raw_price = calculate_raw_price(request.limit_price, request.markup, request.markup_type, request.side)

    # 构建 order 数据
    order_alias = str(uuid.uuid1())  # order 记录唯一标识
    base_asset = symbol.split("/")[0]
    quote_asset = symbol.split("/")[1]
    created_at = int(time.time() * 1000)
    order = {
        "order_alias": order_alias,
        "txn_alias": "",
        "order_type": OrderTypeEnum.Limit,
        "status": OrderStatusEnum.Open,
        "base_asset": base_asset,
        "quote_asset": quote_asset,
        "side": SideEnum.get_const_obj(request.side),
        "quantity": request.quantity,
        "leaves_quantity": request.quantity,
        "filled_quantity": "0",
        "notional": NotionalEnum.get_const_obj(request.notional),
        "price": request.limit_price,
        "avg_price": "0",
        "user_id": request.user_id,
        "trader_identifier": request.trader_identifier,
        "entity": EntityEnum.zerocap,
        "dealers": request.dealers,
        "fee": request.fee,
        "fee_pct": fee_pct,
        "fee_type": FeeTypeEnum.Separate,
        "fee_notional": FeeNotionalEnum.get_const_obj(request.fee_notional),
        "fee_total": "0",
        "total": "0",
        "hedge": OrderHedgeEnum.LiveHedge,
        "markup": request.markup,
        "markup_type": OrderMarkUpTypeEnum.get_const_obj(request.markup_type),
        "raw_price": raw_price,
        "created_at": created_at,
        "updated_at": created_at,
        "account_id": request.account_id,
        "vault_id": request.vault_id
    }
    # 将限价单数据写入 Orders 表中
    insert_orders(order)

    # 替换交易市场名称
    new_dealers = talos.get_markets_account(request.dealers)

    try:
        # 调用 execution 服务的 Hedge 接口下单
        hedge_data = {
            "base_asset": base_asset,
            "quote_asset": quote_asset,
            "quote_price": raw_price,
            "quantity": request.quantity,
            "quote_quantity": quote_quantity,
            "status": "hedging",
            "side": "Buy" if request.side == "buy" else "Sell",
            "user_id": request.user_id,
            "trader_identifier": request.trader_identifier,
            "created_at": created_at,
            "dealers": new_dealers,
            "total": total,
            "entity": "zerocap",
            "order_type": "Limit",
            "order_alias": order_alias,
            "currency": base_asset if request.notional == "base" else quote_asset,
            "account_id": request.account_id,
            "vault_id": request.vault_id
        }
        exec_hedge(hedge_data)
    except Exception as e:
        # 下单失败，回滚数据
        db.rollback()
        logger.error(f"SendLimitQuoteFill: create limit order failed! {e}")
        raise e

    return ResponseStatusSuccessful


def cancel_order(order_id, trader_identifier):
    # 构建talos连接
    talos = TalosClient(trader_identifier=trader_identifier)

    res = talos.get_order("", order_id)
    order_data = res["info"] # 获取订单数据
    order_status = order_data["OrdStatus"]  # 订单状态

    # 订单状态为 Filled 或 DoneForDay 说明该订单已经完成
    if order_status in ("Filled", "DoneForDay"):
        logger.error(f"send_limit_quote_cancel: This order has been completed! order_id: {order_id}")
        raise ZCException("This order has been completed!")

    # 订单状态为 Canceled 说明该订单已经被取消
    if order_status == "Canceled":
        return

    # 当订单状态不是已完成 或 部分完成 或 已取消时，取消订单
    talos.cancel_an_order(order_id)


def send_limit_quote_cancel(request):
    """
    限价单取消订单接口
    1. 下单成功的传 order_id 取消 talos 订单
    2. 没有下单成功的传 order_alias 将记录置为 Canceled
    """
    if not request.order_id and not request.order_alias:
        logger.error("SendLimitQuoteCancel: parameter can not be empty!")
        raise ZCException("parameter can not be empty!")

    canceled_at = int(time.time() * 1000)
    # 没有 order_id 说明没有下单成功，根据 order_alias 更新数据
    if not request.order_id:
        update_data = {"status": OrderStatusEnum.Canceled, "canceled_at":canceled_at}
        update_order_by_alias(request.order_alias, update_data)
        return ResponseStatusSuccessful

    # 获取 transaction, order 数据
    order_data, txn_data = get_txn_by_order_id(request.order_id)
    # 订单还未成交
    if not txn_data:
        # 先取消订单
        cancel_order(request.order_id, request.trader_identifier)

        # 更新 orders 表状态
        update_data = {"status": OrderStatusEnum.Canceled, "canceled_at":canceled_at}
        update_order(update_data, request.order_id)
        return ResponseStatusSuccessful

    # 订单全部成交
    if Calc(txn_data.quantity).value == Calc(order_data.quantity).value:

        # 更新 orders 表状态
        update_data = {"status": OrderStatusEnum.Filled}
        update_order(update_data, request.order_id)

        logger.error("SendLimitQuoteCancel: The order has been completed and cannot be canceled.")
        raise ZCException("The order has been completed and cannot be canceled.")

    # 订单部分成交
    if Calc(order_data.quantity).value > Calc(txn_data.quantity).value:
        # 先取消订单
        cancel_order(request.order_id, request.trader_identifier)

        # 更新 orders 表状态
        update_data = {"status": OrderStatusEnum.PartiallyFilled, "canceled_at":canceled_at}
        update_order(update_data, request.order_id)

        # 生成交易凭据 receipt
        receipt_data = get_receipt_data(txn_data)
        zmd_gen_receipt(receipt_data)

        return ResponseStatusSuccessful


def get_customer_info_from_crm(request):
    account_id = request.account_id
    if not account_id:
        logger.error("GetCustomerInfoFromCRM: parameter account_id can not be empty!")
        raise ZCException("parameter account_id can not be empty!")
    result, kyc_approved, pa_agreed, account_name = get_customerinfo_account_id(account_id)
    return dict(status=ResponseStatusSuccessful, kyc_approved=kyc_approved, pa_agreed=pa_agreed,
                account_name=account_name, customerinfo=result)


def get_source_by_category(category):
    # 可下单
    if category == "limit":
        lp_dict = get_lp_list("PLACE")
    # 全部
    elif category == "all":
        lp_dict = get_lp_list("all")
    # 可询价
    elif category == "rfq":
        lp_dict = get_lp_list("RFQ")
    elif category == "calculator":
        lp_dict = get_lp_list("CALCULATOR")
    # 不可下单的
    elif category == "no_place":
        lp_dict = get_lp_list("NO_PLACE")
    else:
        raise ZCException(f"The category {category} is not supported")
    return lp_dict


def get_symbols(request):
    try:
        # rfq: talos + ccxt (市价单);
        # calculator: talos + ccxt + 特殊交易对AAA-AAA
        # all: talos + ccxt + gck + 特殊交易对AAA-AAA + USDT相关链的(history页面);
        # limit: talos (限价单);
        if request.quote not in ["rfq", "calculator", "all", "limit"]:
            logger.error("get_symbols: parameter quote wrong!")
            raise ZCException("Parameter quote wrong!")

        sources = list(get_source_by_category(request.quote).keys())
        if request.quote in ("all", "calculator"):
            sources.append("custom")
        sources = tuple(sources)

        bases, quotes, ticker_list = get_all_active_ems_symbols(request.quote, sources)
        data_dict = dict(bs=bases,
                         qs=quotes,
                         t_l=ticker_list)
        json_data = json.dumps(data_dict).encode('utf-8')  # 将JSON数据转换为字节串
        compressed_data = zlib.compress(json_data, level=9)  # 压缩字节串
        compressed_data = base64.b64encode(compressed_data).decode('utf-8')  # 将压缩后的数据转换为Base64编码的字符串)
        return dict(status=ResponseStatusSuccessful,
                    data=compressed_data)

    except Exception as e:
        logger.error(f'GetSymbols raises an exception: {e}')
        send_slack(
            channel='SLACK_API_OPS',
            subject="GetSymbols",
            content=e)
        raise ZCException("GetSymbols failed!")


def get_users_id_by_ems(request):

    account_id = request.account_id
    operate = request.operate

    if not operate:
        raise ZCException("parameter operate can not be empty!")
    user_id_list = query_user_id_by_ems(account_id, operate)
    return dict(
        user_id_list=user_id_list,
        status=ResponseStatusSuccessful
    )


# 获取交易员的信息
def get_trader_info(request):
    email = request.email
    user = Users.select().where((Users.email == email) & (Users.status == "active")).first()
    if not user:
        raise ZCException(1007, "The Entity ID is not exist.")

    role_id = user.role
    if not role_id:
        role_id = 5
    role = Roles.select().where(Roles.id == role_id).first()

    sign_up_date = ""
    if user.signup_date:
        sign_up_date = user.signup_date.strftime("%Y/%m/%d")

    last_login_date = ""
    last_login = Logins.select().where((Logins.email == email)).order_by(Logins.created_at.desc()).first()
    if last_login:
        last_login_date = datetime.utcfromtimestamp(int(last_login.created_at) // 1000).strftime("%Y/%m/%d")

    trader_status = TraderConfig.select().where(TraderConfig.email == email)
    if trader_status:
        status_list = []
        key_enabled = False
        for i in trader_status:
            status_list.append(i.status)
        if "active" in status_list:
            key_enabled = True
    else:
        key_enabled = False

    response = otc_pb2.TraderInfoResponseV1(
        user_id=str(user.user_id),
        view_ems=role.view_ems,
        view_portal_admin=role.view_portal_admin,
        trade=role.trade,
        approve_yields=role.approve_yields,
        role=role.role,
        status=ResponseStatusSuccessful,
        current_email=request.email,
        sign_up_date=sign_up_date,
        last_login_date=last_login_date,
        key_enabled=key_enabled
    )

    user_type = "individual"
    if not user.entity_id:
        response.user_type = user_type
        return response

    if request.account_entity_id != user.entity_id:
        relation = None
        if request.account_entity_id:
            relation = EntityRelation.select().where(
                (EntityRelation.entity_id == user.entity_id) & (EntityRelation.status == "active") &
                (EntityRelation.parent_entity_id == request.account_entity_id)
            ).first()
        # else:
        #     relation = EntityRelation.select().where(
        #         (EntityRelation.entity_id == user.entity_id) & (EntityRelation.status == "active")
        #     ).first()

        if relation:
            response.entity_child_role = relation.role
            user_type = relation.parent_entity_type
            if relation.parent_entity_type == "company":
                entity_dict = get_company_info(relation.parent_entity_id)
                entity_obj = otc_pb2.CompanyEntityResponseV1()
                for key, val in entity_dict.items():
                    if hasattr(entity_obj, key):
                        setattr(entity_obj, key, str(val))
                response.company_entity.CopyFrom(entity_obj)
            elif relation.parent_entity_type == "trust":
                entity_dict = get_trust_info(relation.parent_entity_id)
                entity_obj = otc_pb2.TrustsEntityResponseV1()
                for key, val in entity_dict.items():
                    if hasattr(entity_obj, key):
                        setattr(entity_obj, key, str(val))
                response.trusts_entity.CopyFrom(entity_obj)
            else:  # group
                entity_dict = get_group_info(relation.parent_entity_id)
                entity_obj = otc_pb2.GroupsEntityResponseV1()
                for key, val in entity_dict.items():
                    if hasattr(entity_obj, key):
                        setattr(entity_obj, key, str(val))
                response.groups_entity.CopyFrom(entity_obj)

    individual_dict = get_individual_info(user.entity_id)
    individual_obj = otc_pb2.IndividualsEntityResponseV1()
    for key, val in individual_dict.items():
        if hasattr(individual_obj, key):
            setattr(individual_obj, key, str(val))
    response.individuals_entity.CopyFrom(individual_obj)

    relation_email = Users.select(Users.email).where((Users.entity_id == user.entity_id) & (Users.status == "active"))
    emails = [em.email for em in relation_email]
    response.emails.extend(emails)
    response.user_type = user_type
    return response


def get_user_accounts_info_by_ems(request):
    result = get_account_info_by_ems(request)
    info_list = []

    for res in result:
        info_obj = otc_pb2.EMSAccountInfoData(**res)
        info_list.append(info_obj)

    return otc_pb2.GetUserAccountsInfoByEMSResponseV1(
        status=ResponseStatusSuccessful,
        account_data=info_list
    )


def get_symbol_price(request):
    symbols = request.symbols
    markets = request.markets
    side = request.side

    if not symbols or not markets or not side:
        logger.error("get_symbol_price: parameter cannot be empty!")
        raise ZCException("parameter cannot be empty!")

    symbol_list = symbols.split(",")
    market_list = markets.split(",")

    symbol_price = []

    for symbol in symbol_list:

        base_asset, quote_asset = symbol.split("/")
        # AAA 相关的交易对跳过
        if base_asset == "AAA" or quote_asset == "AAA":
            symbol_price.append(otc_pb2.SymbolPrice(
                symbol=symbol,
                buy_price='0',
                sell_price='0',
            ))
            continue

        price_data = get_symbol_price_by_ccxt_or_redis(symbol, market_list, side)

        if price_data['buy_price']['price'] == 0 and price_data['sell_price']['price'] == 0:
            text = f"can not get {symbol} price!"
            logger.error(f"get_symbol_price: {text}")
            raise ZCException(text)

        buy_price = price_data['buy_price']['price']
        sell_price = price_data['sell_price']['price']

        sp = otc_pb2.SymbolPrice(
            symbol=symbol,
            buy_price=str(buy_price) if buy_price != 0 else '',
            sell_price=str(sell_price) if sell_price != 0 else '',
        )

        symbol_price.append(sp)

    return {
        "symbol_price": symbol_price,
        "status": ResponseStatusSuccessful
    }


def quote_calculator(request):
    """
    QuoteCalculator 接口承载原有的 Fixed 询价和编辑逻辑
    不进行 redis time key 以及交易限额检查, dealers 可以为空
    也不再获取市场价格和 talos 询价，使用 raw_price 进行计算
    其余计算、数据落盘仿照 GetQuote 处理
    :param request:
    :return:
    """

    # 参数非空校验及数量校验
    check_get_quote_parameter(request)

    if request.quote_type != 'Fixed':
        logger.error("QuoteCalculator: Wrong quote type!")
        raise ZCException("QuoteCalculator: Wrong quote type!")

    # 在ems_symbols与symbols中获取对应的价格精度与数量精度
    base_qty_prec, base_px_prec, base_asset, quote_asset = get_asset_ticker_by_symbol_precision(request.symbol, request.dealers)
    # 在assets中获取quote_asset的数量精度
    quote_qty_prec, _ = get_asset_precision_by_asset_ticker(quote_asset)

    side = request.side
    user_id = request.user_id
    trader_identifier = request.trader_identifier
    quote_price = request.quote_price
    quantity = request.quantity
    raw_price = request.raw_price
    notional = request.notional
    market = ",".join(request.dealers)
    markup = request.markup
    created_at = int(request.created_at) if request.created_at else int(time.time() * 1000)
    operate = "get_quote"

    quote_alias = request.quote_alias
    if quote_alias:  # 编辑固定询价, 重新计算 raw_price, markup 默认保持不变
        operate = "edit_quote"
        markup_type = request.markup_type
        if side == "buy":
            if markup_type == "bps":
                divisor = 1 + int(markup) / 10000
                raw_price = Calc(Calc(quote_price) / Calc(divisor))
            elif markup_type == "pips":
                divisor = int(markup) / 10000
                raw_price = Calc(Calc(quote_price) - Calc(divisor))
        elif side == "sell":
            if markup_type == "bps":
                divisor = 1 - int(markup) / 10000
                raw_price = Calc(Calc(quote_price) / Calc(divisor))
            elif markup_type == "pips":
                divisor = int(markup) / 10000
                raw_price = Calc(Calc(quote_price) + Calc(divisor))

    logger.info(f"edited quote_price: {quote_price}, recalculated raw_price: {raw_price}, markup default: {markup}")

    if notional == "base":
        base_quantity = quantity
        quote_quantity = Calc(Calc(base_quantity) * Calc(raw_price))
    elif notional == "quote":
        quote_quantity = quantity
        base_quantity = Calc(Calc(quote_quantity) / Calc(raw_price))
    else:
        logger.error("QuoteCalculator: quantity asset type incorrect")
        raise ZCException("QuoteCalculator: quantity asset type incorrect")

    new_quote = {
        "rfq_alias": "",
        "txn_alias": "",
        "userpubkey": "",
        "base_asset": base_asset,
        "quote_asset": quote_asset,
        "user_id": user_id,
        "trader_identifier": trader_identifier,
        "quantity": base_quantity,
        "quote_quantity": quote_quantity,
        "quantity_asset": notional,
        "side": side,
        "status": "open",
        "entity": request.entity,
        "quote_price": quote_price,
        "hedge": "",
        "two_way_quote_alias": "",
        "created_at": created_at,
        "quote_type": request.quote_type,
        "account_id": request.account_id,
        "vault_id": request.vault_id,
        "settlement_destination": request.settlement_destination,
        "operate": operate,
        "old_alias": quote_alias
    }

    process_quote = {
        "markup": markup,
        "fee": request.fee if request.fee else "0",
        "markup_type": request.markup_type,
        "side": side,
        "raw_price": raw_price,
        "quantity": quantity,
        "notional": notional,
        "fee_notional": request.fee_notional,
        "fee_type": request.fee_type,
        "market": market,
        "quote_qty_prec": quote_qty_prec,
        "base_qty_prec": base_qty_prec,
        "base_px_Prec": base_px_prec,
        "entity": request.entity
    }

    quote = process_quote_ask(process_quote, new_quote, "")
    quote['notional'] = request.notional
    return dict(status=ResponseStatusSuccessful,
                quotes=[quote],
                total=1)


def get_account_transaction_flow(request):

    account_id = request.account_id
    if not account_id:
        raise ZCException("GetAccountTransactionFlow: account_id can not be empty!")

    thirty_day_volume, transaction_flow = get_transaction_flow_by_account_id(account_id)

    return {
        "status": ResponseStatusSuccessful,
        "thirty_day_volume": thirty_day_volume,
        "transaction_flow": transaction_flow
    }


def get_crm_notes_by_account(request):

    account_id = request.account_id
    if not account_id:
        raise ZCException("GetCrmNotesByAccount: account_id can not be empty!")

    crm_note_data = get_crm_notes_by_account_id(account_id)
    return {
        "status": ResponseStatusSuccessful,
        "crm_notes_data": crm_note_data
    }


def add_crm_note(request):

    if not request.account_id or not request.trade_email or not request.content:
        raise ZCException("AddCrmNote: parameter account_id, trade_email, content can not be empty!")

    create_crm_note(request.account_id, request.trade_email, request.content, request.timestamp)
    return {
        "status": ResponseStatusSuccessful,
    }


def fetch_quote(request):
    amount = request.amount

    talos = TalosClient(entity=request.entity, trader_identifier=request.trader_identifier)
    res, error = talos.request_quote(request.symbol, list(request.markets), amount, request.side)

    # para = None
    if not error:
        # {'sell_price': ('', 0.0), 'buy_price': ('b2c2/b2-c2-uat-zerocap', '40148.2')}
        para = {
            k: {"market": res.get(k)[0], "price": res.get(k)[1]}
            for k, v in res.items()
        }
        return dict(
            status=ResponseStatusSuccessful,
            sell_price=para["sell_price"],
            buy_price=para["buy_price"],
        )
    else:
        return dict(status=error)


def get_bid_ask(all_open_quotes_or_order, page):
    bidasks = []
    all_symbols_from_quotes = get_ems_symbol_by_b_q(all_open_quotes_or_order, page)
    for a_sym in all_symbols_from_quotes:
        price_data = get_symbol_price_by_ccxt_or_redis(a_sym['ticker'], CHANNEL_DEFAULT_ORDER, 'two_way')
        bid = price_data['buy_price']['price']
        ask = price_data['sell_price']['price']

        # 有价格才返回，没价格不订阅
        if Calc(bid).value > 0 and Calc(ask).value > 0:
            bidask = {
                'bid': str(Calc(bid)),
                'ask': str(Calc(ask)),
                'symbol': a_sym['ticker'],
            }
            bidasks.append(otc_pb2.BidAskV1(**bidask))

    return bidasks


def get_batch_bid_ask(request):
    tickers = request.tickers
    bidasks = []
    request_time = str(int(time.time() * 1000))
    page = request.page

    if request.data_type not in ('not_rfq', '', 'rfq'):
        raise Exception("invalid data type!")

    # 有 tickers 才去获取价格
    if tickers:
        ticker_list = tickers.split(',')
        all_symbols = get_active_ems_symbol(ticker_list, page)
        if request.data_type == 'not_rfq':
            all_symbol_list = [i['ticker'] for i in all_symbols]
            for ticker in ticker_list:
                if ticker not in all_symbol_list:
                    base_asset, quote_asset = ticker.split('/')
                    result = get_active_symbol(base_asset, quote_asset)
                    all_symbols.extend(result)
                    all_symbol_list.append(ticker)

        for a_sym in all_symbols:
            price_data = get_symbol_price_by_ccxt_or_redis(a_sym['ticker'], CHANNEL_DEFAULT_ORDER, 'two_way')
            bid = price_data['buy_price']['price']
            ask = price_data['sell_price']['price']

            if Calc(bid).value > 0 and Calc(ask).value > 0:
                bidask = {
                    'bid': str(Calc(bid)),
                    'ask': str(Calc(ask)),
                    'symbol': f"{a_sym['ticker']}",
                }
                bidasks.append(otc_pb2.BidAskV1(**bidask))

    quotes_bidasks = []
    orders_bidasks = []

    if request.data_type != 'not_rfq':
        all_open_quotes = get_open_quotes()
        if all_open_quotes:
            quotes_bidasks = get_bid_ask(all_open_quotes, page)

        all_open_orders = get_open_orders()
        if all_open_orders:
            orders_bidasks = get_bid_ask(all_open_orders, page)

    response = {
        'bidasks': bidasks,
        'request_at': request_time,
        'status': ResponseStatusSuccessful,
        'total': str(len(bidasks)),
        'quotes_bidasks': quotes_bidasks,
        'orders_bidasks': orders_bidasks,
    }
    return response


def get_credit_lines(request):
    if request.entity == 'zerocap':
        talos = TalosClient(entity=request.entity)
        account_info = talos.get_account_info()
    elif request.entity == 'vesper':
        talos = TalosClient(entity=request.entity)
        account_info = talos.get_account_info()
    else:
        raise Exception('entity is not supported')
    credit_lines = []
    for item in account_info:
        credit_lines.append(otc_pb2.CreditLines(
            source=item['source'],
            used=item['risk_exposure'],
            total=item['max_risk_exposure'])
        )
    return otc_pb2.GetCreditLinesResponseV1(
        credit_lines=credit_lines, status=ResponseStatusSuccessful)


def get_lp_balances(request):
    if request.entity == 'zerocap':
        talos = TalosClient(entity=request.entity)
        markets = talos.markets
        res = talos.get_balances(markets=','.join(markets))
    elif request.entity == 'vesper':
        talos = TalosClient(entity=request.entity)
        markets = talos.markets
        res = talos.get_balances(markets=','.join(markets))
    else:
        raise Exception('entity is not supported')

    response_data = []
    for market in markets:
        lp_data = res.get(f'{market}/{markets[market]}', {})
        market_data = []
        for k in lp_data:
            market_data.append(otc_pb2.LPBalances(
                asset_ticker=k,
                quantity=lp_data[k],
            ))
        response_data.append(otc_pb2.LPBalancesResponse(
            lp_name=market,
            lp_data=market_data,
        ))

    return otc_pb2.GetLPBalancesResponseV1(
        all_lp_data=response_data,
        status=ResponseStatusSuccessful
    )

def update_market_config(request):
    """
    account_name: 大写市场名称
    category: 市场分类
    
    1. 根据市场名称和分类、状态查询表中是否有数据
    2. 如果可以查到数据, 默认将该条数据置为 inactive
    3. 如果查不到数据, 默认新增一条数
    """
    # 校验参数非空以及市场分类是否合法
    check_market_config_parameters(request)

    # 查询市场及分类数据在表中是否存在, 如果存在则更新, 不存在则创建新的记录
    update_or_add_market_config(request)
    return dict(status=ResponseStatusSuccessful)


if __name__ == '__main__':
    # from pyinstrument import Profiler
    #
    # profiler = Profiler()
    # profiler.start()
    # edit_rfq_quote(ReqRequest)
    # profiler.stop()
    # profiler.print()

    request = otc_pb2.QuoteCalculatorRequestV1(
        user_id='c734477f-172e-4a02-83ed-3aa2187dba9b',
        account_id="718e9145-7066-43bf-8fd8-4674a6d2e771",
        trader_identifier="e37c11ee-491a-4cb2-b739-d6f2ad1d39da",
        vault_id="1521",
        symbol="AAA/AAA",
        quote_type="Fixed",
        quote_price="29246.5",
        quantity="1",
        notional="base",
        entity="zerocap",
        side="buy",
        markup="20",
        markup_type="bps",
        fee="1",
        fee_notional="bps",
        fee_type="separate",
        dealers=['b2c2','dvchain'],
        is_quote=True,
        raw_price="29249.5",
        created_at=''
    )

    print(quote_calculator(request))

    # from utils.dict_utils import ObjDict
    # request = ObjDict({
    #     "quote_alias": ['f0d8a5bf-82f1-4912-af49-8266645563a2',
    #                       'cff85f90-4807-4253-a3ba-1b83f882f5c4',
    #                       'c943a5a2-9068-4bc5-bf05-b58f29cfcac4']
    # })
    # print(request, "///")
    # start = time.time()
    # print(lp_warning(request))
    # print(time.time() - start)

    # for i in range(10):
    #     symbols_data = {'ticker': 'BTC/USD'}
    #     quotes_data = {'quantity': '1', 'entity': 'zerocap', 'dealers': 'dvchain'}
    #     # start = time.time()
    #     # get_raw_price(symbols_data, quotes_data, 'buy')
    #     # print('buy', time.time() - start)
    #     # start = time.time()
    #     # get_raw_price(symbols_data, quotes_data, 'sell')
    #     # print('sell', time.time() - start)
    #     start = time.time()
    #     get_raw_price(symbols_data, quotes_data, 'two_way')
    #     print('two_way', time.time() - start)
    #     time.sleep(0.2)

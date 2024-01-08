import sys
import pathlib
sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))

import time
import traceback
from datetime import datetime

import ccxt
from sqlalchemy import create_engine, text

from config.config import config
from utils.zc_exception import ZCException


POSTGRES_ADDRESS = config['CONFIG_POSTGRES']['HOST']
POSTGRES_PORT = '5432'
POSTGRES_USERNAME = config['CONFIG_POSTGRES']['USER']
POSTGRES_PASSWORD = config['CONFIG_POSTGRES']['PASSWORD']
POSTGRES_DBNAME = config['CONFIG_POSTGRES']['HQ_DATABASE']
hq_postgres_str = ('postgresql://{username}:{password}@{ipaddress}:{port}/{dbname}'.format(
    username=POSTGRES_USERNAME,
    password=POSTGRES_PASSWORD,
    ipaddress=POSTGRES_ADDRESS,
    port=POSTGRES_PORT,
    dbname=POSTGRES_DBNAME))
hq_engine = create_engine(hq_postgres_str)
# 获取每个交易所对应的 Exchange 类名称
exchanges_classes = {
    'gate': ccxt.gate,
    'binance': ccxt.binance,
    'kucoin': ccxt.kucoin,
    'okx': ccxt.okx,
    'mexc': ccxt.mexc
}


def inster_or_update_price_by_sql(sql):
    hq_conn = hq_engine.connect()
    try:
        hq_conn.execute(text(sql))
    except:
        traceback.print_exc()
        # hq_conn.db.rollback()
    hq_conn.close()


def get_history_prices(market, base, quote, start_time, end_time):
    """
    获取指定市场的，指定时间段的历史价格
    """
    sql = text(f"""
        select price::float, to_char(created_at, 'YYYY-MM-DD') as created_at FROM {market}_historical_prices 
        where base_asset='{base}' and quote_asset='{quote}' and created_at between '{start_time}' and '{end_time}';""")
    hq_conn = hq_engine.connect()
    results = hq_conn.execute(sql).fetchall()
    hq_conn.close()

    price_dict = {}
    for r in results:
        price_dict[r['created_at']] = r['price']

    return price_dict


def get_close_prices(exchange_name, symbol, timestamp_start):
    """
    获取指定交易所上 BTC/USDT 最近一年内每一日的收盘价
    
    :param exchange_name: 交易所名称，为字符串类型，可选值为 gate、binance、kucoin、okex、mexc
    :param symbol: 交易对名称，为字符串类型，如 BTC/USD
    :timestamp_start: 开始时间，格式为 UNIX 时间戳，毫秒级别
    :return: 价格列表，为一个列表类型
    """
    # 获取指定名称的 Exchange 类
    exchange_class = exchanges_classes.get(exchange_name)
    if not exchange_class:
        print('交易所名称错误，请输入 gate、binance、kucoin、okex 或 mexc')
        return {}
    
    try:
        # 创建 Exchange 对象
        exchange = exchange_class()

        # 获取每一天的收盘价
        prices = {}
        timestamp_end = int(time.time() * 1000)
        while True:
            # 获取 K 线历史数据
            ohlcv_history = exchange.fetch_ohlcv(symbol, '1d', timestamp_start, limit=500)
            if not ohlcv_history:
                break

            for ohlcv in ohlcv_history:
                timestamp = ohlcv[0] / 1000
                dt = datetime.fromtimestamp(timestamp)
                day = dt.strftime("%Y-%m-%d")
                close_price = ohlcv[4]
                prices[day] = close_price

            timestamp_start = ohlcv_history[-1][0] + 86400000 # 时间往后推一天，加上 86400000 毫秒
            if timestamp_start >= timestamp_end:
                break
        
        return prices
    
    except ccxt.ExchangeError as e:
        print('捕获 ExchangeError 异常:', e)
        return {}
    
    except ccxt.NetworkError as e:
        print('捕获 NetworkError 异常:', traceback.format_exc())
        return {}


def inster_or_update_price(data, market, base, currency, start_time, end_time):
    """
    data 是一个时间为key，价格为 vaule 的字典。如 {"2023-05-31": 27667}
    market: 指的是市场
    supplier: 指的是供应商，目前是 talos or ccxt
    base: 指的是币种
    currency: 指的是法币，现在是 USD 或 AUD
    start_time: 指的是开始时间
    end_time: 指的是结束时间
    """
    price_dict = get_history_prices(market, base, currency, start_time, end_time)
    inster = False
    inster_sql = f"""INSERT INTO {market}_historical_prices ("base_asset", "add_date", "price", "created_at", "quote_asset", "note") VALUES"""
    update_sql = ""
    for dt, price, in data.items():
        if price == 0:
            continue

        old_price = price_dict.get(dt, None)
        if old_price is None:   # 需要新写入：
            inster = True
            inster_sql += f"('{base}', 'NOW()', '{price}', '{dt}', '{currency}', ''),"

        elif old_price == 0 or abs(price-old_price)/old_price >= 0.05:   # 需要更新
            update_sql = f"UPDATE {market}_historical_prices SET price='{price}' WHERE add_date='{dt}' and base_asset='{base}' and quote_asset='{currency}';"
    inster_sql = inster_sql.rstrip(',')
    inster_sql += ';'
    if inster:
        inster_or_update_price_by_sql(inster_sql)
        print("完成写入！")
    else:
        print("无需新增！")
    if update_sql:
        inster_or_update_price_by_sql(update_sql)
        print("完成更新！")
    else:
        print("无需更新！")


if __name__ == '__main__':
    # 获取开始时间和结束时间戳
    now = int(time.time() * 1000)
    timestamp_start = now - 365 * 24 * 60 * 60 * 1000  # 一年之前的时间
    symbol = 'AIOZ/USDT'
    # symbol = 'USDT'
    # 测试获取 Gate.io 的 BTC/USDT 最近一年内每一天的收盘价
    prices = get_close_prices('gate', symbol, timestamp_start)
    print('Gate.io:', prices)

    # # 测试获取 Binance 的 BTC/USDT 最近一年内每一天的收盘价
    # prices = get_close_prices('binance')
    # print('Binance:', prices)

    # # 测试获取 KuCoin 的 BTC/USDT 最近一年内每一天的收盘价
    # prices = get_close_prices('kucoin')
    # print('KuCoin:', prices)

    # # 测试获取 OKEx 的 BTC/USDT 最近一年内每一天的收盘价
    # prices = get_close_prices('okex')
    # print('OKEx:', prices)

    # # 测试获取 MEXC 的 BTC/USDT 最近一年内每一天的收盘价
    # prices = get_close_prices('mexc')
    # print('MEXC:', prices)

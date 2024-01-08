import sys
import time
import asyncio
import traceback
# import nest_asyncio
from functools import reduce
from pathlib import Path
import ccxt.async_support as ccxt

sys.path.append(str(Path(__file__).absolute().parent.parent))

from clients.talos_cilent import TalosClient
from config.config import config, FIAT_LIST, TALOS_CONFIG, CUSTOM_ASSETS
from utils.calc import Calc
from utils.logger import logger
from db.base_models import redis_cli
from internal.risk.data_helper import conn


def get_lp_list(category):
    if category == "all":
        sql = """select distinct market_name, account_name from markets_config 
        where category != 'SUPPLEMENT' and status='active';"""
    else:
        sql = f"""SELECT market_name, account_name FROM markets_config
        WHERE category='{category}' and status='active';"""

    response = conn.execute(sql).fetchall()
    if not response:
        return []

    result = {res[0]: res[1] for res in response}
    return result


# nest_asyncio.apply()
rfq_market_list = list(get_lp_list("RFQ").keys())
supplement_market = list(get_lp_list("SUPPLEMENT").keys())
rfq_market_list.extend(supplement_market)


class SymbolPriceFetcher:
    def __init__(self):
        self.exchange_dict = {
            "binance": ccxt.binance({"apiKey": "", "secret": ""}),
            "okx": ccxt.okx({"apiKey": "", "secret": ""}),
            "gate": ccxt.gate({"apiKey": "", "secret": ""}),
            "kucoin": ccxt.kucoin({"apiKey": "", "secret": ""}),
            "mexc": ccxt.mexc({"apiKey": "", "secret": ""})
        }
        self.loop = asyncio.new_event_loop()
        self.symbol = ''
        self.markets = rfq_market_list
        self.talos_markets = list(TALOS_CONFIG['MARKETS_ACCOUNTS']['zerocap'].keys())
        self.side = 'two_way'
        self.talos = TalosClient()
        self.done_task = {}
        self.pending_task = {}

    async def async_sleep(self, res_data, seconds=5):
        if not res_data:
            await asyncio.sleep(seconds)
            return

        if res_data["buy_price"]["price"] == 0 and res_data["sell_price"]["price"] == 0:
            await asyncio.sleep(seconds)
            return res_data

        return res_data

    async def get_best_price_by_ccxt(self, market, price_data, res_data):
        res_data["buy_price"]["market"] = market
        res_data["sell_price"]["market"] = market
        if self.side == "buy":
            price = price_data["bids"][0][0]
            res_data["buy_price"]["price"] = str(Calc(price))
        elif self.side == "sell":
            price = price_data["asks"][0][0]
            res_data["sell_price"]["price"] = str(Calc(price))
        elif self.side == "two_way":
            base_price = price_data["bids"][0][0]
            ask_price = price_data["asks"][0][0]
            res_data["buy_price"]["price"] = str(Calc(base_price))
            res_data["sell_price"]["price"] = str(Calc(ask_price))
        else:
            pass
        return res_data

    async def get_price_by_ccxt(self, market):
        # LUNA->LUNC、LUNA2->LUNA
        base_asset, quote_asset = self.symbol.split("/")

        if base_asset == 'LUNA':
            base_asset = 'LUNC'
        elif base_asset == 'LUNA2':
            base_asset = 'LUNA'
        if quote_asset == 'LUNA':
            quote_asset = 'LUNC'
        elif quote_asset == 'LUNA2':
            quote_asset = 'LUNA'
        symbol = f'{base_asset}/{quote_asset}'

        res_data = {
            'buy_price': {'market': '', 'price': 0},
            'sell_price': {'market': '', 'price': 0}
        }

        market = market.lower()
        if market not in self.exchange_dict.keys():
            return res_data

        exchange = self.exchange_dict[market]
        try:
            # limit = 20 if market == "kucoin" else 1
            limit = 20
            price_data = await exchange.fetch_order_book(symbol, limit)
            res_data = await self.get_best_price_by_ccxt(market, price_data, res_data)
        except Exception:
            await exchange.close()
            logger.error(f"get {symbol} price by {market} error: {traceback.format_exc()}")
        except asyncio.exceptions.CancelledError:
            pass
        finally:
            await exchange.close()
        return res_data
    
    def get_price_by_symbol_list(self, symbol, bid_or_ask):
        keys = [f"{market}_quote_{symbol}_depth" for market in self.markets]
        timestamp_list = redis_cli.jsonmget('timestamp', keys)
        symbol_split = self.symbol.split("/")

        timeout = 10 * 60
        if symbol_split[0] in FIAT_LIST and symbol_split[1] in FIAT_LIST:
            timeout = 90 * 60

        markets = []
        for market, timestamp in zip(self.markets, timestamp_list):
            if not timestamp:
                continue

            # 10 分钟有效期
            if int(time.time() - int(timestamp) / 1000) > timeout:
                continue

            markets.append(market)

        keys = [f"{market}_quote_{symbol}_{bid_or_ask}" for market in markets]
        # 如果没有 keys 列表, 直接返回空值, 否则调用 json.mget 会报错
        if not keys:
            return []

        price_list = redis_cli.jsonmget('.', keys)

        # 防止出现 markets 或者 price_list 为 none
        if not markets:
            markets = []
        if not price_list:
            price_list = []

        market_price_list = []
        for market, price in zip(markets, price_list):
            if not price:
                continue

            price = Calc(price).value
            if not price:
                continue

            market_price_list.append({"market": market, "price": price})

        return market_price_list
    
    def get_price_by_redis(self, symbol, reverse=False):
        quote_side = []
        bid = {"market": "", "price": 0}
        ask = {"market": "", "price": 0}

        if self.side == 'buy':
            quote_side.append('ask')
        elif self.side == 'sell':
            quote_side.append('bid')
        elif self.side == 'two_way':
            quote_side = ['ask', "bid"]

        if reverse:
            base, quote = symbol.split("/")
            symbol = f"{quote}/{base}"

        for side in quote_side:
            market_price_list = self.get_price_by_symbol_list(symbol, side)
            if not market_price_list:
                continue

            if side == 'ask':
                market, raw_price = min(market_price_list, key=lambda x: x['price']).values()
                if reverse:
                    raw_price = 1 / raw_price
                bid["market"] = market
                bid["price"] = str(Calc(raw_price))
            elif side == 'bid':
                market, raw_price = max(market_price_list, key=lambda x: x['price']).values()
                if reverse:
                    raw_price = 1 / raw_price
                ask["market"] = market
                ask["price"] = str(Calc(raw_price))
        return bid, ask
    
    # task one : 十分钟内最优价
    async def get_best_price_by_talos_symbol(self, reverse=False):
        """
        获取交易对在redis十分钟之内的最优价格
        :param symbol: "ADA/USD"
        :param markets: ["b2c2", "dvchain"]
        :param side:
        :param reverse: 是否反转交易对
        :return:
        """
        fetch_quote_res_data = {'buy_price': {'market': '', 'price': 0},
                                'sell_price': {'market': '', 'price': 0}}

        bid, ask = self.get_price_by_redis(self.symbol, reverse=reverse)
        fetch_quote_res_data['buy_price'] = bid
        fetch_quote_res_data['sell_price'] = ask
        return fetch_quote_res_data
    
    def recursive_from_pg(self):
        base_asset, quote_asset = self.symbol.split("/")

        base_sql = f"""
            WITH RECURSIVE r AS (
                SELECT base_asset_id, quote_asset_id, 1 as depth, ticker::text as path
                FROM ems_symbols WHERE ticker!='{self.symbol}' and base_asset_id='{base_asset}' and status='active'
                union   ALL
                SELECT e.base_asset_id, e.quote_asset_id, depth + 1 as depth, r.path || ',' || e.ticker::text
                -- 需要防止递归深度过深，depth 设置为 3
                FROM (select base_asset_id, quote_asset_id, ticker 
                    from ems_symbols where ticker!='{self.symbol}' and status='active' and is_quote=TRUE) e, r
                WHERE e.base_asset_id = r.quote_asset_id and r.depth<3
            )
            -- 必须以要查询的值为结果，同时该值只能出现一次
            SELECT distinct r.path, r.depth FROM r where r.path like '%%/{quote_asset}' 
            and array_length(string_to_array(r.path, '/{quote_asset}'), 1)=2 
            order by r.depth limit 3;
            """

        quote_sql = f"""
            WITH RECURSIVE r AS (
                SELECT base_asset_id, quote_asset_id, 1 as depth, ticker::text as path
                FROM ems_symbols WHERE ticker!='{self.symbol}' and base_asset_id='{quote_asset}' and status='active'
                union   ALL
                SELECT e.base_asset_id, e.quote_asset_id, depth + 1 as depth, r.path || ',' || e.ticker::text
                -- 需要防止递归深度过深，depth 设置为 3
                FROM (select base_asset_id, quote_asset_id, ticker from ems_symbols 
                    where ticker!='{self.symbol}' and status='active' and is_quote=TRUE) e, r
                WHERE e.base_asset_id = r.quote_asset_id and r.depth<3
            )
            -- 必须以要查询的值为结果，同时该值只能出现一次
            SELECT distinct r.path, r.depth FROM r where r.path like '%%/{base_asset}' 
            and array_length(string_to_array(r.path, '/{base_asset}'), 1)=2 
            order by r.depth limit 3;
            """

        base_result = conn.execute(base_sql).fetchall()
        quote_result = conn.execute(quote_sql).fetchall()
        return base_result, quote_result
    
    async def get_price_by_same_base_or_quote_asset(self, path_symbol, flag):
        fetch_quote_res_data = {
            'buy_price': {'market': '', 'price': 0},
            'sell_price': {'market': '', 'price': 0}
        }

        symbol_list = path_symbol.split(",")
        s_size = len(symbol_list)
        depth_price_result = {}

        for symbol in symbol_list:
            depth_price_result[symbol] = {}
            bid, ask = self.get_price_by_redis(symbol)
            depth_price_result[symbol]['bid'] = bid
            depth_price_result[symbol]['ask'] = ask

        bid_price_lst = []
        ask_price_lst = []
        for symbol in symbol_list:
            if depth_price_result[symbol]['bid']['price'] != 0:
                bid_price_lst.append(depth_price_result[symbol]['bid']['price'])
            if depth_price_result[symbol]['ask']['price'] != 0:
                ask_price_lst.append(depth_price_result[symbol]['ask']['price'])

        b_size = len(bid_price_lst)
        a_size = len(ask_price_lst)

        if self.side == "buy" and b_size == s_size:
            price = reduce((lambda x, y: Calc(x) * Calc(y)), bid_price_lst)
            if flag == "quote":
                price = Calc(1) / Calc(price)
            fetch_quote_res_data["buy_price"]["price"] = str(Calc(price))

        elif self.side == "buy" and a_size == s_size:
            price = reduce((lambda x, y: Calc(x) * Calc(y)), ask_price_lst)
            if flag == "quote":
                price = Calc(1) / Calc(price)
            fetch_quote_res_data["sell_price"]["price"] = str(Calc(price))

        elif self.side == "two_way" and a_size == s_size and b_size == s_size:
            buy_price = reduce((lambda x, y: Calc(x) * Calc(y)), bid_price_lst)
            sell_price = reduce((lambda x, y: Calc(x) * Calc(y)), ask_price_lst)

            if flag == "quote":
                buy_price = Calc(1) / Calc(buy_price)
                sell_price = Calc(1) / Calc(sell_price)
            fetch_quote_res_data["buy_price"]["price"] = str(Calc(buy_price))
            fetch_quote_res_data["sell_price"]["price"] = str(Calc(sell_price))

        return fetch_quote_res_data

    def whether_to_add_talos_task(self):
        """
        判断是否要添加 talos 询价的任务
        如果交易对是 talos 支持的
        或者传递的市场中有 talos 的市场
        都需要添加 talos 任务
        """
        sql = f"select exists (select * from ems_symbols where ticker='{self.symbol}' and supplier='talos' and status='active');"
        res = conn.execute(sql).fetchall()
        is_talos_support = res[0][0]
        has_talos_market = False

        # 判断是否有 talos 市场
        if set(self.markets) & set(self.talos_markets):
            has_talos_market = True

        if is_talos_support or has_talos_market:
            return True
        return False

    def get_ticker_min_qty(self):
        # 多个市场的最小交易量取最大值
        sql = f"select max(min_qty) from ems_symbols where ticker='{self.symbol}' and status='active';"
        res = conn.execute(sql).fetchall()
        min_qty = res[0][0]

        # 拿不到最小交易量默认给 100
        if not min_qty:
            return 100

        return str(Calc(Calc(min_qty) * Calc(10)))

    async def get_price_by_talos_api(self, quantity):
        fetch_quote_res_data = {
            'buy_price': {'market': '', 'price': 0},
            'sell_price': {'market': '', 'price': 0}
        }
        try:
            side = '' if self.side == 'two_way' else self.side

            markets = list(set(self.markets) & set(self.talos_markets))
            # 如果没有 talos 的市场但还需要去 talos 询价, 默认使用 talos 全部市场
            if not markets:
                markets = self.talos_markets

            price_data = await self.talos.async_request_quote(self.symbol, markets, quantity, side)

            buy_price = price_data[0]['buy_price'][1]
            sell_price = price_data[0]['sell_price'][1]
            buy_market = price_data[0]['buy_price'][0].split("/")[0]
            sell_market = price_data[0]['sell_price'][0].split("/")[0]

            if side == 'buy' and buy_price != 0.0:
                fetch_quote_res_data['buy_price']['market'] = buy_market
                fetch_quote_res_data['buy_price']['price'] = buy_price
            elif side == 'sell' and sell_price != 0.0:
                fetch_quote_res_data['sell_price']['market'] = sell_market
                fetch_quote_res_data['sell_price']['price'] = sell_price
            elif side == '' and buy_price != 0.0 and sell_price != 0.0:
                fetch_quote_res_data['buy_price']['price'] = buy_price
                fetch_quote_res_data['sell_price']['price'] = sell_price
                fetch_quote_res_data['buy_price']['market'] = buy_market
                fetch_quote_res_data['sell_price']['market'] = sell_market
        except Exception:
            logger.error(traceback.format_exc())
        return fetch_quote_res_data

    def create_ccxt_tasks(self):
        tasks = [
            # ccxt 获取价格
            asyncio.create_task(self.get_price_by_ccxt("binance")),
            asyncio.create_task(self.get_price_by_ccxt("okx")),
            asyncio.create_task(self.get_price_by_ccxt("kucoin")),
            asyncio.create_task(self.get_price_by_ccxt("gate")),
            asyncio.create_task(self.get_price_by_ccxt("mexc"))
        ]

        flag = self.whether_to_add_talos_task()
        if flag:
            min_qty = self.get_ticker_min_qty()
            # 任务列表添加 talos api 获取价格
            tasks.insert(0, asyncio.create_task(self.get_price_by_talos_api(min_qty)))
        return tasks
    
    def create_redis_tasks(self):
        tasks = [
            # redis 获取价格
            asyncio.create_task(self.get_best_price_by_talos_symbol()),
            asyncio.create_task(self.get_best_price_by_talos_symbol(reverse=True)),
        ]

        # 递归获取交易对链(如 ADA/BTC 可以由 ADA/USD,USD/BTC 相乘获取)从 redis 中获取价格
        base_result, quote_result = self.recursive_from_pg()
        logger.info(f"递归查询 base 相同的交易对: {','.join([res[0] for res in base_result])}")
        logger.info(f"递归查询 quote 相同的交易对: {','.join([res[0] for res in quote_result])}")

        base_task = [asyncio.create_task(self.get_price_by_same_base_or_quote_asset(res[0], "base"))
                     for res in base_result]
        quote_task = [asyncio.create_task(self.get_price_by_same_base_or_quote_asset(res[0], "quote"))
                      for res in quote_result]
        tasks.extend(base_task)
        tasks.extend(quote_task)
        return tasks

    def get_symbol_price(self, symbol, markets, side):
        self.symbol = symbol
        self.markets = markets
        self.side = side

        logger.info(f"start get {self.symbol} price: markets {self.markets} by redis")
        tasks = self.create_redis_tasks()
        price_result = self.loop.run_until_complete(asyncio.gather(*tasks))
        for res in price_result:
            if res['buy_price']['price'] != 0 or res['sell_price']['price'] != 0:
                logger.info(f"get {self.symbol} price by redis: price_data: {res}")
                return res
            
        logger.info(f"can not get price by redis, try to using ccxt to get {self.symbol} price!")

        # 如果 redis 任务列表中全是 None，执行 ccxt 的任务
        # ccxt 任务优先级: Binance -> OKX -> Kucoin -> Gate -> MEXC:
        tasks = self.create_ccxt_tasks()
        price_result = self.loop.run_until_complete(asyncio.gather(*tasks))
        for res in price_result:
            if res['buy_price']['price'] != 0 or res['sell_price']['price'] != 0:
                logger.info(f"get {self.symbol} price by ccxt: price_data: {res}")
                return res

        logger.info(f"neither redis nor ccxt can fetch prices, return empty structure!")
        # 如果所有的任务都没能拿到价格，返回一个空结构体
        return {
            'buy_price': {'market': '', 'price': 0},
            'sell_price': {'market': '', 'price': 0}
        }

    def _close(self):
        logger.info("event loop closed!")
        self.loop.stop()
        self.loop.run_forever()
        self.loop.close()

    async def get_symbol_price_fix(self, symbol, markets, side):
        # 自定义交易对转换
        base_asset, quote_asset = symbol.split("/")
        if base_asset in CUSTOM_ASSETS:
            base_asset = "USDT"
        if quote_asset in CUSTOM_ASSETS:
            quote_asset = "USDT"

        new_symbol = f"{base_asset}/{quote_asset}"
        self.symbol = new_symbol
        self.markets = markets
        self.side = side

        tasks = self.create_redis_tasks()
        ccxt_task = self.create_ccxt_tasks()
        tasks.extend(ccxt_task)

        self.done_task, self.pending_task = await asyncio.wait(tasks, return_when=asyncio.FIRST_COMPLETED)
        for task in self.done_task:
            price_data = task.result()
            # 任务有可能会出现返回 None 的情况(ccxt 不支持的交易对)
            if price_data is not None:
                if price_data["buy_price"]["price"] == 0 and price_data["sell_price"]["price"] == 0:
                    continue
                return price_data


# def get_symbol_price_by_ccxt_or_redis_fix(symbol, markets, side):
#     symbol_price_fetcher = SymbolPriceFetcher()
#     result = symbol_price_fetcher.get_symbol_price(symbol, markets, side)
#     symbol_price_fetcher._close()
#     return result


def get_symbol_price_by_ccxt_or_redis(symbol, markets, side):
    symbol_price_fetcher = SymbolPriceFetcher()
    logger.info(f"开始获取 {symbol} 价格")
    price_data = asyncio.run(symbol_price_fetcher.get_symbol_price_fix(symbol, markets, side))

    # 将正在等待中的任务取消
    for task in symbol_price_fetcher.pending_task:
        task.cancel()

    logger.info(f"{symbol} 价格结果 {price_data}")
    return price_data if price_data else {'buy_price': {'market': '', 'price': 0},
                                          'sell_price': {'market': '', 'price': 0}}


def test(ticker_list):
    no_price = []
    for ticker in ticker_list:
        print(ticker)
        symbol_price_fetcher = SymbolPriceFetcher()
        result = symbol_price_fetcher.get_symbol_price(ticker, ["galaxy","gate","binance","dvchain","b2c2","mexc","okx","okcoin",
                                                                   "binance","cumberland","kucoin","kucoin"], "two_way")
        if not result:
            no_price.append(ticker)
        symbol_price_fetcher._close()
    print(no_price, "==============")


if __name__ == '__main__':
    symbol_lst = ["BTC/USDT", "ADA/BTC", "ETH/USD", "NEO/USD"]
    markets = ["galaxy","gate","binance","dvchain","b2c2","mexc","okx","okcoin","binance","cumberland","kucoin"]
    start = time.time()
    for s in symbol_lst:
        result = get_symbol_price_by_ccxt_or_redis(s, markets, "two_way")
        print(result)
        print("*"*100)
    print(time.time() - start)


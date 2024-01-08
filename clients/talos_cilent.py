import os
import sys
import uuid
import time
from datetime import datetime, timezone

sys.path.append(os.path.abspath(os.path.join(
    os.getcwd(), os.pardir, os.pardir)))
sys.path.append('..')

from utils.logger import logger
from utils.slack_utils import send_slack
from clients.talos.talos_rest_client import TalosRestClient


class TalosClient(TalosRestClient):

    def __init__(self, entity="zerocap", trader_identifier=""):
        super().__init__(entity=entity, trader_identifier=trader_identifier)
        self.logger = logger

    def get_orders(self):
        return self.get("/v1/orders", "Statuses=New")
    
    def get_an_orders(self, order_id):
        return self.get(f"/v1/orders/{order_id}")

    # 获取余额
    def get_balances(self, currencies=None, markets=None, show_zero_balances=None):
        query = ""
        if currencies:
            query += f'Currencies={currencies}'
        if markets:
            query += f'&Markets={markets}'
        if show_zero_balances:
            query += f'&ShowZeroBalances={show_zero_balances}'
        res = self.get("/v1/balances", query)

        if isinstance(res, dict):
            balances = {}
            if not res["data"]:
                return None
            for data in res["data"]:
                if data["Account"] in balances:
                    balances[data["Account"]][data["Currency"]] = data["Amount"]
                else:
                    balances[data["Account"]] = {}
                    balances[data["Account"]][data["Currency"]] = data["Amount"]
            return balances
        else:
            # 参数错误
            logger.error(res.text)
            send_slack(channel='SLACK_API_OPS',
                       subject="get_balances error",
                       content=f"error: {res.text}\n")
            return {}

    # 获取报价 POST
    def request_quote(self, symbol, markets, amount, side):
        """
        This method is used to get quotes, based on the talos api

        @params
            symbol  string,          like: "BTC/USD"
            markets list,            like: ['b2c2', 'dvchain', 'wintermute']
            amount  float or string, like: 0.001 or "0.001"
            side    string, like:    like: "Buy" or "Sell"

        @returns
            price - tuple type, like: ('dvchain', '10424.14')
        """
        markets = self.get_markets_account(','.join(markets)).split(',')
        utc_now = datetime.now(timezone.utc)
        utc_datetime = utc_now.strftime("%Y-%m-%dT%H:%M:%S.000000Z")

        uuid1 = uuid.uuid1()
        currency = symbol.upper().split('/')[0]
        symbol = '-'.join(symbol.upper().split('/'))

        data = {
            "Symbol": symbol,
            "Currency": currency,
            "Side": side,
            "QuoteReqID": str(uuid1),
            "OrderQty": amount,
            "Markets": markets,
            "TransactTime": utc_datetime
        }
        path = "/v1/quotes"
        query = "wait-for-status=confirmed&timeout=5s"
        res = self.post(path, query, data, utc_datetime)
        self.logger.info(f"quote_res: {res}")

        sell_price = (None, float('0.0'))
        buy_price = (None, float('0.0'))
        price = {
            'sell_price': sell_price,
            'buy_price': buy_price
        }
        if isinstance(res, dict):
            inquiry_tips = ""
            if not res["data"]:
                log = "Unable to get price from "
                for i in markets:
                    log = log + str(i) + " and "
                log = log[:-5]
                self.logger.info(log)
                return price, "return value has no price"
            markets = res["data"][0].get("Markets", {})
            prices = {}
            buy_price, buy_prices, inquiry_tips_buy = self.get_buy_price(markets)
            prices.update({"buy_prices": buy_prices})
            price.update({'buy_price': buy_price})
            sell_price, sell_prices, inquiry_tips_sell = self.get_sell_price(markets)
            prices.update({"sell_prices": sell_prices})
            price.update({'sell_price': sell_price})

            if side == "Buy":
                inquiry_tips = inquiry_tips_buy
            elif side == "Sell":
                inquiry_tips = inquiry_tips_sell
            elif side == "":
                inquiry_tips = inquiry_tips_buy + inquiry_tips_sell

            self.logger.info(
                f"All market quotes: {prices}\nside: {side}\nbest quotes: {price}")
            if not price.get("buy_price")[0] and not price.get("sell_price")[0]:
                self.logger.info(f"inquiry_tips: {inquiry_tips}")
                return price, inquiry_tips
            return price, None

        # 不支持交易对与参数错误
        if "Invalid symbol" in res.text:
            self.logger.info("This trading pair is not supported by Talos")
            error = "Invalid symbol"
        elif "Unauthorized" in res.text:
            self.logger.info(
                "Account is unauthorized, api_key and api_secret are wrong")
            error = "Unauthorized"
        else:
            error = res.text
        self.logger.error(res.text)
        send_slack(channel='SLACK_API_OPS',
                   subject="request_quote error",
                   content=f"error: {res.text}\n")

        return price, error

    def get_buy_price(self, markets):
        inquiry_tips = ""
        price = ("", float('0.0'))
        prices = {}
        for market in markets:
            if market.get("OfferAmt", None):
                prices[market["MarketAccount"]
                ] = market.get("OfferPx", None)
            else:
                self.logger.info(
                    f"Unable to get price from {market['Market']}")
            market_inquiry_tips = market.get("Text", "")
            if market_inquiry_tips:
                inquiry_tips += f"{market['Market']} buy: {market_inquiry_tips}. <br>"
            # 获取Buy的最优为最小值
        if prices:
            price = sorted(prices.items(), key=lambda item: (
                float(item[1]), item[0]), reverse=True).pop()
        return price, prices, inquiry_tips

    def get_sell_price(self, markets):
        inquiry_tips = ""
        price = ("", float('0.0'))
        prices = {}
        for market in markets:
            if market.get("BidAmt", None):
                prices[market["MarketAccount"]
                ] = market.get("BidPx", None)
            else:
                self.logger.info(
                    f"Unable to get price from {market['Market']}")
            market_inquiry_tips = market.get("Text", "")
            if market_inquiry_tips:
                inquiry_tips += f"{market['Market']} sell: {market_inquiry_tips}. <br>"

        # 获取Sell的最优为最大值
        if prices:
            price = sorted(
                prices.items(), key=lambda item: (-float(item[1]), item[0]), reverse=True).pop()
        return price, prices, inquiry_tips

    # 获取报价信息 GET(需要提供 RFQID)
    def get_quote(self, rfq_id):
        path = f"/v1/quotes/{rfq_id}"
        return self.get(path, is_json_response=False)
    
    # 取消询价
    def cancle_a_quote(self, rfq_id):
        path = f"/v1/quotes/{rfq_id}"
        query = "wait-for-status=confirmed&timeout=5s"

        return self.delete(path, query)

    # 提交订单
    def create_order(self, symbol, markets, _type, side, amount, currency=None, price=None):
        utc_now = datetime.utcnow()
        utc_datetime = utc_now.strftime("%Y-%m-%dT%H:%M:%S.000000Z")

        base, quote = symbol.upper().split('/')
        uuid1 = uuid.uuid1()
        data = {
            "ClOrdID": str(uuid1),
            "Markets": markets,
            "OrdType": _type,
            "OrderQty": amount,
            "Side": side,
            "Strategy": _type,
            "Symbol": f"{base}-{quote}",
            "TransactTime": utc_datetime,
            "Price": price,
            "Currency": currency if currency else base
        }
        path = "/v1/orders"
        query = "wait-for-status=confirmed&timeout=5s"

        res = self.post(path, query, data, utc_datetime)
        timestamp = int(time.time() * 1000)

        response = {
            'id': str(res["data"][0]['OrderID']),
            'timestamp': int(timestamp),
            'symbol': symbol,
            'type': _type,
            'side': side,
            'price': str(price),
            'amount': str(amount),
            'info': res,
            'status': 'open',
            'filled': 0,
            'remaining': 0
        }

        if res["data"][0]['OrdStatus'] != "Rejected":
            logger.info(f"Created limit order successfully")
            response["filled"] = amount
            response["symbol"] = symbol
            response["avgprice"] = price
        else:
            logger.info(f"Failed to create limit order")
            response['status'] = 'failed'
            logger.error(f'talos order didnt fill res={res}')
            send_slack(
                channel='SLACK_API_OPS',
                subject="talos error",
                content=f'talos order didnt fill res={res}')
        logger.info(f"Order result: {response}")
        logger.info("Create an limit order end")
        return response

    # 取消订单(需要提供订单的 order_id or RFQID)
    def cancel_an_order(self, order_id):
        path = f"/v1/orders/{order_id}"
        query = "wait-for-status=completed"

        return self.delete(path, query)

    # 提交订单
    def create_instant_order(self, symbol, market, _type, side, amount, price=None):
        """
        This method is used to create instantaneous orders, based on the talos api

        @params
            symbol  string,          like: "BTC/USD"
            market  string,          like: 'b2c2' or 'dvchain' or 'wintermute'
            type    string,          like: "Market"
            side    string, like:    like: "Buy" or "Sell"
            amount  float or string, like: 0.001 or "0.001"
            price   string,          like: '20.06'

        @returns
            response - dick type
        """
        logger.info("Create an instant order start")
        utc_now = datetime.now(timezone.utc)
        utc_datetime = utc_now.strftime("%Y-%m-%dT%H:%M:%S.000000Z")

        symbol = '-'.join(symbol.upper().split('/'))
        uuid1 = uuid.uuid1()
        data = {
            "ClOrdID": str(uuid1),
            "Markets": [market],
            "OrdType": _type,
            "OrderQty": float(amount),
            "Currency": symbol.upper().split('-')[0],
            "Side": side,
            "Symbol": symbol,
            "TransactTime": utc_datetime,
            "ExpectedFillQty": float(amount)
        }
        path = "/v1/instant"
        query = "wait-for-status=completed"
        logger.info(f"data: {data}")

        res = self.post(path, query, data, utc_datetime)
        timestamp = int(time.time() * 1000)

        response = {
            'id': str(res["data"][0]['OrderID']),
            'timestamp': int(timestamp),
            'symbol': symbol.replace('-', '/'),
            'type': _type,
            'side': side,
            'price': str(price),
            'amount': str(amount),
            'info': res,
            'status': 'open',
            'filled': 0,
            'remaining': 0
        }

        if res["data"][0]['OrdStatus'] != "Rejected":
            logger.info(f"Created order successfully")
            response['avgprice'] = res["data"][0]['AvgPx']
            response['filled'] = amount
            response['status'] = 'closed'
        else:
            logger.info(f"Failed to create order")
            response['status'] = 'canceled'
            logger.error(f'talos order didnt fill res={res}')
            send_slack(
                channel='SLACK_API_OPS',
                subject="talos error",
                content=f'talos order didnt fill res={res}')
        logger.info(f"Order result: {response}")
        logger.info("Create an instant order end")
        return response

    # 获取 customer 订单(需要提供订单的 order_id)
    def get_customer_order(self, order_id, summary=False):
        path = f'/v1/customer/orders/{order_id}/summary'
        if summary:
            path += f'{path}/summary'

        res = self.get(path)

        data = res['data']
        if not data:
            logger.error(f'Invalid order_id {order_id}, res: {res}')
            return

        timestamp = data['TransactTime']
        timestamp = time.mktime(time.strptime(timestamp, "%Y-%m-%dT%H:%M:%S.%fZ"))
        result = {
            'id': str(data["OrderID"]),
            'timestamp': int(timestamp),
            'symbol': data['Symbol'].replace('-', '/'),
            'type': 'limit',
            'side':  data['Side'],
            'amount': data['OrderQty'],
            'info': data,
            'price': data['Price'],
            'avgprice': data['Price'],
            'status' : 'canceled',
            'filled': 0,
            'remaining' : float(data['OrderQty'])}

        if data['OrdStatus'] != "Rejected":
            price = self.get_order_price(data['Markets'])
            result['filled'] = float(data['OrderQty'])
            result['price'] = price,
            result['avgprice'] = price,
            result['status'] = 'closed'
            result['remaining'] = 0

        return result

    # 获取订单(需要提供订单的 order_id)
    def get_order(self, symbol, order_id):
        path = "/v1/orders"
        query = f"OrderID={order_id}"
        res = self.get(path, query)

        exists = res['data']
        if not exists:
            logger.error(f'Invalid order_id {order_id}')
            return

        data = exists[0]
        timestamp = data['TransactTime']
        timestamp = time.mktime(time.strptime(timestamp, "%Y-%m-%dT%H:%M:%S.%fZ"))

        result = {
            'id': str(data["OrderID"]),
            'timestamp': int(timestamp),
            'symbol': symbol,
            'type': 'limit',
            'side':  data['Side'],
            'amount': data['OrderQty'],
            'info': data,
            'price': data['Price'],
            'avgprice': data['Price'],
            'status' : 'canceled',
            'filled': 0,
            'remaining' : float(data['OrderQty'])}

        if data['OrdStatus'] != "Rejected":
            price = self.get_order_price(data['Markets'])
            result['filled'] = float(data['OrderQty'])
            result['price'] = price,
            result['avgprice'] = price,
            result['status'] = 'closed'
            result['remaining'] = 0

        return result

    @staticmethod
    def get_order_price(markets):
        if not markets:
            return 0

        for market in markets:
            if market.get('Price', None):
                return market['Price']

    def get_exposure(self):
        return self.get("/v1/exposure/limits")

    def get_account_info(self):
        markets_lst = self.markets.keys()
        result_lst = []
        for market in markets_lst:
            result = self.redis_client.get(f'{market}_{self.entity}_exposure')
            if result:
                result_lst.append({
                    'source': market,
                    'risk_exposure': result.get('MarketExposure', result.get('Exposure', '0.00')),
                    'max_risk_exposure': result.get('MarketLimit', result.get('ExposureLimit', '0.00')),
                })
        return result_lst

    def get_counter_party(self):
        return self.get('/v1/exposure/definitions')

    def get_security_market(self, markets, symbols):
        return self.get('/v1/markets/securities', f'Markets={self.get_markets_account(markets)}&Symbols={symbols}')
    
    def get_security(self, symbols=None):
        if symbols:
            return self.get('/v1/securities', f'Symbols={symbols}')

        return self.get('/v1/securities')

    def get_credential_schemas(self):
        return self.get('/v1/credential-schemas')
    
    def update_market_security_modes(self, market, symbol, up=True):
        market_account_name = self.get_market_account(market)
        symbol = symbol.replace('/', '-')
        body = {
            "Mode": 'Up' if up else 'Down',
        }
        return self.patch(
            f'/v1/market-security-modes/{market_account_name}/symbol/{symbol}',
            body=body,
        )

    def get_history_orders(self, start_date, after=None):
        path = "/v1/trade-history"
        query = f"StartDate={start_date}&limit=1000"
        if next:
            query += f"&after={after}"
        return self.get(path, query)

    async def async_request_quote(self, symbol, markets, amount, side):
        """
        This method is used to get quotes, based on the talos api

        @params
            symbol  string,          like: "BTC/USD"
            markets list,            like: ['b2c2', 'dvchain', 'wintermute']
            amount  float or string, like: 0.001 or "0.001"
            side    string, like:    like: "Buy" or "Sell"

        @returns
            price - tuple type, like: ('dvchain', '10424.14')
        """
        markets = self.get_markets_account(','.join(markets)).split(',')
        utc_now = datetime.now(timezone.utc)
        utc_datetime = utc_now.strftime("%Y-%m-%dT%H:%M:%S.000000Z")

        uuid1 = uuid.uuid1()
        currency = symbol.upper().split('/')[0]
        symbol = '-'.join(symbol.upper().split('/'))

        data = {
            "Symbol": symbol,
            "Currency": currency,
            "Side": side,
            "QuoteReqID": str(uuid1),
            "OrderQty": amount,
            "Markets": markets,
            "TransactTime": utc_datetime
        }
        path = "/v1/quotes"
        query = "wait-for-status=confirmed&timeout=5s"
        res = await self.async_post(path, query, data, utc_datetime)
        self.logger.info(f"quote_res: {res}")

        sell_price = (None, float('0.0'))
        buy_price = (None, float('0.0'))
        price = {
            'sell_price': sell_price,
            'buy_price': buy_price
        }
        if isinstance(res, dict):
            inquiry_tips = ""
            if not res["data"]:
                log = "Unable to get price from "
                for i in markets:
                    log = log + str(i) + " and "
                log = log[:-5]
                self.logger.info(log)
                return price, "return value has no price"
            markets = res["data"][0].get("Markets", {})
            prices = {}
            buy_price, buy_prices, inquiry_tips_buy = self.get_buy_price(markets)
            prices.update({"buy_prices": buy_prices})
            price.update({'buy_price': buy_price})
            sell_price, sell_prices, inquiry_tips_sell = self.get_sell_price(markets)
            prices.update({"sell_prices": sell_prices})
            price.update({'sell_price': sell_price})

            if side == "Buy":
                inquiry_tips = inquiry_tips_buy
            elif side == "Sell":
                inquiry_tips = inquiry_tips_sell
            elif side == "":
                inquiry_tips = inquiry_tips_buy + inquiry_tips_sell

            self.logger.info(
                f"All market quotes: {prices}\nside: {side}\nbest quotes: {price}")
            if not price.get("buy_price")[0] and not price.get("sell_price")[0]:
                self.logger.info(f"inquiry_tips: {inquiry_tips}")
                return price, inquiry_tips
            return price, None

        # 不支持交易对与参数错误
        if "Invalid symbol" in res.text():
            self.logger.info("This trading pair is not supported by Talos")
            error = "Invalid symbol"
        elif "Unauthorized" in res.text():
            self.logger.info(
                "Account is unauthorized, api_key and api_secret are wrong")
            error = "Unauthorized"
        else:
            error = res.text
        self.logger.error(res.text)
        send_slack(channel='SLACK_API_OPS',
                   subject="request_quote error",
                   content=f"error: {res.text}\n")

        return price, error


if __name__ == '__main__':
    talos = TalosClient()
    # print(talos.get_balances())
    # print(talos.get_security('ETH-USD'), "///")
    # print(talos.get_security(), "///")
    import asyncio
    markets = ['b2c2']
    result = asyncio.run(talos.async_request_quote("ADA/BTC", markets, "10", 'Buy'))  # BTC/USD
    # print(result[2])
    # print(talos.get_orders())
    # # print(result[0]['buy_price'][1], "====")
    # # rfqid = 'b32a3462-b6f4-11ed-985d-acde48001122'
    # rfqid = result[2]
    # talos.cancel_an_order(rfqid)
    # print(talos.get_orders())
    # market = result[0][0]
    # price = result[0][1]
    # print(market, type(market), price, type(price))
    # print(talos.get_order("68a25b98-f73e-43db-958f-79d66ccfbbab"))

    # print(talos.get_balances(markets="b2c2,dvchain,wintermute"))
    # print(talos.create_instant_order(
    #     "ETH/USD", market, "Market", "Buy", "0.05", price))
    # print(talos.create_order("BTC/USD", "b2c2", "Market", "Buy", "0.001", price))
    # print(talos.get_balances(markets="b2c2,dvchain,wintermute"))

    # print(talos.cancel_an_order("1753ffc3-051c-4633-b315-b6292b3f131c"))
    # print(talos.get_order("7230045a-0610-4b7a-b904-564b6eaa85c5"))
    # print(talos.get_quote("782b9ae3-06b1-47d2-a33a-2f5c6a82dc90"))
    # print(talos.get_order("ETH/USD", "7356d3e0-2e5e-43bc-b3e6-846aaa75147f"))
    # print(talos.get_customer_order('794f67b3-fae9-4bb2-8883-7a410bfae078'))
    # print(talos.get_credential_schemas())

import sys
import time
import traceback
from pathlib import Path
import ccxt
import threading

sys.path.append(str(Path(__file__).parent.parent.parent.absolute()))
from utils.get_market_price import get_symbol_price_by_ccxt_or_redis
from db.models import EMSSymbols
from utils.logger import setup_log

logger = setup_log("ccxt_test")


class CcxtTest:
    def __init__(self):
        self.found_list = []
        self.all_not_found_list = []
        self.ccxt_not_found_list = []
        self.otc_not_found_list = []

    def query_symbol_source(self):
        res = EMSSymbols.select(EMSSymbols.ticker.distinct()).where(EMSSymbols.supplier == 'ccxt')
        result = [i.ticker for i in res]
        return result

    def run(self, result):
        init_api_key = {'apiKey': '', 'secret': '', 'newUpdates': False}
        market_cursor_dict = {
            "binance": ccxt.binance(init_api_key),
            "okx": ccxt.okx(init_api_key),
            "kucoin": ccxt.kucoin(init_api_key),
            "gate": ccxt.gate(init_api_key),
            "mexc": ccxt.mexc(init_api_key),
        }

        for index, ticker in enumerate(result):
            try:
                ccxt_found_flag = 0
                otc_found_flag = 0
                logger.info(f"进度{index}/{len(result)}, 当前交易对: {ticker}")

                for market, market_cursor in market_cursor_dict.items():
                    try:
                        res = market_cursor.fetch_order_book(ticker, limit=20)
                        # ccxt 只有买或者只有卖，认为是异常数据
                        if res['bids'] != [] and res['asks'] != []:
                            ccxt_found_flag = 1
                            break
                    except Exception:
                        pass

                # 豪江的方法, 保证买卖都有数据，才认为是正常的，只有一方就是异常数据
                otc_data = get_symbol_price_by_ccxt_or_redis(symbol=ticker, markets=['binance'], side='two_way')
                if otc_data is None:
                    pass
                elif otc_data['buy_price']['price'] and otc_data['sell_price']['price']:
                    otc_found_flag = 1

                if ccxt_found_flag and otc_found_flag:
                    self.found_list.append(ticker)
                elif not ccxt_found_flag and not otc_found_flag:
                    self.all_not_found_list.append(ticker)
                elif ccxt_found_flag and not otc_found_flag:
                    self.otc_not_found_list.append(ticker)
                elif not ccxt_found_flag and otc_found_flag:
                    self.ccxt_not_found_list.append(ticker)

                time.sleep(0.001)
            except Exception:
                logger.info(traceback.format_exc())
                logger.info(f'异常交易对:{ticker}')

    def main(self, num=100):
        result = self.query_symbol_source()
        data_num = int(len(result) / num) + 1
        thread_list = []
        for i in range(num):
            data = result[i*data_num: (i+1)*data_num]
            thread_list.append(threading.Thread(target=self.run, args=(data, )))

        for t in thread_list:
            t.start()

        for t in thread_list:
            t.join()

        logger.info(f"ccxt_not_found_list, {self.ccxt_not_found_list}")
        logger.info(f"otc_not_found_list, {self.otc_not_found_list}")
        logger.info(f"found_list, {self.found_list}")
        logger.info(f"all_not_found_list, {self.all_not_found_list}")


if __name__ == "__main__":
    ccxt_test = CcxtTest()
    ccxt_test.main()

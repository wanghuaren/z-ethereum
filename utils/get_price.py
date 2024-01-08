import sys
import time
import asyncio
import traceback
import nest_asyncio
from functools import reduce
from pathlib import Path
import ccxt.async_support as ccxt

sys.path.append(str(Path(__file__).absolute().parent.parent))

from clients.talos_cilent import TalosClient
from config.config import config, FIAT_LIST, TALOS_CONFIG
from utils.calc import Calc
from utils.logger import logger
from db.base_models import redis_cli
from internal.risk.data_helper import conn
from internal.rfq.data_helper import get_lp_list

nest_asyncio.apply()
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
        # self.loop = asyncio.new_event_loop()
        self.symbol = ''
        self.markets = rfq_market_list
        self.talos_markets = list(TALOS_CONFIG['MARKETS_ACCOUNTS']['zerocap'].keys())
        self.side = 'two_way'
        self.talos = TalosClient()
        self.result = {}

    async def async_sleep(self, res_data, seconds=5):
        if not res_data:
            await asyncio.sleep(5)
            return

        if res_data["buy_price"]["price"] == 0 and res_data["sell_price"]["price"] == 0:
            await asyncio.sleep(seconds)
            return res_data

        return res_data
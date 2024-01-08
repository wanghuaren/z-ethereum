import sys
import time
import traceback
from pathlib import Path
import ccxt
import threading
import hmac
import uuid
import json
import base64
import hashlib
import requests
from datetime import datetime, timezone

sys.path.append(str(Path(__file__).parent.parent.parent.absolute()))
from utils.get_market_price import get_symbol_price_by_ccxt_or_redis
from db.models import EMSSymbols
from utils.logger import setup_log

logger = setup_log("test_talos")

ticker_list = ['BNB/ZAR', 'LINK/AAVE', 'CHZ/CAD', 'LTC/EOS', 'BSV/BCH', 'HKD/JPY', 'XMR/AUD', 'CVX/USD', 'LRC/GBP', 'DAI/SGD', 'EUR/NZD', 'ADA/BCH', 'CELO/USD', 'USD/ILS', 'KSM/DOT', 'UNI/CAD', 'ETHW/EUR', 'BTC/ADA', 'BAL/USDC', 'EUR/SEK', 'HBAR/CAD', 'TRX/EOS', 'UST/USDT', 'STORJ/CAD', 'UNI/ZAR', 'BTC/DOGE', 'USDT/CAD', 'MKR/CAD', 'ICP/GBP', 'SHIB/JPY', 'OXT/JPY', 'SYS/USD', 'UMA/USD', 'YFI/CAD', 'USDC/SGD', 'ATOM/JPY', 'USDT/ZAR', 'CAD/CHF', 'USD/NOK', 'JPY/ZAR', 'USD/HKD', 'QNT/CAD', 'BCH/ZAR', 'DOT/JPY', 'GALA/CAD', 'ZEC/EUR', 'USDC/EUR', 'RUNE/CAD', 'BTC/XRP', 'TRX/BCH',
'CAD/MXN', 'USDK/USD', 'ADA/CAD', 'ETH/BCH', 'REN/EUR', 'NOK/SEK', 'AUD/CHF', 'DAI/BTC', 'OMG/CAD', 'EUR/HKD', 'CAD/JPY', 'CHF/JPY', 'QCAD/CAD', 'USDC/BUSD', 'PAXG/USD', 'DAI/EUR', 'BAND/CAD', 'USD1/CAD1', 'XLM/CAD', 'EUR/DKK', 'UNI/SGD', 'FLOW/USD', 'RNDR/EUR', 'CAD1/BTC', 'GBP/NZD', 'VET/JPY', 'SOL/CHF', 'UST/USD', 'BTC/DOT', 'CRV/GBP', 'ARB/USD', 'MIA/BTC', 'BTC/XLM', 'BSV/GBP', 'FIL/EUR', 'STX/USD', 'EUR/NOK', 'FIL/CAD', 'USDT/AUD', 'XMR/EUR', 'AVAX/CAD', 'MAGIC/USD', 'SOL/ZAR', 'LTC/BCH', 'LTC/ZAR', 'LTC/SGD', 'APE/CAD', 'BSV/CHF', 'EUR/TRY', 'XTZ/JPY', 'USD/CZK', 'LUNA/EUR', 'ANKR/CAD', 'MATIC/JPY', 'COMP/NZD', 'USD/MXN', 'EUR/PLN', 'TRX/SGD', 'XRP/SGD',
'KSM/BNB', 'MIA/USD', 'ONE/USDC', 'STMX/USD', 'AVAX/ZAR', 'CRV/CAD', 'DOT/MXN', 'XBTC/BTC', 'NEAR/SGD', 'XTZ/NZD', 'AAVE/JPY', 'ALICE/CAD', 'USDT/CNH', 'XBTC/USD', 'TULIP/CAD', 'HKC/USDT', 'BTC/NZD', 'SHIB/GBP', 'USDP/CAD', 'XRP/MXN', 'ETHW/CAD', 'USD/NZD', 'LTC/CAD', 'SOL/NZD', 'UMA/USDC', 'LUNR/USD', 'DAI/NZD', 'EUR/CZK', 'NZD/JPY', 'DOT/ZAR', 'EUR/CNH', 'BNB/CHF', 'GBP/USDC', 'AUD/CAD', 'LINK/BCH', 'NEAR/JPY', 'BAND/USD', 'BSV/BUSD', 'USDC/JPY', 'USDC/NZD', 'ETHW/JPY', 'LTC/NZD', 'DIKO/USD', 'EOS/JPY', 'LRC/USD', 'GLMR/EUR', 'USDC/MXN', 'USDT/BTC', 'AUD/ZAR', 'ANKR/USD', 'WBTC/CAD', 'LUNA/BNB', 'SNM/USD', 'ATOM/CAD', 'MANA/JPY', 'COMP/JPY', 'MIA/STX',
'MANA/DAI', 'API3/USD', 'UNI/NZD', 'USDP/USD', 'QNT/USD', 'CHR/CAD', 'RAY/CAD', 'SHIB/CAD', 'GBP/JPY', 'DOGE/NZD', 'USDT/CHF', 'ZRX/CAD', 'UNI/AUD', 'UNI/JPY', 'XEM/EUR', 'XLM/CHF', 'LUNA2/USD', 'EOS/CAD', 'ETH/SGD', 'BAL/USD', 'ETHW/AUD', 'GBP/SEK', 'BTC/BNB', 'YFII/USD', 'BTC/MATIC', 'DAI/JPY', 'ZIL/USD', 'ADA/NZD', 'JPY/XRP', 'XLM/NZD', 'CHF/NOK', 'USD/USDT', 'BSV/JPY', 'AXS/DAI', 'USD/USDC', 'BAL/CAD', 'ENJ/USDC', 'GLMR/CHF', 'NYC/USD', 'CBETH/USD', 'GBP/NOK', 'AVAX/CHF', 'NEAR/AUD', 'COMP/GBP', 'LINK/SGD', 'DAI/UST', 'SKL/CAD', 'DAI/CAD', 'XCN/USD', 'COMP/ETH', 'REN/CAD', 'GBP/CHF', 'USD/THB', 'UST/USDC', 'SNX/USD', 'EOS/NZD',
'XMR/BCH', 'ADA/SGD', 'HKC/USD', 'ENJ/JPY', 'BTC/SOL', 'OP/CAD', 'SOL/JPY', 'LINK/ZAR', 'HOT/CAD', 'GLMR/AUD', 'BNT/CAD', 'BTC/CNH', 'XEM/JPY', 'SOL/SGD', 'COMP/CHF', 'USDT/MXN', 'BTC/CAD', 'UNI/GBP', 'XMR/CHF', 'DOT/NZD', 'KSM/AUD', 'TRX/JPY', 'USD/CNH', 'COMP/EUR', 'LUNA/AUD', 'LUNA/CAD', 'OMG/GBP', 'BTC/MXN', 'NZD/ZAR', 'USDC/CRV', 'BTC/UNI', 'PAX/CAD', 'ATOM/CHF', 'WBTC/USD', 'LRC/EUR', 'MIM/USD', 'AAVE/COMP', 'USDT/JPY', 'DAI/ETH', 'XTZ/EUR', 'SUSHI/CAD', 'MATIC/TRX', 'JPY/USDT', 'AVAX/JPY', 'BSV/USD', 'KSM/EUR', 'AVAX/GBP', 'ALGO/EUR', 'GBP/ZAR', 'DAI/CHF', 'SOL/CAD', 'ICP/CHF', 'SUSHI/EUR', 'TRX/AUD', 'GBP/PLN', 'XMR/JPY', 'AMP/CAD', 'ASTR/USD',
'BNB/SGD', 'USD/HUF', 'CRO/USD', 'DASH/USD', 'GRT/CAD', 'RNDR/USD', 'REN/USDC', 'QTUM/USDC', 'EOS/SGD', 'ZEC/XMR', 'SAND/CAD', 'ARB/CAD', 'DYDX/EUR', 'BTC/LINK', 'XLM/GBP', 'GBP/HUF', 'ATOM/GBP', 'ATOM/AUD', 'HNT/USD', 'APE/DAI', 'UNI/AAVE', 'XRP/ZAR', 'EUR/ZAR', 'GLMR/JPY', 'USDK/USDT', 'KSM/JPY', 'BCH/SGD', 'GLMR/GBP', 'CUSD/USD', 'LUNA2/CAD', 'QTUM/USD', 'DOGE/JPY', 'LUNA/JPY', 'BTC/CHF', 'XLM/JPY', 'AVAX/SGD', 'ADA/ZAR', 'ETC/GBP', 'USDC/AUD', 'JPY/BTC', 'GBP/CZK', 'PAXG/CAD', 'LDO/USD', 'EOS/CHF', 'DOT/SGD', 'NEAR/CHF', 'GALA/USD', 'NEAR/CAD', 'MASK/USD', 'ZEC/EOS', 'XRP/CAD', 'IOTA/EUR', 'ADA/JPY', 'AMP/USD', 'USDT/BUSD', 'DASH/CAD',
'LRC/CAD', 'AUD/NZD', 'CHR/USD', 'USD/DKK', 'USDC/DAI', 'UNI/CHF', 'MATIC/CAD', 'ETH/ADA', 'BTC/COMP', 'OMG/JPY', 'ETH/CRV', 'BAT/CAD', 'ETH/NZD', 'GBP/AUD', 'MATIC/SGD', 'BNB/CAD', 'AUD/EUR', 'DAI/GBP', 'STETH/USD', 'DOGE/SGD', 'XEM/USD', 'ETH/CHF', 'STORJ/USD', 'NEO/USD', 'BTC/BCH', 'BTC/ATOM', 'BTC/SGD', 'GBP/MXN', 'ALGO/CAD', 'CELO/CAD', 'VET/USD', 'USDC/ETH', 'USD/PLN', 'EGLD/CAD', 'CTSI/CAD', 'XRP/JPY', 'IOTX/USD', 'USTC/USD', 'COMP/CAD', 'GBP/CAD', 'LINK/MXN', 'EUR/RUB', 'BNB/TRX', 'CRV/EUR', 'ETC/BCH', 'XRP/DOGE', 'DOGE/BNB', 'TULIP/USD', 'BAT/EUR', 'ONE/USD', 'OXT/USDC', 'ETHW/CHF', 'XTZ/AUD', 'XMR/EOS', 'USD/SGD', 'FTM/CAD', 'ETHW/GBP',
'PAX/USD', 'KSM/NZD', 'CAD/ZAR', 'VET/CAD', 'ADA/CHF', 'LTC/AUD', 'NEAR/GBP', 'CHF/SEK', 'XTZ/CAD', 'USDT/ETH', 'KSM/GBP', 'XRP/CHF', 'BCH/CAD', 'LTC/JPY', 'ENJ/CAD', 'EOS/MXN', 'CTSI/USD', 'UMA/CAD', 'ETH/JPY', 'MATIC/NZD', 'USDC/ZAR', 'BNT/USD', 'USDC/GBP', 'ANC/USD', 'BCH/GBP', 'BRWL/USD', 'BNB/JPY', 'AXS/CAD', 'AXS/EUR', 'BCH/MXN', 'LINK/CHF', 'DOT/CHF', 'CELO/NEAR', 'UST/CAD', 'XRP/TRX', 'AUD/HKD', 'COMP/SGD', 'MANA/CAD', 'ICP/USD', 'BCH/NZD', 'KSM/USD', 'TRX/CAD', 'GLMR/SGD', 'ETH/TRX', 'DOGE/CAD', 'BUSD/ETH', 'ZEC/JPY', 'DOT/CAD', 'BUSD/CAD', 'LINK/DAI', 'AAVE/AUD', 'GLMR/USD', 'XLM/MXN', 'EOS/AUD', 'KNC/CAD', 'SPELL/USD', 'BUSD/USD', 'SRM/CAD',
'EUR/HUF', 'PAXG/EUR', 'ATOM1/USD1', 'XTZ/TRX', 'DOGE/SHIB', 'ZEC/BCH', 'BTC/UST', 'DOGE/XRP', 'ATOM/SGD', 'GLMR/CAD', 'LUNA/GBP', 'BSV/EUR', 'AR/USD', 'AMP/USDC', 'USDC/CHF', 'MASK/CAD', 'AAVE/GBP', 'LTC/CHF', 'USD/SEK', 'XLM/AUD', 'XRP/BCH', 'XMR/GBP', 'KSM/CHF', 'AVAX/NZD', 'USDT/NZD', 'ZAR/JPY', 'TRX/CHF', 'XTZ/GBP', 'CHF/ZAR', 'XTZ/CHF', 'XMR/SGD', 'TRX/GBP', 'DAI/AUD', 'RNDR/CAD', 'XLM/SGD', 'ETHW/USD', 'USDC/CAD', 'LINK/NZD', 'XMR/CAD', 'LUNA/UST', 'WAXP/USD', 'MANA/EUR', 'AAVE/CAD', 'HASH/USD', 'ONE/CAD', 'DOGE/CHF', 'SKL/USD', 'KDA/USD', 'XRP/NZD', 'BTC/JPY', 'BTC/XMR', 'USDC/BTC', 'LRC/JPY', 'LUNA/USD', 'LTC/MXN', 'XLM/BCH', 'USD/AUD',
'SNX/CAD', 'TUSD/USD', 'MATIC/CHF', 'EOS/BCH', 'AUD/JPY', 'USD/RUB', 'BCH/CHF', 'USD/ZAR', 'BCH/AUD', 'SCRT/USD', 'XTZ/SGD', 'OMG/EUR', 'KSM/CAD', 'SLP/USD', 'BCH/JPY', 'ZEC/CAD', 'AAVE/EUR', 'COMP/AUD', 'ETC/JPY', '1INCH/CAD', 'ETH/CAD', 'ETC/CAD', 'ZEC/GBP', 'ZEN/USD', 'BTC/ETH', 'ALGO/JPY', 'ETHW/BUSD', 'BSV/CAD', 'LTC/XMR', 'LUNA/CHF', 'VET/USDC', 'BTC/LTC', 'BCH/ETH', 'COMP/BNB', 'LINK/TRX', 'ETH/DOT', 'USDT/SGD', 'ENS/CAD', 'HBAR/JPY', 'ICP/JPY', 'XRP/EOS', 'NZD/USD', 'ZEC/USD', 'BUSD/EUR', 'ALICE/USD', 'ATLAS/USD', 'OXT/CAD', 'DYDX/CAD', 'ETH/UST', 'ETHW/SGD', 'ETH/MXN', 'LINK/JPY', 'EUR/MXN', 'EOS/GBP', 'LUNA/SGD', 'ZEC/LTC', 'LINK/CAD', 'EUR/AUD', 'POKT/USD']
no_price = []
# prod
TALOS_URL = "tal-90.prod.talostrading.com" 
TALOS_API_KEY="ZERMLOIKK49R"
TALOS_API_SECRET="r2jfbtokkhl44fzqqckyf94npnved2ba"


def get_data():
    response = EMSSymbols.select(EMSSymbols.min_qty, EMSSymbols.source, EMSSymbols.ticker
                                 ).where(EMSSymbols.supplier=='talos', EMSSymbols.ticker.in_(ticker_list))
    result = {}
    if response:
        for each_response in response:
            
            ticker = each_response.ticker
            data = result.get(ticker)
            if not data:
                result[ticker] = {
                    "min_qty": float(each_response.min_qty) * 10,
                    "source_list": [each_response.source]
                }
            else:
                data["source_list"].append(each_response.source)
    return result


def build_headers(path, query="", body="", method="GET", utc_datetime=None):
    if not utc_datetime:
        utc_now = datetime.now(timezone.utc)
        utc_datetime = utc_now.strftime("%Y-%m-%dT%H:%M:%S.000000Z")

    params = [
        method,
        utc_datetime,
        TALOS_URL,
        path,
    ]
    if query:
        params.append(query)
    if body:
        params.append(body)

    payload = "\n".join(params)
    hashvalue = hmac.new(TALOS_API_SECRET.encode('ascii'), payload.encode('ascii'), hashlib.sha256)
    hashvalue.hexdigest()
    signature = base64.urlsafe_b64encode(hashvalue.digest()).decode()
    return {
        "TALOS-KEY": TALOS_API_KEY,
        "TALOS-SIGN": signature,
        "TALOS-TS": utc_datetime,
    }


# 询价
def get_quote(symbol, side, amount, markets):
    utc_now = datetime.now(timezone.utc)
    utc_datetime = utc_now.strftime("%Y-%m-%dT%H:%M:%S.000000Z")
    data = {
        "Symbol": '-'.join(symbol.upper().split('/')),
        "Currency": symbol.upper().split('/')[0],
        "Side": side,
        "QuoteReqID": str(uuid.uuid1()),
        "OrderQty": amount,
        "Markets": markets,
        "TransactTime": utc_datetime
    }
    url = f"https://{TALOS_URL}/v1/quotes?wait-for-status=confirmed&timeout=5s"
    headers = build_headers("/v1/quotes", "wait-for-status=confirmed&timeout=5s", json.dumps(data) if data else "{}", method='POST', utc_datetime=utc_datetime)
    response = requests.post(url=url, headers=headers, json=data)
    text = response.text
    print(text)
    if response.status_code == 200:
        pass
    elif "Insufficient credit" in text:
        pass
    else:
        no_price.append({"symbol": text})

def main():
    data = get_data()
    for k, v in data.items():
        try:
            get_quote(k, 'buy', v['min_qty'], v['source_list'])
        except:
            no_price.append(k)
        time.sleep(10)

main()
logger.info(no_price)
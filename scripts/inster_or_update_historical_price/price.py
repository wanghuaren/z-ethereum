import sys
import pathlib
sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))

import time
from datetime import datetime

from db.models import EMSSymbols
from scripts.inster_or_update_historical_price.common import get_history_prices, get_close_prices, inster_or_update_price


def inster_or_update(market, symbol, start_day):
    start_time = datetime.strptime(start_day, '%Y-%m-%d')
    now = datetime.now()
    end_day = now.date().strftime('%Y-%m-%d')

    start_time = datetime.strptime(start_day, '%Y-%m-%d')
    start_time = int(start_time.timestamp() * 1000)

    # 获取价格
    print(symbol, "////")
    prices = get_close_prices(market, symbol, start_time)

    # 从数据库中获取 USDT/USD 的价格
    history_rates = get_history_prices('b2c2', 'USDT', 'USD', start_day, end_day)

    new_price = {}
    for k, v in prices.items():
        rate = history_rates.get(k)
        if not rate:
            continue

        new_price[k] = v * rate

    # 写入/更新
    base = symbol.split('/')[0]
    inster_or_update_price(new_price, market, base, 'USD', start_day, end_day)


def get_symbols():
    assets = ['ARRR', 'AIOZ', 'REF', 'ZKP', 'LDO', 'THETA', 'AR', 'FLM', 'ONE', 'VRA', 'TOWN', 'BCAU', 'TORN', 'EDG', 'RPG', 'EWT', 'RVN', 'BLOK']
    return EMSSymbols.select(EMSSymbols.base_asset_id, EMSSymbols.source).where(EMSSymbols.supplier == 'ccxt', 
                                                                         EMSSymbols.status == 'active',
                                                                         EMSSymbols.quote_asset_id == 'USDT',
                                                                         EMSSymbols.base_asset_id.in_(assets)).order_by(EMSSymbols.base_asset_id)
    


def bulk_update():
    start_day = '2020-01-01'

    symbols = get_symbols()
    for s in symbols:
        # if f"{s.base_asset_id}/USDT" not in ('LDO/USDT', 'BLOK/USDT', 'AR/USDT', 'RVN/USDT', 'EWT/USDT', 'ARRR/USDT', 'VRA/USDT', 'THETA/USDT', 'FLM/USDT', 'REF/USDT'):
        #     continue

        # [{'market': 'kucoin', 'symbol': 'AR/USDT'}, {'market': 'gate', 'symbol': 'AR/USDT'}, {'market': 'kucoin', 'symbol': 'ARRR/USDT'}, 
        #  {'market': 'gate', 'symbol': 'BLOK/USDT'}, {'market': 'kucoin', 'symbol': 'BLOK/USDT'}, {'market': 'gate', 'symbol': 'EWT/USDT'},
        #  {'market': 'kucoin', 'symbol': 'EWT/USDT'}, {'market': 'gate', 'symbol': 'FLM/USDT'}, {'market': 'gate', 'symbol': 'LDO/USDT'}, 
        #  {'market': 'kucoin', 'symbol': 'LDO/USDT'}, {'market': 'gate', 'symbol': 'REF/USDT'}, {'market': 'gate', 'symbol': 'RVN/USDT'},
        #  {'market': 'kucoin', 'symbol': 'RVN/USDT'}, ]

        print({"market": s.source, "symbol": f"{s.base_asset_id}/USDT"})
        inster_or_update(s.source, f"{s.base_asset_id}/USDT", start_day)
        time.sleep(5)
        
        



if __name__ == '__main__':    
    bulk_update()
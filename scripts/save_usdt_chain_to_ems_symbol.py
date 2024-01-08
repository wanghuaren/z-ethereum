import datetime
import time
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

from db.models import db, EMSSymbols


def main():
    """
    将USDT相关的asset,两两组合,最后加上AAA-AAA;
    构造插入ems_symbol表的数据
    更新ems_symbol表中
    """
    USDT_LIST = ["USDT_ERC20", "USDT_TRC20", "USDT_BSC", "USDT_AVAX"]
    symbols = [f"{i}/{j}" for i in USDT_LIST for j in USDT_LIST if i != j]
    symbols.append("AAA/AAA")

    new_insert_ems_symbols_data = []
    for symbol in symbols:
        # 组装单条 symbols 数据
        timestamp = int(time.time() * 1000)
        single_symbol_data = {
                'base_asset_id': symbol.split('/')[0],
                'quote_asset_id': symbol.split('/')[1],
                'ticker': symbol,
                'px_sig': 2,
                'qty_sig': 2,
                'max_qty': '1000000',
                'min_qty': '0',
                'is_quote': False,
                'source': 'custom',
                'supplier': 'custom',
                'status': 'active',
                'note': '',
                'created_at': timestamp,  # 新增数据的 created_at 为当前时间
                'last_updated': timestamp,
                'security_id': '',
                'last_quote_time': datetime.date.today()
            }
        if symbol == 'AAA/AAA':
            single_symbol_data['base_asset_id'] = 'AAA'
            single_symbol_data['quote_asset_id'] = 'AAA'
            single_symbol_data['ticker'] = 'AAA/AAA'
        new_insert_ems_symbols_data.append(single_symbol_data)

    with db.atomic():
        EMSSymbols.insert_many(new_insert_ems_symbols_data).execute()


if __name__ == '__main__':
    main()


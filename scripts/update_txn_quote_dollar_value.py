import sys
import pandas as pd
import numpy as np
import traceback
import time
import decimal
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

from db.models import db, Transactions
from utils.consts import USDT_LIS
from internal.risk.data_helper import get_historical_prices_df
from utils.logger import logger



class TxnQuoteDollarValueUpdate:
    def __init__(self):
        pass

    def run(self):
        with db.atomic():
            try:
                logger.info("脚本开始运行")
                # 获取币种，创建日期， quote_quantity, id等结果数据
                symbol_date_list, df = self.get_data()
                # 获取币种，日期 对应的汇率，调用zmd接口
                history_price_result = self.get_history_price(symbol_date_list)
                # 根据币种，日期，数据进行整合，计算quote_dollar_value数据
                df_txn = pd.merge(
                    df,
                    history_price_result[['date', 'price', 'base_asset']],
                    how='left',
                    left_on=['created_date', 'quote_asset'],
                    right_on=['date', 'base_asset']
                )
                df_txn['price'] = df_txn['price'].fillna(decimal.Decimal('0'))
                df_txn.loc[df_txn['quote_asset'] == 'USD', "price"] = decimal.Decimal('1')
                df_txn['quote_dollar_value'] = df_txn['quote_quantity'] * df_txn['price']

                filter_data = df_txn.loc[df_txn.price == 0]
                filter_data['created_date'] = filter_data['created_date'].dt.strftime('%Y-%m-%d')
                # 获取price = 0的数据，进行预警
                error_group_result = filter_data.groupby('quote_asset')
                error_symbol_date_list = []
                for name, group in error_group_result:
                    created_date_list = list(set(group['created_date'].values))
                    created_date_list.sort()
                    error_symbol_date_list.append({
                        'quote_asset': name,
                        'created_date_list': created_date_list
                    })

                if error_symbol_date_list:
                    logger.info(f"异常没有获取到价格的数据： {error_symbol_date_list}")

                # 计算结束后，按id进行更新
                handle_data_df = df_txn.loc[df_txn.price > 0]
                handle_data_array = np.array(handle_data_df)
                update_data_list = []
                for handle_data in handle_data_array:
                    update_data_list.append({
                        "id": handle_data[0],
                        "quote_dollar_value": str(handle_data[5]),
                        "quote_asset": handle_data[1],
                        "created_at": handle_data[3]
                    })

                # logger.info(f"update_data_list： {update_data_list}")

                # 数据更新
                for update_dict in update_data_list:
                    self.update_transaction(update_dict)

                logger.info("脚本运行结束")
            except:
                logger.error("脚本运行异常")
                logger.error(f"异常： {traceback.format_exc()}")

    def get_data(self):
        txn_data_result = self.get_txn_result()
        df = pd.DataFrame(txn_data_result, columns=['id', 'quote_asset', 'quote_quantity', 'created_at', 'created_date', 'quote_dollar_value'])
        df.loc[df['quote_asset'].isin(USDT_LIS), "quote_asset"] = "USDT"
        group_result = df.groupby('quote_asset')
        symbol_date_list = []
        for name, group in group_result:
            created_date_list = list(set(group['created_date'].values))
            created_date_list.sort()
            symbol_date_list.append({
                'quote_asset':name,
                'created_date_list': created_date_list
            })
        df['created_date'] = pd.to_datetime(df['created_date'])
        df['quote_quantity'] = df['quote_quantity'].fillna('0')
        df['quote_quantity'] = list(map(decimal.Decimal, map(str, df['quote_quantity'].to_list())))
        df = df[[
            'id', 'quote_asset', 'quote_quantity', 'created_at', 'created_date', 'quote_dollar_value'
        ]]
        return symbol_date_list, df

    def get_txn_result(self):
        res = Transactions.select(Transactions.id, Transactions.quote_asset, Transactions.quote_quantity,
                                  Transactions.created_at, Transactions.quote_dollar_value).\
            where((Transactions.quote_dollar_value == None) &
                  ((Transactions.base_asset != 'AAA') | (Transactions.quote_asset != 'AAA'))).\
            order_by(Transactions.quote_asset, Transactions.created_at)
        result = []
        for i in res:
            result.append({
                "id": i.id,
                "quote_asset": i.quote_asset,
                "quote_quantity": i.quote_quantity,
                "created_at": i.created_at,
                "created_date": time.strftime("%Y-%m-%d", time.localtime(int(i.created_at)/1000)),
                "quote_dollar_value": i.quote_dollar_value
            })
        return result

    def get_history_price(self, symbol_data_list):
        ticker_time_list = []
        for symbol_data in symbol_data_list:
            ticker_time_list.append({
                'base_asset': symbol_data['quote_asset'],
                'quote_asset': 'USD',
                'time_range': symbol_data['created_date_list']
            })
        historical_prices = get_historical_prices_df(ticker_time_list)
        return historical_prices

    def update_transaction(self, update_dict):
        Transactions.update(update_dict).where(Transactions.id == update_dict['id']).execute()


if __name__ == '__main__':
    txn_quote_dollar_vaule_update = TxnQuoteDollarValueUpdate()
    txn_quote_dollar_vaule_update.run()

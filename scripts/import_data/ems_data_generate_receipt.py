import os
from decimal import Decimal
import pandas as pd
import grpc
import sys

sys.path.append('../../')
import zerocap_market_data_pb2_grpc
import zerocap_market_data_pb2
from internal.users.data_helper import get_transactions, check_repeat_exists, update_transaction_created_at

channel = grpc.insecure_channel(os.environ['ZEROCAP_MONITOR_GRPC_ZMD'])

stub = zerocap_market_data_pb2_grpc.ZerocapMarketDataStub(channel)


class FileReader:
    def read_data(self):
        pass


class DataFrameReader(FileReader):
    def __init__(self, path, sheet, cols):
        self.path = path
        self.sheet = sheet
        self.cols = cols

    def read_data(self):
        if not os.path.exists(self.path):
            print('File does not exist')
            return []
        try:
            df = pd.read_excel(self.path, sheet_name=self.sheet)
            data_list = df[self.cols].values
            return data_list
        except Exception as e:
            print(e)
        return []


def ems_data_generate_receipt(files, Sheet, column):
    df1 = DataFrameReader(files, Sheet, column)
    fail_txn = []
    success_txn = []
    for data in df1.read_data():

        res = get_transactions(data)
        # transactions查不到数据，跳过
        if not res:
            continue
        # status状态为deleted，跳过
        if res.status == 'deleted':
            continue

        # 查询是否有同一天内同一用户的 created_at 重复的数据
        is_exist = check_repeat_exists(res)
        if is_exist:
            res = update_transaction_created_at(res)
        # 失败尝试三次
        receipt_status = ''
        if res.fee_notional == 'base':
            fees = f"{res.fee} {res.base_asset}"
        elif res.fee_notional == 'quote':
            fees = f"{res.fee} {res.quote_asset}"
        elif res.fee_notional == 'bps':
            fees = f"{(Decimal(res.fee)/100).quantize(Decimal('0.00'))} %"
        else:
            print(f'{res.txn_alias} Fee notional wrong')
            continue
        for _ in range(3):
            request = zerocap_market_data_pb2.GenTradeReceiptRequestV1(
                txn_alias=res.txn_alias,
                user_id=res.user_id,
                trader_identifier=res.trader_identifier,
                base_asset=res.base_asset,
                quote_asset=res.quote_asset,
                created_at=int(res.created_at),
                side=res.side,
                quantity=res.quantity,
                price=res.quote_price,
                quote_quantity=res.quote_quantity,
                fees=fees,
                total=res.total,
                entity=res.entity,
                hedge=res.hedge,
                order_type="Market",
                fee_notional=res.fee_notional,
                account_id=res.account_id,
                # fee_type=res.fee_type,
                is_history_data=True
            )
            response = stub.GenTradeReceipt(request)
            receipt_status = response.status
            if receipt_status == 'success':
                success_txn.append(data)
                break
        if receipt_status == 'failed':
            fail_txn.append(data)
    return success_txn, fail_txn


if __name__ == '__main__':
    files = '/home/ubuntu/prod/zerocap_otc/scripts/import_data/import_ems_transactions_20230421.xlsx'
    Sheet = 'Sheet1'
    column = 'txn_alias'
    response = ems_data_generate_receipt(files, Sheet, column)
    # success_txn, fail_txn = ems_data_generate_receipt(r'C:\Users\麻永\Desktop\import_ems_data_20221031.xlsx', 'Sheet1', 'txn_alias')
    if response:
        print('success_txn', response[0])
        print('fail_txn', response[1])

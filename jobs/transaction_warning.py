import traceback
from peewee import fn

from db.models import Transactions, TxnDataSourceEnum
from utils.slack_utils import send_slack
from utils.logger import logger


class WarningTransaction:

    def run(self):
        try:
            logger.info("warning transaction 脚本开始运行")
            warning_transaction_data = self.get_warning_transaction_data()
            content = "transaction warning duplicate data: \n"
            if len(warning_transaction_data) >= 1:
                for index, data in enumerate(warning_transaction_data):
                    content += f"{index + 1}. \n"
                    warning_transaction_info_data = self.query_transaction_data_by_user_id_created_at(data['user_id'], data['created_at'])
                    for each_data in warning_transaction_info_data:
                        for key, value in each_data.items():
                            content += f"{key}={value} "
                        content += "\n \n"
                logger.info(content)
                send_slack(channel="SLACK_RISK_NOTIFICATIONS",
                           subject="TRANSACTION WARNING DATA",
                           content=content)
            logger.info("warning transaction 脚本运行结束")
        except Exception:
            logger.info("warning transaction 脚本运行异常")
            logger.exception(traceback.format_exc())
            send_slack(channel='SLACK_RISK_NOTIFICATIONS',
                       subject="transaction_warning failed",
                       content=f'traceback.format_exc():\n%s' % traceback.format_exc())

    def get_warning_transaction_data(self):
        response = Transactions.select(Transactions.user_id, Transactions.created_at,
                                       fn.string_agg(Transactions.status, '/').alias('all_status')).\
                                        where(Transactions.status != 'deleted', 
                                              Transactions.data_source != TxnDataSourceEnum.get_const_obj('manual')).\
                                                group_by(Transactions.user_id, Transactions.created_at).\
                                                    having(fn.Count(Transactions.id) > 1)
        result = []
        for i in response:
            result.append({
                "user_id": i.user_id,
                "created_at": i.created_at,
                "status": i.all_status.split('/')
            })
        return result

    def query_transaction_data_by_user_id_created_at(self, user_id, created_at):
        # 排除部分老数据
        txn_alias_list = ["b4bf8b13-b592-4dd5-8016-5a2295733600", "e1331335-4acf-4f9e-b786-1986b5d3ddb7",
        "2b58555e-ad63-4c1e-83d7-dfa6fe02c5ab", "c2c84154-fa8d-4653-b641-b910b1d43a41"]
        response = Transactions.select().where((Transactions.status != 'deleted') & (Transactions.user_id == user_id)
                                               & (Transactions.created_at == created_at) 
                                               & (Transactions.txn_alias.not_in(txn_alias_list)))
        result = []
        for i in response:
            result.append({
                'txn_alias': i.txn_alias,
                'base_asset': i.base_asset,
                'quote_asset': i.quote_asset,
                'side': i.side,
                'quantity': i.quantity,
                'quote_quantity': i.quote_quantity,
                'total': i.total,
                'filled_quantity': i.filled_quantity,
                'user_id': i.user_id,
                'raw_price': i.raw_price,
                'quote_price': i.quote_price,
                'exec_price': i.exec_price,
                'markup': i.markup,
                'fee': i.fee,
                'pnl': i.pnl,
                'created_at': i.created_at,
                'updated_at': i.updated_at,
                'status': i.status,
                'filled_quote_quantity': i.filled_quote_quantity,
                'trader_identifier': i.trader_identifier,
                'markup_type': i.markup_type,
                'fee_type': i.fee_type,
                'memo': i.memo,
                'entity': i.entity,
                'add_date': i.add_date,
                'receipt_sent': i.receipt_sent,
                'dealers': i.dealers,
                'hedge': i.hedge,
                'fee_notional': i.fee_notional,
            })
        return result


if __name__ == '__main__':
    warning_transaction = WarningTransaction()
    warning_transaction.run()

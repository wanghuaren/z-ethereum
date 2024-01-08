import grpc

from utils.slack_utils import send_slack
from utils.zc_exception import ZCException
from utils.report_client import report_client


class ErrorManager(object):

    def __init__(self, context):
        self.logger = context.logger
        self.request_attributes = [
            'user_id', 'tenant', 'asset_id', 'address', 'tag', 'customer_ref_id',
            'limit', 'page', 'term', 'yield_id', 'type', 'side', 'amount', 'vault_id',
            'external_wallet_id', 'values', 'account_id', 'dealers', 'symbol']

    def grpc_exception_handling(self, context, name, e, request):
        try:
            warn_msg = f"{e.__str__()}" if (isinstance(e, ZCException)) else ""

            value_dic = self.parse_request(request)
            self.logger.exception(f"{name} failed e={repr(e.__str__())} values={value_dic}")
            context.set_code(grpc.StatusCode.ABORTED)
            context.set_details(f"{name} failed {repr(e.__str__())}")

            try:
                report_client.report_for_monitor(
                    name=name, status=1 if warn_msg == '' else 2, info=repr(e.__str__()), channel=1)
            except Exception as e:
                self.logger.exception(f"monitor report error:{e}")

            send_slack(
                channel='SLACK_API_OPS',
                subject=f"{name} {'failed' if warn_msg == '' else 'warning'}",
                content=f"{warn_msg}\r" + f"\n".join("{!r}: {!r},".format(k, v) for k, v in value_dic.items()))
        except Exception as e:
            self.logger.exception(e)

    def parse_request(self, request):
        value_dic = {}
        for i in self.request_attributes:
            if hasattr(request, i):
                value_dic[i] = getattr(request, i)

        return value_dic

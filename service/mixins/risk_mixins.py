import otc_pb2
from internal.common.error_manager import ErrorManager
from internal.risk.risk import get_risk, get_k_line, get_price_admin, update_price_admin
from internal.users.user_manager import inster_or_update_risk_limit, trader_list
from utils.consts import ResponseStatusFailed
from utils.log_utils import LogDecorator


class RiskMixins:
    def __init__(self):
        self.error_manager = ErrorManager(self)

    @LogDecorator()
    def GetRisk(self, request, context):
        try:
            return otc_pb2.GetRiskResponseV1(**get_risk(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetRisk', e, request)
            return otc_pb2.GetRiskResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def InsterOrUpdateRiskLimit(self, request, context):
        try:
            return otc_pb2.InsterOrUpdateRiskLimitResponseV1(**inster_or_update_risk_limit(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'InsterOrUpdateRiskLimit', e, request)
            return otc_pb2.InsterOrUpdateRiskLimitResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def TraderList(self, request, context):
        try:
            return otc_pb2.TraderListResponseV1(**trader_list(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'TraderList', e, request)
            return otc_pb2.TraderListResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def GetKLine(self, request, context):
        try:
            return otc_pb2.GetKLineResponseV1(**get_k_line(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetKLine', e, request)
            return otc_pb2.GetKLineResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def GetPriceAdmin(self, request, context):
        try:
            return otc_pb2.GetPriceAdminResponseV1(**get_price_admin(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetPriceAdmin', e, request)
            return otc_pb2.GetPriceAdminResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def UpdatePriceAdmin(self, request, context):
        try:
            return otc_pb2.UpdatePriceAdminResponseV1(**update_price_admin(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'UpdatePriceAdmin', e, request)
            return otc_pb2.UpdatePriceAdminResponseV1(status=ResponseStatusFailed)

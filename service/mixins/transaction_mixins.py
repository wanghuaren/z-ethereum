import otc_pb2
from db.base_models import db
from internal.common.error_manager import ErrorManager
from internal.health_check.health_check import health_check
from internal.transaction.transaction import create_ems_transaction, check_to_portal, edit_treasury, add_treasury, \
    get_treasury_list, get_transaction_from_chain, add_settle, settle_check, get_ems_transfer, reject_ems_transfer, \
    ems_transfer_resend, blotter, update_aaa_symbol
from otc_pb2 import CheckToPortalResponseV1, CreateEMSTransactionResponseV1, AddSettleResponseV1
from utils.consts import ResponseStatusFailed
from utils.log_utils import LogDecorator


class TransactionMixins:
    def __init__(self):
        self.error_manager = ErrorManager(self)

    @LogDecorator()
    def CheckToPortal(self, request, context):
        """
        :param request:
        :param context:
        :return:
        """
        try:
            with db.atomic():
                return CheckToPortalResponseV1(**check_to_portal(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'CheckToPortal', e, request)
            return CheckToPortalResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def CreateEMSTransaction(self, request, context):
        """
        :param request:
        :param context:
        :return:
        """
        try:
            with db.atomic():
                return CreateEMSTransactionResponseV1(**create_ems_transaction(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'CreateEMSTransaction', e, request)
            return CreateEMSTransactionResponseV1(status=ResponseStatusFailed)

    def OTCCheckHealth(self, request, context):
        try:
            return otc_pb2.OTCCheckHealthResponseV1(result=health_check(request.tasks))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'OTCCheckHealth', e, request)
            return otc_pb2.OTCCheckHealthResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def AddTreasury(self, request, context):
        try:
            return otc_pb2.AddTreasuryResponseV1(**add_treasury(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'AddTreasury', e, request)
            return otc_pb2.AddTreasuryResponseV1(status=ResponseStatusFailed, message=str(e), treasury={})

    @LogDecorator()
    def EditTreasury(self, request, context):
        try:
            return otc_pb2.EditTreasuryResponseV1(**edit_treasury(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'EditTreasury', e, request)
            return otc_pb2.EditTreasuryResponseV1(status=ResponseStatusFailed, message=str(e), treasury={})

    @LogDecorator()
    def GetTreasuryList(self, request, context):
        try:
            return otc_pb2.GetTreasuryListResponseV1(**get_treasury_list(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetTreasury', e, request)
            return otc_pb2.GetTreasuryListResponseV1(status=ResponseStatusFailed, message=str(e), treasury={}, total=0)

    @LogDecorator()
    def GetTransactionFromChain(self, request, context):
        try:
            return otc_pb2.GetTransactionFromChainResponseV1(**get_transaction_from_chain(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetTransactionFromChain', e, request)
            return otc_pb2.GetTransactionFromChainResponseV1(status=ResponseStatusFailed, message=str(e), treasury={}, total=0)

    @LogDecorator()
    def AddPayment(self, request, context):
        try:
            return AddSettleResponseV1(**add_settle(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'AddPayment', e, request)
            return AddSettleResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def AddSettlement(self, request, context):
        try:
            return AddSettleResponseV1(**add_settle(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'AddSettlement', e, request)
            return AddSettleResponseV1(status=ResponseStatusFailed)

    def SettleCheck(self, request, context):
        try:
            return otc_pb2.SettleCheckResponseV1(**settle_check(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'SettleCheck', e, request)
            return otc_pb2.SettleCheckResponseV1(status=ResponseStatusFailed)

    def GetEMSTransfer(self, request, context):
        try:
            return otc_pb2.GetEMSTransferResponseV1(**get_ems_transfer(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetEMSTransfer', e, request)
            return otc_pb2.GetEMSTransferResponseV1(status=ResponseStatusFailed)

    def RejectEMSTransfer(self, request, context):
        try:
            with db.atomic():
                return otc_pb2.RejectEMSTransferResponseV1(**reject_ems_transfer(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'RejectEMSTransfer', e, request)
            return otc_pb2.RejectEMSTransferResponseV1(status=ResponseStatusFailed)

    def EMSTransferResend(self, request, context):
        try:
            return otc_pb2.EMSTransferResendResponseV1(**ems_transfer_resend(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'EMSTransferResend', e, request)
            return otc_pb2.EMSTransferResendResponseV1(status=ResponseStatusFailed)

    def Blotter(self, request, context):
        try:
            return otc_pb2.BlotterResponseV1(**blotter(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'Blotter', e, request)
            return otc_pb2.BlotterResponseV1(status=ResponseStatusFailed)

    def UpdateAAASymbol(self, request, context):
        try:
            return otc_pb2.UpdateAAASymbolResponseV1(**update_aaa_symbol(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'UpdateAAASymbol', e, request)
            return otc_pb2.UpdateAAASymbolResponseV1(status=ResponseStatusFailed)
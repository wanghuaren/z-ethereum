import otc_pb2
from internal.common.error_manager import ErrorManager
from utils.consts import ResponseStatusFailed
from utils.log_utils import LogDecorator
from internal.rfq.rfq import edit_rfq_quote, lp_warning, get_orders, send_limit_quote_fill, send_limit_quote_cancel, \
    lp_list, get_customer_info_from_crm, get_symbols, get_users_id_by_ems, get_trader_info, \
    get_user_accounts_info_by_ems, get_quote, get_symbol_price, quote_calculator, get_account_transaction_flow, \
    get_crm_notes_by_account, update_market_config, add_crm_note , fetch_quote, get_batch_bid_ask, get_credit_lines, get_lp_balances
from db.models import db

class RfqMixins:
    """
    ems rfq页面相关新增接口视图类
    """
    def __init__(self):
        self.error_manager = ErrorManager(self)

    def EditRFQQuote(self, request, context):
        try:
            return otc_pb2.EditRFQQuoteResponseV1(**edit_rfq_quote(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'EditRFQQuote', e, request)
            return otc_pb2.EditRFQQuoteResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def GetLPWarning(self, request, context):
        try:
            return otc_pb2.GetLPWarningResponseV1(**lp_warning(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetLPWarning', e, request)
            return otc_pb2.GetLPWarningResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def GetLPList(self, request, context):
        try:
            return otc_pb2.GetLPListResponseV1(**lp_list(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetLPList', e, request)
            return otc_pb2.GetLPListResponseV1(status=ResponseStatusFailed)

    def GetOrders(self, request, context):
        try:
            return otc_pb2.GetOrdersResponseV1(**get_orders(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetOrders', e, request)
            return otc_pb2.GetOrdersResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def SendLimitQuoteFill(self, request, context):
        with db.atomic():
            try:
                return otc_pb2.SendLimitQuoteFillResponseV1(status=send_limit_quote_fill(request))
            except Exception as e:
                self.error_manager.grpc_exception_handling(context, 'SendLimitQuoteFill', e, request)
                return otc_pb2.SendLimitQuoteFillResponseV1(status=ResponseStatusFailed)

    @LogDecorator()
    def SendLimitQuoteCancel(self, request, context):
        with db.atomic():
            try:
                return otc_pb2.SendLimitQuoteCancelResponseV1(status=send_limit_quote_cancel(request))
            except Exception as e:
                self.error_manager.grpc_exception_handling(context, 'SendLimitQuoteCancel', e, request)
                return otc_pb2.SendLimitQuoteCancelResponseV1(status=ResponseStatusFailed)

    def GetCustomerInfoFromCRM(self, request, context):
        try:
            return otc_pb2.GetCustomerInfoFromCRMResponseV1(**get_customer_info_from_crm(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetCustomerInfoFromCRM', e, request)
            return otc_pb2.GetCustomerInfoFromCRMResponseV1(status=ResponseStatusFailed)

    def GetSymbols(self, request, context):
        try:
            return otc_pb2.GetSymbolsResponseV1(**get_symbols(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetSymbols', e, request)
            return otc_pb2.GetSymbolsResponseV1(status=ResponseStatusFailed)

    def GetUsersIdByEMS(self, request, context):
        try:
            return otc_pb2.GetUsersIdByEMSResponseV1(**get_users_id_by_ems(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, ':', e, request)
            return otc_pb2.GetUsersIdByEMSResponseV1(status=ResponseStatusFailed)

    def TraderInfo(self, request, context):
        try:
            response = get_trader_info(request)
            return response
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'TraderInfo', e, request)
            return otc_pb2.TraderInfoResponseV1(status=ResponseStatusFailed)

    def GetUserAccountsInfoByEMS(self, request, context):
        try:
            response = get_user_accounts_info_by_ems(request)
            return response
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetUserAccountsInfoByEMS', e, request)
            return otc_pb2.GetUserAccountsInfoByEMSResponseV1(status=ResponseStatusFailed)

    def GetQuote(self, request, context):
        try:
            return otc_pb2.GetQuoteOTCResponseV1(**get_quote(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetQuote', e, request)
            return otc_pb2.GetQuoteOTCResponseV1(status=ResponseStatusFailed)

    def GetSymbolPrice(self, request, context):
        try:
            return otc_pb2.GetSymbolPriceResponseV1(**get_symbol_price(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetSymbolPrice', e, request)
            return otc_pb2.GetSymbolPriceResponseV1(status=ResponseStatusFailed)

    def QuoteCalculator(self, request, context):
        try:
            return otc_pb2.QuoteCalculatorResponseV1(**quote_calculator(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'QuoteCalculator', e, request)
            return otc_pb2.QuoteCalculatorResponseV1(status=ResponseStatusFailed)

    def GetAccountTransactionFlow(self, request, context):
        try:
            return otc_pb2.GetAccountTransactionFlowResponseV1(**get_account_transaction_flow(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetAccountTransactionFlow', e, request)
            return otc_pb2.GetAccountTransactionFlowResponseV1(status=ResponseStatusFailed)

    def GetCrmNotesByAccount(self, request, context):
        try:
            return otc_pb2.GetCrmNotesByAccountResponseV1(**get_crm_notes_by_account(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetCrmNotesByAccount', e, request)
            return otc_pb2.GetCrmNotesByAccountResponseV1(status=ResponseStatusFailed)
        
    def AddCrmNote(self, request, context):
        try:
            return otc_pb2.AddCrmNoteResponseV1(**add_crm_note(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'AddCrmNote', e, request)
            return otc_pb2.AddCrmNoteResponseV1(status=ResponseStatusFailed)

    def UpdateMarketsConfig(self, request, context):
        with db.atomic():
            try:
                return otc_pb2.UpdateMarketsConfigResponseV1(**update_market_config(request))
            except Exception as e:
                self.error_manager.grpc_exception_handling(context, 'UpdateMarketsConfig', e, request)
                return otc_pb2.UpdateMarketsConfigResponseV1(status=ResponseStatusFailed)


    # omd 服务迁移过来的接口
    def FetchQuote(self, request, context):
        try:
            return otc_pb2.FetchQuoteResponseV1(**fetch_quote(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'FetchQuote', e, request)
            return otc_pb2.FetchQuoteResponseV1(status=ResponseStatusFailed)

    def GetBatchBidAsk(self, request, context):
        try:
            return otc_pb2.GetBatchBidAskResponseV1(**get_batch_bid_ask(request))
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetBatchBidAsk', e, request)
            return otc_pb2.GetBatchBidAskResponseV1(status=ResponseStatusFailed)

    def GetCreditLines(self, request, context):
        try:
            response = get_credit_lines(request)
            return response
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetCreditLines', e, request)
            return otc_pb2.GetCreditLinesResponseV1(status=ResponseStatusFailed)

    def GetLPBalances(self, request, context):
        try:
            response = get_lp_balances(request)
            return response
        except Exception as e:
            self.error_manager.grpc_exception_handling(context, 'GetLPBalances', e, request)
            return otc_pb2.GetLPBalancesResponseV1(status=ResponseStatusFailed)


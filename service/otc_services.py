import otc_pb2_grpc
from internal.common.error_manager import ErrorManager
from service.mixins.transaction_mixins import TransactionMixins
from service.mixins.risk_mixins import RiskMixins
from service.mixins.rfq_mixins import RfqMixins
from utils.logger import logger


class OtcService(TransactionMixins, RiskMixins, RfqMixins, otc_pb2_grpc.OtcServicer):

    def __init__(self):
        self.logger = logger
        self.error_manager = ErrorManager(self)

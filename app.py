import os
import faulthandler
from concurrent.futures import ThreadPoolExecutor

import grpc

import otc_pb2_grpc
from service.otc_services import OtcService
from utils.logger import logger
from utils.path_utils import PathConst
from utils.otc_interceptor import MyServerInterceptor


def serve():
    worker_num = 3 if os.environ.get('FIREBLOCKS_ENV', 'development') == "development" else 20
    my_interceptor = MyServerInterceptor()
    server = grpc.server(ThreadPoolExecutor(max_workers=worker_num), interceptors=[my_interceptor])
    otc_server = OtcService()
    otc_pb2_grpc.add_OtcServicer_to_server(otc_server, server)
    server.add_insecure_port('[::]:5011')
    server.start()
    logger.info("otc server started on [::]:5011")
    try:
        server.wait_for_termination()
    except KeyboardInterrupt:
        server.stop(0)


if __name__ == '__main__':
    with open(PathConst.OTC_LOCK, 'w') as f:
        faulthandler.enable(file=f, all_threads=True)
        serve()

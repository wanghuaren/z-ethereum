import os
import time
import uuid

import grpc

from typing import Any, Callable
from grpc_interceptor import ServerInterceptor
from grpc_interceptor.exceptions import GrpcException
from utils.logger import logger
from utils.slack_utils import send_slack

interceptor_no_return = ["GetSymbolsRequestV1", "GetUsersIdByEMSRequestV1"]


class MyServerInterceptor(ServerInterceptor):

    def __init__(self):
        self.logger = logger

    def intercept(
            self,
            method: Callable,
            request: Any,
            context: grpc.ServicerContext,
            method_name: str,
    ) -> Any:
        """
        :param method: Callable
        :param request: Any
        :param context: grpc.ServicerContext
        :param method_name: str
        :return:
        """

        response = None
        trace_id = uuid.uuid4().hex
        start_time = time.time()
        if hasattr(request, "trace_id"):
            setattr(request, "trace_id", trace_id)
        route_name = request.DESCRIPTOR.name if hasattr(request, "DESCRIPTOR") else ''
        try:
            self.logger.info({
                "type": "interceptor",
                "otc_grpc_interceptor_type": "request",
                "route": route_name,
                "trace_id": trace_id,
                "param": request
            })
            response = method(request, context)
        except GrpcException as e:
            self.logger.error(f'grpc_error: route {route_name} trace_id {trace_id} info {str(e)}', exc_info=True)
            raise e
        finally:
            env = os.environ.get('FIREBLOCKS_ENV')
            cost_time = "%2.4f sec" % (time.time() - start_time)
            if env == "development" and time.time() - start_time > 60:
                send_slack(channel='SLACK_API_OPS',
                           subject="request consumes too much time ",
                           content=f"route_name: {route_name}\ntrace_id: {trace_id}\ncost_time: {cost_time}\n")
            if route_name in interceptor_no_return:
                self.logger.info({
                    "type": "interceptor",
                    "otc_grpc_interceptor_type": "resp",
                    "cost_time": cost_time,
                    "route": route_name,
                    "trace_id": trace_id,
                })
            else:
                self.logger.info({
                    "type": "interceptor",
                    "otc_grpc_interceptor_type": "resp",
                    "cost_time": cost_time,
                    "route": route_name,
                    "trace_id": trace_id,
                    "data": response
                })
            return response

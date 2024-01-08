import grpc
import sys
import pathlib

sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))
import otc_pb2
import otc_pb2_grpc


def run():
    with grpc.insecure_channel('localhost:5011') as channel:
        stub = otc_pb2_grpc.OtcStub(channel)
        print(stub.SendLimitQuoteFill(otc_pb2.SendLimitQuoteFillRequestV1(
            user_id='aaa@gmail.com',
            trader_identifier='bbb@gmail.com',
            side='buy',
            symbol='BTC/USD',
            quantity='1',
            notional='base',
            limit_price='15000',
            entity='zerocap',
            fee='20',
            fee_notional='bps',
            fee_type='separate',
            dealers='dvchain',
            request_type='no hedge'
        )))


if __name__ == '__main__':
    run()
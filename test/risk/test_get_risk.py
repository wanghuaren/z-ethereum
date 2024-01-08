import grpc
import sys
import pathlib

sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))
import otc_pb2
import otc_pb2_grpc


def run():
    with grpc.insecure_channel('localhost:5011') as channel:
        stub = otc_pb2_grpc.OtcStub(channel)
        import time
        start = time.time()
        # print(stub.GetRisk(otc_pb2.GetRiskRequestV1(
        #     limit=20, page=1, start_timestamp=1, end_timestamp=9999999999999, user_id="1727e8bb-32ea-4abb-9582-e4eea8546ec0"
        # )))
        print(stub.GetKLine(otc_pb2.GetKLineRequestV1(
            date_type='3m'
        )))
        print(time.time()-start)


if __name__ == '__main__':
    run()

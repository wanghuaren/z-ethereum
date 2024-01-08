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
        print(stub.CheckToPortal(otc_pb2.CheckToPortalRequestV1(
            asset_id="BTC",
            quantity="0.000001",
            user_id="77cfb25e-9293-4131-b2e2-bb9ddc480474",
            vault_id="537",
            account_id="47efc7e2-0521-467d-85f2-ee71dc1f1b48"
        )))
        print(time.time()-start)


if __name__ == '__main__':
    run()
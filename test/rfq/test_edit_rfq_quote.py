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
        print(stub.EditRFQQuote(otc_pb2.EditRFQQuoteRequestV1(
            quote_alias='e59a988c-2d05-4f47-bbc4-83e13d0d5cd2',
            quote_price='18000.0'
        )))
        print(time.time()-start)



if __name__ == '__main__':
    run()

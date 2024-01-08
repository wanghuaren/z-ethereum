import grpc
import sys
sys.path.append('..')
import otc_pb2
import otc_pb2_grpc


def run():
    with grpc.insecure_channel('localhost:5011') as channel:
        stub = otc_pb2_grpc.OtcStub(channel)
        # print(stub.CheckToPortal(otc_pb2.CheckToPortalRequestV1(
        #     user_id="maomao_test",
        #     asset_id="BTC",
        #     quantity="1",
        # )))

        # print(stub.CreateEMSTransaction(otc_pb2.CreateEMSTransactionRequestV1(
        #     user_id="joys.karen@foxmail.com",
        #     asset_id="ETH",
        #     quantity="0.019",
        #     txn_alias="2b4b4d34-0b04-4cae-9f7f-2bbe1d7be385",
        #     withdrawal_alias="",
        #     workspace="",
        # )))
        # check_health_status = stub.OTCCheckHealth(
        #     otc_pb2.OTCCheckHealthRequestV1(
        #
        #     ))
        # print(check_health_status)

        # print(stub.InsterOrUpdateRiskLimit(otc_pb2.InsterOrUpdateRiskLimitRequestV1(
        #     trader_identifier="ffd614cd-336a-47ba-bc18-47a621943e8f",
        #     alert_interval="30",
        #     stop_loss_limit="-1000",
        #     note="test_123"
        # )))

        # print(stub.TraderList(otc_pb2.TraderListRequestV1(
        # )))

        # check_health_status = stub.OTCCheckHealth(
        #     otc_pb2.OTCCheckHealthRequestV1(
        #
        #     ))
        # print(check_health_status)

        # print(stub.AddTreasury(otc_pb2.AddTreasuryRequestV1(
        #     user_id="1727e8bb-32ea-4abb-9582-e4eea8546ec0",
        #     asset_id="USDT",
        #     amount="1000",
        #     fee="25",
        #     fee_type="included",
        #     fee_notional="bps",
        #     created_at="1670316305541",
        #     tx_hash="tx_hash",
        #     destination_address="destination_address",
        #     trader_identifier="1727e8bb-32ea-4abb-9582-e4eea8546ec0",
        #     status="completed",
        #     notes="我的notes1",
        #     account_id="0e7efe49-6476-4466-8bb8-d65b8e210e3c",
        #     vault_id="81"
        # )))

        # print(stub.EditTreasury(otc_pb2.EditTreasuryRequestV1(
        #     user_id="1727e8bb-32ea-4abb-9582-e4eea8546ec0",
        #     asset_id="USDT",
        #     amount="500",
        #     fee="5",
        #     fee_type="included",
        #     fee_notional="base",
        #     created_at="1670316305541",
        #     tx_hash="tx_hash",
        #     destination_address="destination_address",
        #     trader_identifier="1727e8bb-32ea-4abb-9582-e4eea8546ec0",
        #     status="completed",
        #     id="32",
        #     notes="test",
        #     total="1000",
        #     account_id="0e7efe49-6476-4466-8bb8-d65b8e210e3c",
        #     vault_id="81",
        #     treasury_alias="b40644a6-81c6-11ed-bcb1-d050995d14b5"
        # )))
        # print(stub.GetTreasuryList(otc_pb2.GetTreasuryListRequestV1(
        #     user_id="",
        #     asset_id="USDT",
        #     trader="1727e8bb-32ea-4abb-9582-e4eea8546ec0",
        #     date_start="1670316305541",
        #     date_end="1670316305541",
        #     page=1,
        #     limit=20,
        #     status="completed",
        #     fee_type="included"
        # )))

        # # TraderList
        # print(stub.TraderList(otc_pb2.TraderListRequestV1(
        #
        # )))

        # # GetOrders
        # print(stub.GetOrders(otc_pb2.GetOrdersRequestV1(
        #     page=1,
        #     limit=50,
        #     trader_identifier="1727e8bb-32ea-4abb-9582-e4eea8546ec0",
        #     status="open"
        # )))

        # # SendLimitQuoteFill
        # print(stub.SendLimitQuoteFill(otc_pb2.SendLimitQuoteFillRequestV1(
        #     user_id="1727e8bb-32ea-4abb-9582-e4eea8546ec0",
        #     trader_identifier="shun.hu@eigen.capital",
        #     side="buy",
        #     symbol="AAA/BBB",
        #     quantity="1",
        #     notional="base",
        #     limit_price="17780",
        #     entity="zerocap",
        #     fee="20",
        #     fee_notional="bps",
        #     fee_type="separate",
        #     dealers="b2c2,dvchain",
        #     markup="20",
        #     markup_type="bps",
        #     request_type="live hedge",
        #     account_id="0e7efe49-6476-4466-8bb8-d65b8e210e3c",
        #     vault_id="60"
        # )))

        #  GetCustomerInfoFromCRM
        # print(stub.GetCustomerInfoFromCRM(otc_pb2.GetCustomerInfoFromCRMRequestV1(
        #     account_id="43d73276-9860-4eb3-9a30-5ee7eb1aff8c",
        # )))

        print(stub.GetSymbols(otc_pb2.GetSymbolsRequestV1(
            page=3,
            quote="all"
        )))

        # print(stub.GetUsersIdByEMS(otc_pb2.GetUsersIdByEMSRequestV1(
        #     operate="emsgetquote",
        #     user_id="joys.karen@foxmail.com",
        #     tenant="zerocap_portal"
        # )))


if __name__ == '__main__':
    run()

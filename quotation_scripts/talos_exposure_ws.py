import asyncio
import json
import sys
import os
import time
from datetime import datetime
from queue import Queue

import websockets

import os
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

from clients.talos.talos_ws_client import TalosWebSocketClient
from utils.logger import logger
from utils.redis_cli import RedisClient
from utils.safe_stop_thread import SafeStopThread
from utils.slack_utils import send_slack
from config.config import TALOS_CONFIG

data_queue = Queue()


class TalosWebSocketClientProcess(TalosWebSocketClient, SafeStopThread):

    def __init__(self):
        self.ws_recv_bool = False
        TalosWebSocketClient.__init__(self)
        SafeStopThread.__init__(self, loop_sleep_time=2)
        self.source_supported_list = self.get_source_supported_list()

        logger.info("TalosWebSocket_Exposure Start...")

    @staticmethod
    def get_source_supported_list():
        """
        从配置文件里获取zerocap、vesper支持的交易所
        """
        res = []
        zerocap_account = TALOS_CONFIG.get('MARKETS_ACCOUNTS').get('zerocap').items()
        vesper_account = TALOS_CONFIG.get('MARKETS_ACCOUNTS').get('vesper').items()
        for market, account_i in list(zerocap_account) + list(vesper_account):
            res.append(market + '/' + account_i)
        # print(res)
        return res

    async def ws_recv(self, ws):
        while self.ws_recv_bool:
            response = await ws.recv()
            # print(response)
            # logger.info(f"ws-received: {response}")
            data_queue.put(response)

    async def ws_get_market_data_snapshot(self):

        async with websockets.connect(self.endpoint, extra_headers=self.header, ping_timeout=10) as ws:
            response = await ws.recv()
            logger.info(f"ws-received: {response}")
            await ws.send(json.dumps({
                "reqid": 1,
                "type": "subscribe",
                "streams": [
                    {
                        "name": "Exposure",
                        "Throttle": "1s",  # 曝光更新的可选节流间隔。如果未提供，则默认为 1 秒。
                        "Counterparties": self.source_supported_list,  # 交易所
                        "Tolerance": "0.1"
                        # 可选参数，用于指示应触发发送曝光更新的曝光百分比变化。Exposure, Balance, AvailableBuy,AvailableSell和MarketExposure字段需要进行容差检查。最小值：0，最大值：0.5，默认值：0.01表示 1%。
                    }
                ]
            }))
            # logger.info("send successfully!!!")
            self.ws_recv_bool = True
            await asyncio.gather(self.ws_recv(ws))

    def run_once(self):
        try:
            self.header = self.build_headers(self.path)
            asyncio.run(self.ws_get_market_data_snapshot())
        except Exception as e:
            logger.info({f"ws-exposure: Link parameters >>> {self.endpoint, '------', self.header}"})

            self.ws_recv_bool = False
            logger.exception({f"ws-exposure-run_once: {e}"})
            send_slack(
                channel='SLACK_API_OPS',
                subject="TalosWebSocket_Exposure->run",
                content=e)


class DataUpdateProcess(SafeStopThread):
    last_price_time = datetime.utcnow()

    def __init__(self):
        super().__init__()
        self.redis_client = RedisClient()

    def run_once(self):
        try:
            data = data_queue.get()
            self.process_data(data)
        except Exception as e:
            logger.exception(f"ws-exposure-process_data: {e}")
            send_slack(
                channel='SLACK_API_OPS',
                subject="TalosWebSocket_Exposure->process_data",
                content=e)

    @staticmethod
    def get_entity_from_config(account):

        for entity, data in TALOS_CONFIG.get('MARKETS_ACCOUNTS').items():
            if account in data.values():
                return entity

    def process_data(self, data):
        """
        data:{"reqid":1,"type":"Exposure","seq":1,"initial":true,"ts":"2022-06-20T05:56:57.478480Z","data":[
        {"Timestamp":"2022-06-20T05:56:57.474266Z","Counterparty":"okex","Exposure":"33231237197.05",
        "ExposureCurrency":"USD","Status":"Online","ExposureDefinition":"buying-power","MarketAccount":"okex/okex",
        "Text":"missing conversion rates: BSV-USD, ...."},]}

        处理接受的数据并存入redis数据库里
        """
        json_data = json.loads(data)
        exposure_data_list = json_data.get('data', [])
        logger.info(json_data)
        for i in exposure_data_list:

            k_name = i.get('Counterparty')  # ==> 'b2c2'
            market_account = i.get('MarketAccount')

            if k_name and market_account:
                account = market_account.split('/')[-1]
                key = f"{k_name}_{self.get_entity_from_config(account)}_exposure"
                self.redis_client.set(key=key, value=i)
                self.redis_client.set(key="talos_exposure_last_update", value=time.time())


if __name__ == '__main__':
    talos_web_socket_client_process = TalosWebSocketClientProcess()
    data_update_process = DataUpdateProcess()

    talos_web_socket_client_process.start()
    data_update_process.start()

    talos_web_socket_client_process.join()
    data_update_process.join()

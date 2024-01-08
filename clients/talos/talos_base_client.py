import base64
import hashlib
import hmac
import os
from datetime import datetime
from config.config import TALOS_CONFIG
from datetime import timezone
from db.models import TraderConfig
from utils.redis_cli import RedisClient
from utils.talos_key_encryption import TalosKeyEncryption
from utils.zc_exception import ZCException


# from execution.utils.logger import logger


class TalosBaseClient:

    def __init__(self, entity="zerocap", trader_identifier=''):

        self.redis_client = RedisClient()
        self.api_key = TALOS_CONFIG.get("TALOS_API_KEY", '')
        self.api_secret = TALOS_CONFIG.get("TALOS_API_SECRET", '')
        if trader_identifier:
            self.get_trader_api_key_and_secret(trader_identifier)

        self.entity = entity.lower()
        self.host = TALOS_CONFIG['TALOS_URL']

        # 读取配置文件的交易所
        self.markets = TALOS_CONFIG['MARKETS_ACCOUNTS'][self.entity]

        # sandbox环境
        # self.host = "tal-71.sandbox.talostrading.com"
        self.utc_datetime = datetime.now(timezone.utc).strftime(
            "%Y-%m-%dT%H:%M:%S.000000Z"
        )

        # 以下参数需要继承
        self.path = ""
        self.endpoint = ""

        # logger.info('client init finished')

    def decode_api_key_and_secret(self, rsa_api_key, rsa_secret):
        talos_encryption = TalosKeyEncryption()
        self.api_key = talos_encryption.rsa_decode(rsa_api_key)
        self.api_secret = talos_encryption.rsa_decode(rsa_secret)

    def get_trader_api_key_and_secret(self, trader_identifier):
        self.api_key = self.redis_client.json_get(f'api_key_{trader_identifier}')
        self.api_secret = self.redis_client.json_get(f'secret_{trader_identifier}')
        if not self.api_key or not self.api_secret:
            try:
                trader_config = TraderConfig.select().where(
                    (TraderConfig.trader_identifier == trader_identifier) & (TraderConfig.status == "active"))[0]
            except Exception as e:
                raise ZCException(
                    f"trader_identifier does not exits in TraderConfig:{trader_identifier}"
                ) from e
            rsa_api_key = trader_config.key
            rsa_secret = trader_config.secret
            self.decode_api_key_and_secret(rsa_api_key, rsa_secret)
            self.redis_client.json_set(f'api_key_{trader_identifier}', self.api_key, ex=3600)
            self.redis_client.json_set(f'secret_{trader_identifier}', self.api_secret, ex=3600)

    def build_headers(self, path, query="", body="", method="GET", utc_datetime=None):
        if not utc_datetime:
            utc_now = datetime.now(timezone.utc)
            utc_datetime = utc_now.strftime("%Y-%m-%dT%H:%M:%S.000000Z")

        params = [
            method,
            utc_datetime,
            self.host,
            path,
        ]
        if query:
            params.append(query)
        if body:
            params.append(body)

        payload = "\n".join(params)
        hashvalue = hmac.new(
            self.api_secret.encode('ascii'), payload.encode('ascii'), hashlib.sha256)
        hashvalue.hexdigest()
        signature = base64.urlsafe_b64encode(hashvalue.digest()).decode()
        return {
            "TALOS-KEY": self.api_key,
            "TALOS-SIGN": signature,
            "TALOS-TS": utc_datetime,
        }

    def get_market_account(self, market):

        if market in self.markets:
            return f"{market}/{self.markets[market]}"
        return

    def get_markets_account(self, markets):
        res = [self.get_market_account(market) for market in markets.split(',')]
        return ','.join(res).strip(',')

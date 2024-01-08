import os
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

import hmac
import uuid
import time
import base64
import hashlib
import requests
import datetime
import traceback
from requests.adapters import HTTPAdapter

from db.models import Fills, Users, Groups, EntityAccount, Vaults
from db.base_models import db
from db_api.users_api import query_users_user_id_by_email, get_all_key_secret
from config.config import config
from utils.slack_utils import send_slack
from utils.logger import logger
from clients.talos_cilent import TalosClient
from utils.talos_key_encryption import TalosKeyEncryption
from celery_async_task.send_tasks import send_task_to_queue
from utils.date_time_utils import get_template_time_format_from_timestamp
from internal.transaction.data_helper import handle_timestamp


# 配置重连 5 次
req = requests.Session()
req.mount('http://', HTTPAdapter(max_retries=5))
req.mount('https://', HTTPAdapter(max_retries=5))


class TalosTradeHistory:

    def __init__(self):
        self.talos_client = TalosClient()
        self.host =  os.environ.get("TALOS_URL")
        # self.host = 'tal-90.prod.talostrading.com' # 生产域名
        self.is_request_ok = 200
        self.logger = logger
        self.trade_email = {
            "Kurt Grumelart": "kurt@zerocap.io",
            "Maomao Hu": "maomao+auth0test@zerocap.io",
            "William Fong": "william@zerocap.com",
            "Toby Chapple": "tobychapple1@gmail.com",
            "Caleb Wong": "caleb.wong@zerocap.com",
            "Denzy Rebello": "denzy.rebello@zerocap.com",
            "Berkeley Cox": "berkeley@zerocap.com",
            "Joe Wilson": "joe@zerocap.com",
            "Sam Holman": "sam.holman@zerocap.com",
            "Sam H": "sam.holman@zerocap.com",
            "Jon de Wet": "jon@zerocap.io",
            "Edward Goldman": "edward.goldman@zerocap.com",
            "Jonathan de Wet": "jon@zerocap.io",
            "Egor Griorev": "egor.grigorev@zerocap.com",
            "Gosuke Nakamura": "gosuke@zerocap.com",
            "Jaiden May": "jaiden.may@zerocap.com",
            "Pingsheng Zhong": "Pingsheng Zhong"
        }
        self.blotter_trade = {
            "kurt@zerocap.io": "KG",
            "william@zerocap.com": "WF",
            "berkeley@zerocap.com": "BC",
            "joe@zerocap.com": "JW",
            "parth@zerocap.com": "PS",
            "sam.holman@zerocap.com": "SH",
            "caleb.wong@zerocap.com": "CW",
            "denzy.rebello@zerocap.com": "DR",
            "edward.goldman@zerocap.com": "EG",
            "toby@zerocap.com": "TC",
            "jon@zerocap.com": "JD"
        }

        self.email_modify_user_id()
        self.valut_id_result = self.get_account_id_vault_id_dict()
        # 个人用户 email 和 accout_id 字典;
        self.user_email_result = self.get_user_email_account_id(self.valut_id_result)
        # 组用户 email 和 account_id 字典
        self.group_email_account_id_dict = self.get_group_email_account_id_dict(self.valut_id_result)

    def email_modify_user_id(self):
        for k, v in self.trade_email.items():
            user_id = query_users_user_id_by_email(v)
            if user_id:
                self.trade_email[k] = user_id
                self.blotter_trade[user_id] = self.blotter_trade.get(v)


    def get_user_email_account_id(self, valut_id_result):
        """
        获取 个人 email 和 account_id 的关系字典
        """
        response = Users.select(Users.user_id, Users.email, Users.entity_id, EntityAccount.account_id).\
            join(EntityAccount, on=(Users.entity_id == EntityAccount.entity_id))
        result = []
        for i in response.objects():
            res_vault_id_list = [j['vault_id'] for j in valut_id_result if j['account_id'] == i.account_id]
            res_vault_id = res_vault_id_list[0] if res_vault_id_list else ""
            result.append({
                "user_id": i.user_id,
                "email": i.email,
                "entity_id": i.entity_id,
                "account_id": i.account_id,
                "vault_id": res_vault_id,
            })
        return result

    def get_group_email_account_id_dict(self, valut_id_result):
        """
        获取 组用户 email 和 account_id 的关系字典
        :return:
        """
        response = Groups.select(Groups.group_name, Groups.entity_id, EntityAccount.account_id).\
            join(EntityAccount, on=(Groups.entity_id == EntityAccount.entity_id)).\
            where(Groups.status == 'active')
        result = []
        for i in response.objects():
            res_vault_id_list = [j['vault_id'] for j in valut_id_result if j['account_id'] == i.account_id]
            res_vault_id = res_vault_id_list[0] if res_vault_id_list else ""
            result.append({
                "group_name": i.group_name,
                "entity_id": i.entity_id,
                "account_id": i.account_id,
                "vault_id": res_vault_id,
            })
        return result

    def get_account_id_vault_id_dict(self):
        """
        获取到 account_id和vault_id的关系字典
        :return:
        """
        response = Vaults.select(Vaults.account_id, Vaults.vault_id).where(Vaults.status == 'active')
        return [
            {
                "account_id": i.account_id,
                "vault_id": i.vault_id,
            }
            for i in response
        ]

    def build_headers(self, api_key, api_secret, path, query="", body="", method="GET", utc_datetime=None):
        if not utc_datetime:
            utc_now = datetime.datetime.now(datetime.timezone.utc)
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
            api_secret.encode('ascii'), payload.encode('ascii'), hashlib.sha256)
        hashvalue.hexdigest()
        signature = base64.urlsafe_b64encode(hashvalue.digest()).decode()
        return {
            "TALOS-KEY": api_key,
            "TALOS-SIGN": signature,
            "TALOS-TS": utc_datetime,
        }

    def get(self, api_key, api_secret, path, query=None, is_json_response=True):
        try:
            url = f"https://{self.host}{path}"
            if query:
                url += f'?{query}'
            headers = self.build_headers(api_key, api_secret, path, query)
            response = req.get(url=url, headers=headers)
            if response.status_code != self.is_request_ok:
                self.logger.error(response.text)
                return response
            return response.json() if is_json_response else response.text
        except Exception as e:
            self.logger.exception(traceback.format_exc())
            raise Exception(traceback.format_exc()) from e

    # 获取 customer 订单(需要提供订单的 order_id)
    def get_customer_order(self, api_key, api_secret, order_id, summary=False):
        path = f'/v1/customer/orders/{order_id}/summary'
        if summary:
            path += f'{path}/summary'

        res = self.get(api_key, api_secret, path)
        if not isinstance(res, dict):
            self.logger.error(f'Invalid order_id {order_id}, res: {res}')
            return False

        data = res.get('data', '')
        return bool(data)

    def get_order_type(self, api_key, api_secret, order_id):
        path = "/v1/orders"
        query = f"OrderID={order_id}"
        res = self.get(api_key, api_secret, path, query)
        data = res.get("data")

        order_type = ""
        if data:
            order_type = data[0]["OrdType"]
        elif self.get_customer_order(api_key, api_secret, order_id=order_id):   # customer order 先跳过
            self.logger.info(f"Customer order, order id: {order_id}")
            order_type = "customer order"
        else:
            self.logger.error(f"Get OrderType Failed, Invalid order_id {order_id}")
            send_slack(channel='SLACK_API_OPS',
                       subject="get_talos_trade_history: get order type error",
                       content=f'order_id: {order_id}')
        return order_type

    def get_unique_data(self, data_lst):
        # 剔除已经在 fills 表中存在的数据
        tx_ref_lst = [data.get("OrderID") for data in data_lst] + \
                         [f'{data.get("OrderID")}|{data.get("TradeID")}' for data in data_lst]
        response = Fills.select(Fills.tx_ref).where(Fills.tx_ref.in_(tx_ref_lst))
        existed_tx_ref = [res.tx_ref for res in response]
        return [
            data
            for data in data_lst
            if data.get("OrderID") not in existed_tx_ref
            and f'{data.get("OrderID")}|{data.get("TradeID")}'
            not in existed_tx_ref
        ]

    def save_fills(self, trade_history_lst):
        with db.atomic():
            # 将数据分批次(每次50条)插入数据库
            for i in range(0, len(trade_history_lst), 50):
                Fills.insert_many(trade_history_lst[i:i+50]).execute()
                time.sleep(0.1)

    def handle_fills_to_blotter(self, fills_data):
        for data in fills_data:
            tx_ref = data.get("tx_ref")
            order_id = tx_ref.split("|")[0]

            blotter_data = {
                "trade": self.blotter_trade.get(data.get("trader_identifier", ""), ""),
                "settled": "",
                "is_ems": "Y",
                "ems_status": "Talos",
                "setting_to": "",
                "trade_no": "",  # 到具体任务中去获取
                "data_time": handle_timestamp(data.get("created_at"))[0],
                "counterparty": data.get("dealers"),
                "reference": "H",
                "referer": "",
                "counterparty_bs_1": "S" if data.get("side") == "buy" else "B",
                "base_asset_ccy": data.get("base_asset"),
                "base_amount": data.get("quantity"),
                "counterparty_bs_2": "B" if data.get("side") == "buy" else "S",
                "quote_asset_ccy": data.get("quote_asset"),
                "quote_amount": data.get("quote_quantity"),
                "counterparty_rate": data.get("exec_price"),
                "fee": "",
                "ref_fee": "",
                "otc_usd_markup": "",
                "otc_usd_fee": "",
                "prop_fx_hedge": "",
                "cust_volume_otc": "",
                "date_payment_arrived": "LP",
                "payment_txid_or_reference": "LP",
                "date_settlement_sent": "LP",
                "settlement_txid_reference": "LP",
                "portal_balance_adjustment": "",
                "asset_location": "",
                "notes": "",
                'btc_eth': '',
                'altcoin_vol': '',
                'stablecoin_vol': '',
                'treasury': '',
                'fx_stablecoin': '',
                'btc_eth_pnl': '',
                'altcoin_vol_pnl': '',
                'stablecoin_vol_pnl': '',
                'treasury_pnl': '',
                'fx_stablecoin_pnl': '',
                "operate": "add_blotter",
                "txn_alias": "",
                "old_alias": "",
                "new_alias": data.get("fill_alias"),
                "data_type": "fills",
                "order_id": order_id,
                "data_source": "talos_history"
            }
            send_task_to_queue(**blotter_data)

    def handle_decimal(self, num):
        str_num = str(num).rstrip("0")
        if str_num.endswith("."):
            str_num += "0"
        return str_num

    def handle_duplicate_data(self, api_key, api_secret, data_lst):
        # 生产环境会获取到没有 OrderID 的数据(未完成的订单)，需要跳过该部分数据
        confirmed_data = [data for data in data_lst if data.get("OrderID")]
        # 该函数将重复数据整合以及剔除在 fills 表中存在的数据
        unique_data = self.get_unique_data(confirmed_data)
        trade_history_lst = []
        for data in unique_data:
            try:
                tx_ref = data.get("OrderID", "")
                trade_id = data.get("TradeID", "")

                user = data.get("User", "")
                if not user:
                    continue

                trader_identifier = self.trade_email.get(user, "")
                if not trader_identifier:
                    continue

                quantity = self.handle_decimal(data.get("Quantity", ""))
                exec_price = self.handle_decimal(data.get("Price", ""))
                side = data.get("Side", "").lower()

                # 2022-11-09T04:56:43.514386Z
                transact_time = data.get("TransactTime", "")
                # 将订单时间转为时间戳
                time_array = time.strptime(transact_time.split(".")[0], "%Y-%m-%dT%H:%M:%S")
                # 2022-11-02 00:00:00 时间戳
                start_time = 1667318400000
                created_at = int(time.mktime(time_array)) * 1000
                if created_at < start_time:
                    continue

                order_type = self.get_order_type(api_key, api_secret, tx_ref)
                if order_type == "customer order":
                    continue

                # 组装数据
                fill_data = {
                    "fill_alias": str(uuid.uuid1()),
                    "quote_alias": "",
                    "txn_alias": "",
                    "cppubkey": "",
                    "base_asset": data.get("Currency", ""),
                    "quote_asset": data.get("AmountCurrency", ""),
                    "quantity": quantity,
                    "quote_quantity": data.get("Amount", ""),
                    "quote_price": exec_price,
                    "exec_price": exec_price,
                    "side": side,
                    "pnl": "0",
                    "user_id": "",
                    "trader_identifier": trader_identifier, # Trader Config 表中配置的交易员 uuid
                    "tx_ref": f"{tx_ref}|{trade_id}",
                    "created_at": str(created_at),
                    "status": "success",
                    "entity": "zerocap",
                    "dealers": data.get("Market", ""),
                    "hedge": "live hedge",
                    "order_type": order_type,
                    "data_sources": "talos_trade_history",
                    "account_id": "",
                    "vault_id": ""
                }
                trade_history_lst.append(fill_data)
            except Exception:
                self.logger.error(f"process data failed info: {traceback.format_exc()}")
                send_slack(channel='SLACK_API_OPS',
                        subject="get_talos_trade_history: process fills data error",
                        content='traceback.format_exc():\n%s' % traceback.format_exc())
        return trade_history_lst

    def get_trade_history(self, api_key, api_secret, trader_id, after=None):
        # 抓取从 2022/06/01 开始的数据
        # time_string = datetime.datetime(year=2022, month=6, day=1, hour=0, minute=0, second=0)
        # start_date = time_string.strftime("%Y-%m-%dT%H:%M:%S.000000Z")

        # 抓取 10 天前的数据
        time_string = datetime.datetime.now(
            datetime.timezone.utc
        ) - datetime.timedelta(days=10)
        start_date = time_string.strftime("%Y-%m-%dT%H:%M:%S.000000Z")
        path = "/v1/trade-history"
        query = f"StartDate={start_date}"
        if after:
            query += f"&after={after}"
        try:
            res = self.get(api_key, api_secret, path, query)
            if not isinstance(res, dict):
                send_slack(channel='SLACK_API_OPS',
                           subject="get_talos_trade_history: request talos error",
                           content=res.text)

            if not isinstance(res, dict):   # 有时会有 502 错误，返回的是 requests.models.Response
                return

            data_lst = res.get("data", [])
            next_page = res.get("next", "")

            if not data_lst:
                self.logger.info('No data for crawl time period')

            # 处理接口返回的数据，构造 fills 表数据
            processed_data = self.handle_duplicate_data(api_key, api_secret, data_lst)

            # 组装 blotter 数据, 并发送任务到队列
            self.handle_fills_to_blotter(processed_data)

            # 始终将组装的数据保存到数据库
            self.save_fills(processed_data)

            # 如果有下一页数据，重新执行该函数
            if next_page:
                self.get_trade_history(api_key, api_secret, trader_id, after=next_page)

        except Exception:
            self.logger.error(f"get talos history data : {traceback.format_exc()}")
            send_slack(channel='SLACK_API_OPS',
                       subject="get_talos_trade_history: get talos history data error",
                       content=f'traceback.format_exc():\n {traceback.format_exc()}')

    def main(self):
        # 交易员 api_key 列表
        api_key_secret = get_all_key_secret()
        start_time = time.time()
        talos_key = TalosKeyEncryption()

        # 抓取每一对 api_key 的数据（一个 key 可以获取所有交易员的数据）
        for item in api_key_secret[:1]:
            try:
                print(item["trader_identifier"])
                key = talos_key.rsa_decode(item["api_key"])
                secret = talos_key.rsa_decode(item["api_secret"])
                self.get_trade_history(str(key), str(secret), item["trader_identifier"])
            except Exception:
                self.logger.error(f"get talos history data : {traceback.format_exc()}")
                send_slack(channel='SLACK_API_OPS',
                       subject="get_talos_trade_history: get talos history data error",
                       content=f'traceback.format_exc():\n {traceback.format_exc()}')
        print(time.time() - start_time)


if __name__ == '__main__':
    client = TalosTradeHistory()
    # client.get_order_type()
    # client.get_trade_history()
    # client.get_unique_data()
    # client.handle_decimal("0.000")
    client.main()

import sys
import datetime
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

from db.models import db, Fills
from utils.logger import logger
from clients.talos_cilent import TalosClient
from db_api.users_api import query_users_user_id_by_email

class UpdateHistory():
    def __init__(self):
        self.trade_email = {
            "Kurt Grumelart": "kurt@zerocap.io",
            "Maomao Hu": "maomao@zerocap.com",
            "William Fong": "william@zerocap.com",
            "Toby Chapple": "toby@zerocap.com",
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
            "Jaiden May": "jaiden.may@zerocap.com"
        }
        self.talos = TalosClient()
        self.email_modify_user_id()
        self.all_data = {}  # 从 talos 抓到的数据
        self.trade_data = self.get_history_fills_trader_id()  # Fills 表中的数据
        # Fills 表中 data_sources 为 talos_trade_history 的中时间最早的数据当天的 0 点的格式化时间
        self.start_data = self.get_start_data()

    def email_modify_user_id(self):
        for k, v in self.trade_email.items():
            user_id = query_users_user_id_by_email(v)
            if user_id:
                self.trade_email[k] = user_id

    def get_history_fills_trader_id(self):
        response = Fills.select(Fills.tx_ref, Fills.trader_identifier).where(Fills.data_sources == 'talos_trade_history')

        trader_id_dict = {}
        for res in response:
            trader_id = res.tx_ref
            trader_id_dict[trader_id] = res.trader_identifier

        return trader_id_dict

    def get_start_data(self):
        res = Fills.select(Fills.created_at).where(Fills.data_sources == 'talos_trade_history').\
            order_by(Fills.created_at.asc()).first()
        dt_obj = datetime.datetime.fromtimestamp(int(res.created_at)/1000)
        month = dt_obj.month if int(dt_obj.month) >= 10 else f"0{dt_obj.month}"
        day = dt_obj.day if int(dt_obj.day) >= 10 else f"0{dt_obj.day}"
        start_date = f"{dt_obj.year}-{month}-{day}T00:00:00.000000Z"
        return start_date

    def get_data(self, after=None):
        # 获取从 start_data 开始的历史数据
        res_data = self.talos.get_history_orders(self.start_data, after)
        data_lst = res_data.get("data", [])
        next_page = res_data.get("next", "")

        current_page_data = {f'{data.get("OrderID", "")}|{data.get("TradeID", "")}': data.get("User", "")
                             for data in data_lst}
        self.all_data.update(current_page_data)

        # 获取下一页数据
        if next_page:
            self.get_data(after=next_page)

    def update_fills_trader_identifier(self, update_data):
        with db.atomic():
            for data in update_data:
                Fills.update(data).where(Fills.tx_ref == data["tx_ref"]).execute()


    def run(self):
        self.get_data()
        logger.info(f"从 {self.start_data} 开始共有 {len(self.all_data.keys())}")
        logger.info(f"从 Fills 表获取到的共有 {len(self.trade_data.keys())}")
        logger.info(f"交易员对应的 user id: {self.trade_email}")

        update_data = []
        # 开始对比数据
        for key, val in self.trade_data.items():
            # key: order_id|trade_id
            # val: 交易员 id
            origin_trade_id = val  # Fills 表中记录的交易员 id
            talos_trade_name = self.all_data.get(key, "")
            correct_trader_id = self.trade_email[talos_trade_name]

            if correct_trader_id == origin_trade_id:
                continue

            logger.info(f"将 Fills 表中 tx_ref 为 {key} 的 trader_identifier 由 {origin_trade_id} 更新为 {correct_trader_id}")
            update_data.append({
                "tx_ref": key,
                "trader_identifier":correct_trader_id
            })

        logger.info(f"需要更新 trader_identifier 的数据共 {len(update_data)}: {update_data}")
        # 更新数据
        self.update_fills_trader_identifier(update_data)
        logger.info("更新完成")



if __name__ == '__main__':
    uh = UpdateHistory()
    print(uh.start_data)
    uh.run()

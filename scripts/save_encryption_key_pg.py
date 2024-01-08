
import os
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

from config.config import config
from datetime import datetime, timezone

from db.base_models import db
from db.models import TraderConfig, Users
from db_api.users_api import query_users_user_id_by_email
from utils.talos_key_encryption import TalosKeyEncryption

public_key = config['TALOS_TRADE_KEYS'][0]['public_key']
private_key = config['TALOS_TRADE_KEYS'][0]['private_key']


class SaveEncryptionKeyPg(TalosKeyEncryption):

    def handle_traders_key(self, trader_list):
        """
        对应的交易员的key、secret
        :param trader_list:
        :return:
        """
        trader_config_list = []
        for traders in trader_list:
            # 查询 users 表，获取对应的 user_id 字段
            email = traders.get("email", None)
            trader_identifier = query_users_user_id_by_email(email)

            # 使用 rsa_encode 加密 trader_list 中的 key、secret
            key = self.rsa_encode(traders["key"])
            secret = self.rsa_encode(traders["secret"])

            utc_now = int(datetime.now(timezone.utc).timestamp())

            trader_config_list.append({
                "email": email,
                "trader_identifier": trader_identifier if trader_identifier else "",
                "key": key,
                "secret": secret,
                "status": "active",
                "created_at": utc_now,
                "last_updated": utc_now
            })

        # 将加密后的 trader_config_list 中的数据，写入到 trader_config 表中，如果已存在(状态是 active)，就更新，不存在，则插入。
        with db.atomic():
            # 根据TraderConfig.email, TraderConfig.status 两个字段判断是插入还是更新
            TraderConfig.insert_many(trader_config_list).on_conflict(
                conflict_target=[TraderConfig.email, TraderConfig.status],
                preserve=[TraderConfig.email, TraderConfig.trader_identifier, TraderConfig.key, TraderConfig.secret,
                          TraderConfig.status, TraderConfig.created_at, TraderConfig.last_updated]).execute()

        return True


def get_trader_email():
    res = Users.select(Users.email).where(Users.role >= 3)
    return [i.email for i in res]


if __name__ == '__main__':
    from config.config import ENV
    if ENV == 'development':
        trader_email_list = get_trader_email()
        trader_list = [{"email": i, "key": "ZER8MN7TLBU1", "secret": "7tszn5ddmkxobvdqo96p21388qxnkx63"} for i in trader_email_list]
    else:
        trader_list = [
                {
                    "email": "pingsheng.zhong@zerocap.com",
                    "key": "ZER8MN7TLBU1",
                    "secret": "7tszn5ddmkxobvdqo96p21388qxnkx63",
                },
                {
                    "email": "joys.karen@foxmail.com",
                    "key": "ZERKDJQH42Z2",
                    "secret": "fv3o0wlnbckziuk712gu8hlnjvwnc9zk",
                }
            ]
    talos = SaveEncryptionKeyPg()
    print(talos.handle_traders_key(trader_list))
    # print(talos.private_key)
    # print(talos.public_key)

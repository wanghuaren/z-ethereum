import time
import uuid

from internal.wallet.data_helper import get_address, create_address, create_wallet_pool
from external_api.fireblocks.fireblocks_gateway import fireblocks_gateway
from utils.consts import DefaultWorkspace, CustomerRefId, ExternalWalletStatusPending
from utils.date_time_utils import iso8601
from utils.logger import logger


class YieldManager(object):

    def __init__(self):
        self.logger = logger
        self.fireblocks = fireblocks_gateway

    def add_address(self, account_id, asset_id, vault_id, workspace=DefaultWorkspace):
        if not workspace:
            workspace = DefaultWorkspace
        # vault = get_vault_by_user_id(user_id)
        user_id = ''
        customer_ref_id = CustomerRefId
        name = asset_id + "_" + account_id + "_" + str(uuid.uuid1())
        timestamp = iso8601(int(time.time() * 1000))
        external_wallet_dic = {
            'name': name,
            'user_id': '',
            'asset_id': asset_id,
            'created_at': timestamp,
            'last_updated': timestamp,
            'status': ExternalWalletStatusPending,
            'tag': customer_ref_id,
            'customer_ref_id': customer_ref_id,
            'workspace': workspace,
            'vault_id': vault_id,
            'account_id': account_id
        }
        address_info = get_address(account_id, asset_id)
        if address_info:  # 数据库里有address
            res_gateway = self.fireblocks.create_external_wallet_asset_for_workspace(
                vault_id=vault_id,
                name=asset_id + "_" + account_id + "_" + str(uuid.uuid1()),
                asset_id=asset_id,
                address=address_info['address'],
                customer_ref_id=customer_ref_id,
                account_id=account_id,
                tag=customer_ref_id,
                workspace=workspace)
            external_wallet_id = res_gateway['external_wallet_id']
            external_wallet_dic["address"] = address_info['address']
            external_wallet_dic["external_wallet_id"] = external_wallet_id
        else:  # 数据库里没有address
            address_id = str(uuid.uuid4())
            all_vault = self.fireblocks.get_all_vault(vault_id, account_id)
            assets = list(
                filter(lambda asset: asset["id"] == asset_id and asset.get("address", None), all_vault['assets']))
            # print("assets:", assets)
            if assets:  # 如果fireblock上有该asset对应的address
                timestamp = int(time.time()) * 1000
                create_address(address_dic={
                    'asset_id': asset_id,
                    'user_id': user_id,
                    'address': assets[0]['address'],
                    'account_id': account_id,
                    'vault_id': vault_id,
                    'created_at': timestamp,
                    'last_updated': timestamp,
                    'status': 'active',
                    'address_id': address_id
                })
                res_gateway = self.fireblocks.create_external_wallet_asset_for_workspace(
                    vault_id=vault_id,
                    name=asset_id + "_" + account_id + "_" + str(uuid.uuid1()),
                    asset_id=asset_id,
                    address=assets[0]['address'],
                    customer_ref_id=customer_ref_id,
                    account_id=account_id,
                    tag=customer_ref_id,
                    workspace=workspace)
                external_wallet_id = res_gateway['external_wallet_id']
                external_wallet_dic["address"] = assets[0]['address']
                external_wallet_dic["external_wallet_id"] = external_wallet_id
            else:  # 如果fireblock上没有该asset对应的address
                self.fireblocks.create_vault_assets(vault_id, [asset_id],
                                                    account_id=account_id)  # fireblock上没有该asset对应的address需创建
                all_vault = self.fireblocks.get_all_vault(vault_id)
                assets = list(filter(lambda asset: asset["id"] == asset_id, all_vault['assets']))
                # print("assets:", assets)
                if assets:
                    create_address(address_dic={
                        'asset_id': asset_id,
                        'user_id': user_id,
                        'address': assets[0]['address'],
                        'account_id': account_id,
                        'vault_id': vault_id,
                        'created_at': timestamp,
                        'last_updated': timestamp,
                        'status': 'active',
                        'address_id': address_id
                    })
                    res_gateway = self.fireblocks.create_external_wallet_asset_for_workspace(
                        vault_id=vault_id,
                        name=asset_id + "_" + account_id + "_" + str(uuid.uuid1()),
                        asset_id=asset_id,
                        address=assets[0]['address'],
                        customer_ref_id=customer_ref_id,
                        account_id=account_id,
                        tag=customer_ref_id,
                        workspace=workspace)
                    external_wallet_id = res_gateway['external_wallet_id']
                    external_wallet_dic["address"] = assets[0]['address']
                    external_wallet_dic["external_wallet_id"] = external_wallet_id
        if external_wallet_dic.get("address", ""):
            create_wallet_pool(external_wallet_dic)
            return external_wallet_dic
        return None


yield_manager = YieldManager()

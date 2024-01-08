import asyncio
import copy
import time
import traceback

from fireblocks_sdk import TransferPeerPath

from config.config import config
from internal.wallet.data_helper import get_wallet_pool_by_user_id_and_asset_id, query_vault_workspace
from external_api.fireblocks.fireblocks_sdk_fix import FireblocksSDKFix
from utils.consts import DefaultWorkspace
from utils.log_utils import LogDecorator
from utils.logger import logger
from utils.slack_utils import send_slack


class FireblocksGateway(object):
    workspace_base = DefaultWorkspace
    client_dict = {}
    workspace_dict = {}

    def __init__(self):
        self.logger = logger
        self.init_client()
        self.fb_client = self.client_dict[self.workspace_base]

    def init_client(self):
        config_gateway = config['CONFIG_GATEWAY']
        if self.workspace_base in config_gateway.keys():
            for item in config_gateway.keys():
                self.logger.debug(f'item:{item}')
                private_key = open(config_gateway[item]['FIREBLOCKS_KEY_PATH'], 'r').read()
                self.client_dict[item] = FireblocksSDKFix(private_key=private_key,
                                                          api_key=config_gateway[item]['API_KEY'])

        else:
            self.logger.debug(f'config_gateway:{config_gateway}')
            private_key = open(config_gateway['FIREBLOCKS_KEY_PATH'], 'r').read()
            self.client_dict[self.workspace_base] = FireblocksSDKFix(private_key=private_key,
                                                                     api_key=config_gateway['API_KEY'])

    def fireblock_client(self, account_id=None, vault_id=None, workspace=None):
        """
        @description  :
            set the workspace from user_id(mail)
        ---------
        @param  :
            user_id: mail
        -------
        @returns  :
            get the fbclient by user's workspace
        -------
        """
        try:

            # workspace = self.workspace_base
            self.workspace_dict = {}
            # if(user_id in self.workspace_dict.keys()):
            #     workspace = self.workspace_dict[user_id]
            # print('workspace1:', user_id , workspace)
            if workspace:
                workspace = workspace
            elif ((account_id, vault_id) in self.workspace_dict.keys()):
                workspace = self.workspace_dict[(account_id, vault_id)]
                # print('workspace2:', user_id , workspace)
            # elif (user_id is not None):
            #     workspace = query_user_workspace(user_id = user_id)
            #     self.workspace_dict[user_id] = workspace
            # print('workspace3:', user_id , workspace)
            elif (vault_id is not None and account_id is not None):
                vault_workspace = query_vault_workspace(vault_id, account_id)
                if (vault_workspace is not None):
                    workspace = vault_workspace
                    self.workspace_dict[(account_id, vault_id)] = workspace
                    # print('workspace4:', user_id , workspace
            else:
                pass

            if (workspace in self.client_dict.keys()):
                return self.client_dict[workspace]
            else:
                raise Exception(
                    f"fireblock_client (account_id:{account_id} -- vault_id:{vault_id}  -- workspace:{workspace}) is not in fireblock client_dict")

        except Exception as e:
            print('Exception:', account_id, e)
            traceback.print_tb(e.__traceback__)
            send_slack(
                channel='SLACK_API_OPS',
                subject="fireblock_client failed",
                content=f"(account_id:{account_id} -- vault_id:{vault_id}  -- workspace:{workspace}) e={e}"
            )

        return self.client_dict[self.workspace_base]

    @LogDecorator()
    def create_external_wallet_asset_for_workspace(self, vault_id, name, asset_id, address, customer_ref_id,
                                                   account_id, tag=None, workspace=DefaultWorkspace,
                                                   user_workspace=None):
        """
        param name: 'test'
        param asset_id: 'BTC_TEST'
        param address: '123'
        return:
        {
            'id': 'BTC_TEST',
            'balance': 0,
            'lockedAmount': 0,
            'status': 'WAITING_FOR_APPROVAL',
            'external_wallet_id': '6d9db9d0-5699-5454-606c-43253072f170'
        }
        """
        if not user_workspace:
            user_workspace = workspace

        fb_client = self.client_dict[workspace]
        result = get_wallet_pool_by_user_id_and_asset_id(asset_id=None, vault_id=vault_id, account_id=account_id,
                                                         workspace=user_workspace)
        if result:
            external_wallet_id = result[-1]['external_wallet_id']
        else:
            external_wallet = fb_client.create_external_wallet(name, customer_ref_id)
            external_wallet_id = external_wallet['id']

        try:
            external_asset = fb_client.create_external_wallet_asset(external_wallet_id, asset_id, address, tag)
        except:
            external_asset = {}
        external_asset['external_wallet_id'] = external_wallet_id
        return external_asset

    @LogDecorator()
    def get_all_vault(self, vault_account_id, account_id, workspace=None):
        result = {}
        result['assets'] = []
        try:
            res = None
            counter = 0
            while not res and counter < 10:
                counter += 1
                fb_client = self.fireblock_client(account_id=account_id, vault_id=vault_account_id, workspace=workspace)
                res = fb_client.get_vault_account_by_id(vault_account_id)
                time.sleep(0.5)
                if (res):
                    # print(f'while:{counter} get_vault_account_by_id:',res)
                    if ('assets' in res.keys()) and (len(res['assets']) <= 0):
                        res = None
                        continue
            result = copy.deepcopy(res)
            result['assets'] = []
            tasks = []
            new_loop = asyncio.new_event_loop()
            asyncio.set_event_loop(new_loop)
            loop = asyncio.get_event_loop()
            for idx, asset in enumerate(res.get('assets', [])):
                time.sleep(0.2)
                tasks.append(self.get_deposit_addresses_async(vault_account_id, asset['id'], account_id=account_id))

            future = asyncio.gather(*tasks)
            res_address = loop.run_until_complete(future)
            for idx, asset in enumerate(res.get('assets', [])):
                response_address = next(item for item in res_address if item[0]["assetId"] == asset['id'])
                if res_address:
                    asset['address'] = response_address[0]['address']
                    if not asset['address']:
                        continue
                    asset['tag'] = response_address[0]['tag']
                    result['assets'].append(asset)
        except Exception as e:
            traceback.print_tb(e.__traceback__)
            send_slack(
                channel='SLACK_API_OPS',
                subject="get_all_vault failed",
                content=f"vault_account_id={vault_account_id} e={e}"
            )

        return result

    @LogDecorator()
    def create_vault_assets(self, vault_id, asset_list=[], account_id=None):
        fb_client = self.fireblock_client(account_id=account_id, vault_id=vault_id)
        for i in asset_list:
            try:
                fb_client.create_vault_asset(vault_id, i)
            except Exception as e:
                if str(
                        e) == 'Got an error from fireblocks server: {"message":"Asset wallet already exists in the vault account","code":1026}':
                    continue
                time.sleep(0.5)
                fb_client.create_vault_asset(vault_id, i)
            time.sleep(0.5)
        result = self.get_vault(vault_id, account_id=account_id, asset_list=asset_list)
        return result

    @LogDecorator()
    def get_vault(self, vault_account_id, account_id=None, asset_list=[]):
        """
        @description  :
            get vault from vault_account_id

        ---------
        @param  :
            vault_account_id: '10'
            user_id: mail

        -------
        @returns  :
            fb vault info
            {
                'id': '10',
                'name': 'test',
                'hiddenOnUI': False,
                'assets': [{
                    'id': 'BTC_TEST',
                    'total': '0.00000000',
                    'balance': '0.00000000',
                    'lockedAmount': '0.00000000',
                    'available': '0.00000000',
                    'pending': '0.00000000'
                }]
            }
        -------
        """
        result = {
            'assets': []
        }
        try:
            res = None
            counter = 0
            while not res and counter < 10:
                counter += 1
                fb_client = self.fireblock_client(account_id=account_id, vault_id=vault_account_id)
                res = fb_client.get_vault_account_by_id(vault_account_id)
                time.sleep(0.5)
                if res:
                    if ('assets' in res.keys()) and (len(res['assets']) <= 0):
                        res = None
                        continue

            result = copy.deepcopy(res)
            result['assets'] = []

            tasks = []
            new_loop = asyncio.new_event_loop()
            asyncio.set_event_loop(new_loop)
            loop = asyncio.get_event_loop()
            for idx, asset in enumerate(res.get('assets', [])):
                if len(asset_list) <= 0:
                    if asset['id'] in config['CONFIG_ASSET']['ASSET_LST']:
                        tasks.append(self.get_deposit_addresses_async(vault_account_id, asset['id'], account_id=account_id))
                else:
                    if asset['id'] in asset_list:
                        tasks.append(self.get_deposit_addresses_async(vault_account_id, asset['id'], account_id=account_id))

            future = asyncio.gather(*tasks)
            res_address = loop.run_until_complete(future)
            for idx, asset in enumerate(res.get('assets', [])):
                # print("res_address, idx, asset", res_address, idx, asset['id'])
                # print(config['ASSET_LST'])
                if asset['id'] in config['CONFIG_ASSET']['ASSET_LST']:
                    response_address = next(item for item in res_address if item[0]["assetId"] == asset['id'])
                    # print("inner response address", response_address)
                    asset['address'] = response_address[0]['address']
                    asset['tag'] = response_address[0]['tag']
                    # result['assets'][asset['id']] = asset
                    result['assets'].append(asset)
                    # print("asset", asset)
        except Exception as e:
            self.logger.exception(str(e))
            send_slack(
                channel='SLACK_API_OPS',
                subject="get_vault failed",
                content=f"vault_account_id={vault_account_id} e={e}"
            )

        return result

    @LogDecorator()
    def create_transaction(self, asset_id, amount, source: TransferPeerPath, destination: TransferPeerPath, note,
                           account_id=None, vault_id=None, treat_as_gross_amount=False, fb_client=None,
                           force_sweep=None):
        """
        param asset_id: 'BTC_TEST'
        param amount: 1
        param source: TransferPeerPath
        param destination: TransferPeerPath
        return: {'id': '7eea5be5-7309-4e58-aebc-fc21918f0fdd', 'status': 'SUBMITTED'}
        """
        if not fb_client:
            fb_client = self.fireblock_client(account_id=account_id, vault_id=vault_id)

        vault_amount = fb_client.get_vault_account_asset(source.id, asset_id)['available']

        if abs(1 - float(amount) / float(vault_amount)) < 1e-3:
            treat_as_gross_amount = True

        if asset_id in ('DOT', 'WND'):
            if float(vault_amount) - float(amount) < 1.001:
                force_sweep = True
                amount = vault_amount
                treat_as_gross_amount = True
            else:
                force_sweep = False

        self.logger.info(f"asset_id: {asset_id}, vault_amount: {vault_amount}, amount: {amount}, treat_as_gross_amount: {treat_as_gross_amount}, force_sweep: {force_sweep}")

        if asset_id in ['ETH', 'USDT_ERC20', 'USDC']:
            gas_res = fb_client.estimate_fee_for_transaction(
                asset_id=asset_id,
                amount=amount,
                source=source,
                destination=destination
            )
            self.logger.debug(f"gas_res: {gas_res}")
            gas_price = gas_res['low']['gasPrice']

            result = fb_client.create_transaction(
                asset_id,
                amount,
                source,
                destination,
                note=note,
                treat_as_gross_amount=treat_as_gross_amount,
                gas_price=gas_price
            )
        else:
            if asset_id in ['WND', 'DOT']:
                self.logger.debug(f"treat_as_gross_amount: {treat_as_gross_amount}")
                self.logger.debug(f"force_sweep: {force_sweep}")
                result = fb_client.create_transaction(
                    asset_id,
                    amount,
                    source,
                    destination,
                    note=note,
                    treat_as_gross_amount=treat_as_gross_amount,
                    force_sweep=force_sweep
                )
            else:
                result = fb_client.create_transaction(
                    asset_id,
                    amount,
                    source,
                    destination,
                    note=note,
                    treat_as_gross_amount=treat_as_gross_amount,
                )
        return result

    @LogDecorator()
    def get_transaction_estimate_fee(self, asset_id, amount, source: TransferPeerPath, destination: TransferPeerPath,
                                     account_id, vault_id, note=None, user_id=None):
        """
        doc: https://docs.fireblocks.com/api/swagger-ui/#/default/post_transactions_estimate_fee

        param asset_id: 'BTC_TEST'
        param amount: 1
        param source: TransferPeerPath
        param destination: TransferPeerPath

        todo: test and post example return here
        {
          "low": {
            "feePerByte": "string",
            "gasPrice": "string",
            "gasLimit": "string",
            "networkFee": "string"
          },
          "medium": {
            "feePerByte": "string",
            "gasPrice": "string",
            "gasLimit": "string",
            "networkFee": "string"
          },
          "high": {
            "feePerByte": "string",
            "gasPrice": "string",
            "gasLimit": "string",
            "networkFee": "string"
          }
        }
        """
        fb_client = self.fireblock_client(account_id=account_id, vault_id=vault_id)
        body = {
            "assetId": asset_id,
            "source": source.__dict__,
            "destination": destination.__dict__,
            "amount": float(amount),
            "operation": 'TRANSFER',
        }

        if note:
            body["note"] = note
        return fb_client._post_request("/v1/transactions/estimate_fee", body)

    @LogDecorator()
    def get_transaction(self, tx_id, account_id=None, vault_id=None):
        """
        param tx_id: 'fc33cfa4-3314-47bc-aaca-48a4d2e9f78b'
        return:
        {'addressType': '',
         'amount': 1,
         'assetId': 'BTC_TEST',
         'createdAt': 1591338797219,
         'createdBy': '832a9c33-e48b-49bb-8fbd-7b31051e39f3',
         'destination': {'id': '7',
                         'name': 'test',
                         'subType': '',
                         'type': 'VAULT_ACCOUNT'},
         'destinationAddress': '',
         'destinationAddressDescription': '',
         'destinationTag': '',
         'exchangeTxId': '',
         'fee': -1,
         'feeCurrency': 'BTC_TEST',
         'id': '7eea5be5-7309-4e58-aebc-fc21918f0fdd',
         'lastUpdated': 1591338797985,
         'netAmount': -1,
         'networkFee': -1,
         'note': '',
         'operation': 'TRANSFER',
         'rejectedBy': '',
         'requestedAmount': 1,
         'signedBy': [],
         'source': {'id': '6', 'name': 'test', 'subType': '', 'type': 'VAULT_ACCOUNT'},
         'status': 'FAILED',
         'subStatus': 'INSUFFICIENT_FUNDS',
         'txHash': ''}
        """
        fb_client = self.fireblock_client(account_id=account_id, vault_id=vault_id)
        result = fb_client.get_transaction_by_id(tx_id)
        return result

    @LogDecorator()
    def cancel_transaction(self, tx_id, account_id=None, vault_id=None):
        """
        param tx_id: 'fc33cfa4-3314-47bc-aaca-48a4d2e9f78b'
        """

        fb_client = self.fireblock_client(account_id=account_id,vault_id=vault_id)
        result = fb_client.cancel_transaction_by_id(tx_id)
        return result

    @LogDecorator()
    async def get_deposit_addresses_async(self, vault_id, asset_id, account_id=None):
        try:
            time.sleep(0.5)
            fb_client = self.fireblock_client(account_id=account_id, vault_id=vault_id)
            res = await fb_client._get_request_aysnc(f"/v1/vault/accounts/{vault_id}/{asset_id}/addresses")
        except Exception as e:
            return None
        if res:
            return res
        else:
            return [{'assetId': asset_id, 'address': '', 'tag': '', 'description': '', 'type': '', 'legacyAddress': ''}]
            # return []

fireblocks_gateway = FireblocksGateway()

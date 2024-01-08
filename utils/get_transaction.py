import os
import sys
import json
import aiohttp
import asyncio
import traceback
import uuid
from google.protobuf.json_format import MessageToJson

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import otc_pb2


class GetTransactionByTxHash():

    def __init__(self, proxy=None) -> None:
        self.proxy = proxy or None

    def return_error(self, tx_hash, asset_id, messsage=None):
        if not messsage:
            messsage = "Sorry! Can't find the transaction (or not supported currently)."
        error_message = [otc_pb2.ErrorMessageV1(
            tx_hash_error=messsage)]
        result = [otc_pb2.ResultV1(
            tx_hash=tx_hash,
            asset_id=asset_id,
            quantity="",
            source_address=[],
            destination_address=[],
            blokchain="", )]
        return result, error_message

    def return_data(self, tx_hash, asset_id, quantity='', source_address=[], destination_address=[], blokchain=''):
        result = [otc_pb2.ResultV1(
            tx_hash=tx_hash,
            asset_id=asset_id,
            quantity=str(quantity),
            source_address=list(set(source_address)),
            destination_address=list(set(destination_address)),
            blokchain=blokchain)]
        return result, []

    async def get_biction_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/bitcoin/dashboards/transaction/"
        async with aiohttp.request(method='GET',
                                   url=source_url + tx_hash + '?omni=true&privacy-o-meter=true', 
                                   proxy=self.proxy) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                hash_data = rep_data["data"][tx_hash.lower()]
                value = hash_data['transaction']["output_total"]
                quantity = str(value / 100000000)
                source_address = [f.get('recipient') for f in hash_data['inputs']]
                destination_address = [t.get('recipient') for t in hash_data['outputs']]
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Bitcoin')

    async def get_ethereum_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/ethereum/dashboards/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash + "?erc_20=true", proxy=self.proxy) as response:
            if response.status > 200:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                source_address = []
                destination_address = []
                rep_data = rep_data["data"][tx_hash.lower()]
                transaction = rep_data["transaction"]
                quantity = transaction["value"]
                erc_20 = rep_data.get("layer_2", {}).get("erc_20", {})
                for erc in erc_20:
                    source_address.append(erc.get("sender"))
                    destination_address.append(erc.get("recipient"))

                if not erc_20:
                    source_address.append(transaction["sender"])
                    destination_address.append(transaction["recipient"])

                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Ethereum')

    async def get_ethereum_test_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/ethereum/testnet/dashboards/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                source_address = []
                destination_address = []
                rep_data = rep_data["data"][tx_hash.lower()]
                transaction = rep_data["transaction"]
                quantity = transaction["value"]
                erc_20 = rep_data.get("layer_2", {}).get("erc_20", {})
                for erc in erc_20:
                    source_address.append(erc.get("sender"))
                    destination_address.append(erc.get("recipient"))

                if not erc_20:
                    source_address.append(transaction["sender"])
                    destination_address.append(transaction["recipient"])
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=[transaction["sender"]],
                                        destination_address=[transaction["recipient"]],
                                        blokchain='Ethereum Testnet')

    async def get_cardano_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/cardano/raw/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status > 200:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                transaction = rep_data["data"][tx_hash.lower()]["transaction"]
                quantity = int(transaction["ctsTotalInput"]["getCoin"]) / 1000000
                source_address = [f.get('ctaAddress') for f in transaction['ctsInputs']]
                destination_address = [t.get('ctaAddress') for t in transaction['ctsOutputs']]
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=str(quantity),
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Cardano')

    async def get_litecoin_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/litecoin/dashboards/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status > 200:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                hash_data = rep_data["data"][tx_hash.lower()]
                value = hash_data['transaction']["output_total"]
                quantity = str(int(value) / 100000000)
                source_address = [f.get('recipient') for f in hash_data['inputs']]
                destination_address = [t.get('recipient') for t in hash_data['outputs']]
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Litecoin')

    # WND，DOT 的测试链
    async def get_westend_data(self, asset_id, tx_hash):
        source_url = "https://westend.webapi.subscan.io/api/scan/extrinsic"
        headers = {
            "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36",
            "referer": "https://westend.subscan.io/",
            "content-type": "application/json",
        }
        data = '{"hash":"' + tx_hash + '","events_limit":10,"focus":""}'
        async with aiohttp.request(method='POST', url=source_url, headers=headers, data=data, proxy=self.proxy) as response:
            json_data = json.loads(await response.text())
            if response.status == 400 or json_data["data"] is None:
                return None

            elif response.status == 200:
                transaction = json_data["data"]["transfer"]
                quantity = str(transaction["amount"])
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=[transaction["from"]],
                                        destination_address=[transaction["to"]])

    async def get_polkadot_data_from_subscan(self, asset_id, tx_hash):
        source_url = "https://polkadot.webapi.subscan.io/api/scan/extrinsic"
        headers = {
            "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36",
            "referer": "https://polkadot.subscan.io/",
            "content-type": "application/json",
        }
        data = '{"hash":"' + tx_hash + '","events_limit":10,"focus":""}'
        async with aiohttp.request(method='POST', url=source_url, headers=headers, data=data, proxy=self.proxy) as response:
            json_data = json.loads(await response.text())
            if response.status == 400 or json_data["data"] is None:
                return None

            elif response.status == 200:
                transaction = json_data["data"]["transfer"]
                if not transaction:
                    account_display = json_data["data"]["account_display"]
                    source_address = [account_display["address"]]
                    call_module = json_data["data"]["call_module"]
                    destination_address = []
                    if call_module == "staking":
                        destination_address = ["staking"]
                    elif call_module == "utility":
                        destination_address = ["utility"]
                    quantity = '0'
                else:
                    source_address=[transaction["from"]]
                    destination_address=[transaction["to"]]
                    quantity = str(transaction["amount"])
                
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Polkadot')

    async def get_dogecoin_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/dogecoin/dashboards/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                transaction = rep_data["data"][tx_hash.lower()]["transaction"]
                value = transaction["output_total"]
                quantity = value / 100000000
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=transaction[["from"]],
                                        destination_address=[transaction["to"]],
                                        blokchain='Dogecoin')

    async def get_infura_data_from_ropsten(self, asset_id, tx_hash):
        source_url = "https://ropsten.infura.io/v3/741312b07a9a499eae9e7473fb6ba2e3"
        data = {
            "id": tx_hash,
            "jsonrpc": "2.0",
            "method": "eth_getTransactionByHash",
            "params": [tx_hash]
        }
        headers = {'Content-Type': 'application/json'}
        async with aiohttp.request(method='POST', url=source_url, headers=headers, json=data, proxy=self.proxy) as response:
            if response.status == 200:
                json_data = json.loads(await response.text())
                if "result" in json_data and json_data["result"] is None:
                    return None
                elif "error" in json_data:
                    return None
                else:
                    json_data["result"]
                    gas_price = result["value"]
                    quantity = str(int(gas_price, 16) / 1000000000000000000)
                    return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                            source_address=[result["from"]],
                                            destination_address=[result["to"]],
                                            blokchain='Ropsten')

    async def get_infura_data_from_ethereum(self, asset_id, tx_hash):
        source_url = "https://mainnet.infura.io/v3/741312b07a9a499eae9e7473fb6ba2e3"
        data = {
            "id": tx_hash,
            "jsonrpc": "2.0",
            "method": "eth_getTransactionByHash",
            "params": [tx_hash]
        }
        headers = {'Content-Type': 'application/json'}
        async with aiohttp.request(method='POST', url=source_url, headers=headers, json=data, proxy=self.proxy) as response:
            if response.status == 200:
                json_data = json.loads(await response.text())
                if "result" in json_data and json_data["result"] is None:
                    return None
                elif "error" in json_data:
                    return None
                else:
                    result = json_data["result"]
                    gas_price = result["value"]
                    quantity = str(int(gas_price, 16) / 1000000000000000000)
                    return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                            source_address=[result["from"]],
                                            destination_address=[result["to"]],
                                            blokchain='Ethereum')

    async def get_infura_data_from_near(self, asset_id, tx_hash):
        source_url = "https://near-mainnet.infura.io/v3/741312b07a9a499eae9e7473fb6ba2e3"
        data = {
            "id": tx_hash,
            "jsonrpc": "2.0",
            "method": "broadcast_tx_async",
            "params": [tx_hash]
        }
        headers = {'Content-Type': 'application/json'}
        async with aiohttp.request(method='POST', url=source_url, headers=headers, json=data, proxy=self.proxy) as response:
            if response.status == 200:
                json_data = json.loads(await response.text())
                if "result" in json_data and json_data["result"] is None:
                    return None
                elif "error" in json_data:
                    return None
                else:
                    result = json_data["result"]
                    gas_price = result["value"]
                    quantity = str(int(gas_price, 16) / 1000000000000000000)
                    return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                            source_address=[result["from"]],
                                            destination_address=[result["to"]],
                                            blokchain='Ethereum')

    async def get_biction_test_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/bitcoin/testnet/dashboards/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status == 404:
                return None

            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                hash_data = rep_data["data"][tx_hash.lower()]
                value = hash_data['transaction']["output_total"]
                quantity = str(value / 100000000)
                source_address = [f.get('recipient') for f in hash_data['inputs']]
                destination_address = [t.get('recipient') for t in hash_data['outputs']]
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Bitcoin Testnet')

    async def get_stellar_raw_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/stellar/raw/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash + "?operations=true", proxy=self.proxy) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if rep_data["data"] is None:
                    return None

                operations = rep_data["data"][tx_hash.lower()]["operations"]
                source_address = []
                destination_address = []
                quantity = 0
                for t in operations:
                    if t.get("source_account"):
                        source_address.append(t.get("source_account"))
                    if t.get("selling_asset_issuer"):
                        destination_address.append(t.get("selling_asset_issuer"))
                    if t.get("amount"):
                        quantity += float(t.get("amount"))

                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=str(quantity),
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Stellar')

    async def get_stellar_raw_data_from_horizon(self, asset_id, tx_hash):
        # 从 horizon.stellar.org 获取
        # 没有 quantity, destination_address 返回值
        source_url = "https://horizon.stellar.org/transactions/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity='0',
                                        source_address=[rep_data["source_account"]],
                                        destination_address=[],
                                        blokchain='Stellar')

    async def get_ripple_data(self, asset_id, tx_hash):
        source_url = "https://api.xrpscan.com/api/v1/tx/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                text = await response.text()
                if text == "Not found":
                    return None

                rep_data = json.loads(text)
                if rep_data is None:
                    return None

                quantity = str(rep_data["Amount"]["value"] / 1000000)
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=[rep_data["Account"]],
                                        destination_address=[rep_data["Destination"]],
                                        blokchain='Ripple')

    async def get_polkadot_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/polkadot/raw/extrinsic/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash + "?operations=true", proxy=self.proxy) as response:
            if response.status > 200:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if rep_data["data"] is None:
                    return None

                transaction = rep_data["data"][tx_hash.lower()][0]["transfers"]
                if not transaction:
                    return None

                quantity = 0
                source_address = []
                destination_address = []
                for t in transaction:
                    quantity += int(t["amount"]) / 10000000000
                    source_address.append(t["from"])
                    destination_address.append(t["to"])

                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Polkadot')

    async def get_dash_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/dash/dashboards/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status == 404:
                return None

            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                hash_data = rep_data["data"][tx_hash.lower()]
                value = hash_data['transaction']["output_total"]
                quantity = str(value / 100000000)
                source_address = [f.get('recipient') for f in hash_data['inputs']]
                destination_address = [t.get('recipient') for t in hash_data['outputs']]
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Dash')

    async def get_trx_data(self, asset_id, tx_hash):
        source_url = "https://api.trongrid.io/wallet/gettransactionbyid"
        payload = {
            "value": "1c4482647c0825e09b3f64ff8a2db78cdfa6cd45e068799f48061b1b62c9fd8c",
            "visible": True
        }
        headers = {
            "accept": "application/json",
            "content-type": "application/json"
        }
        async with aiohttp.request(method='POST', url=source_url, headers=headers, json=payload, proxy=self.proxy) as response:
            if response.status == 404:
                return None

            elif response.status == 200:
                rep_data = json.loads(await response.text())
                contract = rep_data["raw_data"]["contract"]
                source_address = []
                destination_address = []
                for c in contract:
                    value = c['parameter']['value']
                    quantity = str(value['amount'] / 1000000)
                    source_address.append(value['owner_address'])
                    destination_address.append(value['to_address'])
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='TRX')

    async def get_bitcoin_cash_data(self, asset_id, tx_hash):
        source_url = "https://api.blockchair.com/bitcoin-cash/dashboards/transaction/"
        async with aiohttp.request(method='GET', url=source_url + tx_hash, proxy=self.proxy) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if len(rep_data["data"]) == 0:
                    return None

                hash_data = rep_data["data"][tx_hash.lower()]
                value = hash_data['transaction']["output_total"]
                quantity = str(value / 100000000)
                source_address = [f.get('recipient') for f in hash_data['inputs']]
                destination_address = [t.get('recipient') for t in hash_data['outputs']]
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Bitcoin Cash')

    async def get_solana_data(self, asset_id, tx_hash):
        headers = {
            'authority': 'explorer-api.mainnet-beta.solana.com',
            'accept': '*/*',
            'accept-language': 'zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7',
            'content-type': 'application/json',
            'origin': 'https://explorer.solana.com',
            'referer': 'https://explorer.solana.com/',
            'sec-ch-ua': '"Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"macOS"',
            'sec-fetch-dest': 'empty',
            'sec-fetch-mode': 'cors',
            'sec-fetch-site': 'same-site',
            'solana-client': 'js/0.0.0-development',
            'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
        }
        uid = uuid.uuid4()
        json_data = {
            'method': 'getTransaction',
            'jsonrpc': '2.0',
            'params': [
                tx_hash,
                {
                    'encoding': 'jsonParsed',
                    'commitment': 'confirmed',
                    'maxSupportedTransactionVersion': 0,
                },
            ],
            'id': str(uid),
        }
        source_url = "https://explorer-api.mainnet-beta.solana.com/"
        async with aiohttp.request(method='POST', url=source_url, headers=headers, json=json_data) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                result = rep_data.get("result", {})
                transaction = result.get("transaction", {})
                message = transaction.get("message", {})
                instructions = message.get("instructions", [])
                source_address = []
                destination_address = []
                quantity = 0
                for i in instructions:
                    info = i["parsed"]["info"]
                    source = info.get("source", "")
                    destination = info.get("destination", "")
                    if source: source_address.append(source)
                    if destination: destination_address.append(destination)
                    lamports = info.get("lamports", "")
                    if lamports:
                        quantity += float(lamports) / 1000000000

                return self.return_data(tx_hash=tx_hash, asset_id=asset_id, quantity=str(quantity),
                                   source_address=source_address,
                                   destination_address=destination_address, blokchain="SOLANA")

    async def get_alchemy_data(self, asset_id, tx_hash):
        source_url = "https://polygon-mainnet.g.alchemy.com/v2/seIJXo-FWhL3gc6vteGi1i5BdPw-mte1"
        json_data = {
                    'id': 1,
                    'jsonrpc': '2.0',
                    'params': [tx_hash],
                    'method': 'eth_getTransactionByHash'
                }
        headers = {
                    "accept": "application/json",
                    "content-type": "application/json"
                }
        async with aiohttp.request(method='POST', url=source_url, headers=headers, json=json_data) as response:
            if response.status == 404:
                return None
            elif response.status == 200:
                rep_data = json.loads(await response.text())
                if not rep_data.get("result", None):
                    return None

                value = rep_data["result"]["value"]
                quantity = str(int(value, 16) / 1000000000000000000)
                source_address = [rep_data["result"]["from"]]
                destination_address = [rep_data["result"]["to"]]
                return self.return_data(asset_id=asset_id, tx_hash=tx_hash, quantity=quantity,
                                        source_address=source_address,
                                        destination_address=destination_address,
                                        blokchain='Alchemy')

    def return_one_data(self, transaction_res, asset_id, tx_hash):
        if not transaction_res:
            return self.return_error(asset_id=asset_id, tx_hash=tx_hash)

        json_data = json.loads(MessageToJson(transaction_res[0][0]))
        if "quantity" in json_data:
            return [transaction_res[0][0]], []

        return self.return_error(asset_id=asset_id, tx_hash=tx_hash)

    def async_get_transcation(self, asset_id, tx_hash, source_url='', dev=False):
        new_loop = asyncio.new_event_loop()
        asyncio.set_event_loop(new_loop)
        loop = asyncio.get_event_loop()

        try:
            if source_url == '':  # 如果没有指定查询源，则查询全部源
                if dev:
                    tasks = [
                        loop.create_task(self.get_biction_test_data(asset_id, tx_hash)),
                        loop.create_task(self.get_westend_data(asset_id, tx_hash)),
                        loop.create_task(self.get_ethereum_test_data(asset_id, tx_hash)),
                        loop.create_task(self.get_infura_data_from_ropsten(asset_id, tx_hash)),
                    ]
                else:
                    tasks = [
                        loop.create_task(self.get_biction_data(asset_id, tx_hash)),
                        loop.create_task(self.get_ethereum_data(asset_id, tx_hash)),
                        loop.create_task(self.get_cardano_data(asset_id, tx_hash)),
                        loop.create_task(self.get_litecoin_data(asset_id, tx_hash)),
                        loop.create_task(self.get_infura_data_from_ethereum(asset_id, tx_hash)),
                        loop.create_task(self.get_infura_data_from_near(asset_id, tx_hash)),
                        loop.create_task(self.get_stellar_raw_data(asset_id, tx_hash)),
                        loop.create_task(self.get_stellar_raw_data_from_horizon(asset_id, tx_hash)),
                        loop.create_task(self.get_ripple_data(asset_id, tx_hash)),
                        loop.create_task(self.get_polkadot_data_from_subscan(asset_id, tx_hash)),
                        loop.create_task(self.get_polkadot_data(asset_id, tx_hash)),
                        loop.create_task(self.get_bitcoin_cash_data(asset_id, tx_hash)),
                        loop.create_task(self.get_dash_data(asset_id, tx_hash)),
                        loop.create_task(self.get_trx_data(asset_id, tx_hash)),
                        loop.create_task(self.get_solana_data(asset_id, tx_hash)),
                        loop.create_task(self.get_alchemy_data(asset_id, tx_hash))
                    ]
                future = asyncio.gather(*tasks)
                transaction_res = loop.run_until_complete(future)
                for res in transaction_res:
                    if res is None:
                        continue

                    json_data = json.loads(MessageToJson(res[0][0]))
                    if "quantity" in json_data:
                        return res[0], []
                return self.return_error(asset_id=asset_id, tx_hash=tx_hash)

            if 'https://polkadot.webapi.subscan.io/api/scan/extrinsic' in source_url:
                transaction_res = loop.run_until_complete(self.get_polkadot_data_from_subscan(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            if "api.blockchair.com/bitcoin/dashboards/" in source_url:
                transaction_res = loop.run_until_complete(self.get_biction_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "api.blockchair.com/ethereum/" in source_url:
                transaction_res = loop.run_until_complete(self.get_ethereum_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "api.blockchair.com/cardano/" in source_url:
                transaction_res = loop.run_until_complete(self.get_cardano_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "api.blockchair.com/litecoin/" in source_url:
                transaction_res = loop.run_until_complete(self.get_litecoin_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "westend.webapi.subscan.io" in source_url:
                transaction_res = loop.run_until_complete(self.get_westend_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "ropsten.infura.io/v3" in source_url:
                transaction_res = loop.run_until_complete(self.get_infura_data_from_ropsten(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "api.blockchair.com/bitcoin/testnet" in source_url:
                transaction_res = loop.run_until_complete(self.get_biction_test_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "api.blockchair.com/stellar/raw/transaction/" in source_url:
                transaction_res = loop.run_until_complete(self.get_stellar_raw_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "api.blockchair.com/ripple/raw/transaction/" in source_url:
                transaction_res = loop.run_until_complete(self.get_ripple_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "api.blockchair.com/polkadot/raw/extrinsic/" in source_url:
                transaction_res = loop.run_until_complete(self.get_polkadot_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "api.blockchair.com/bitcoin-cash/dashboards/transaction/" in source_url or \
                    "api.blockchair.com/ethereum/testnet/" in source_url:
                transaction_res = loop.run_until_complete(self.get_bitcoin_cash_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)

            elif "explorer-api.mainnet-beta.solana.com" in source_url:
                transaction_res = loop.run_until_complete(self.get_solana_data(asset_id, tx_hash))
                return self.return_one_data(transaction_res, asset_id, tx_hash)
        except Exception:
            traceback.print_exc()
            loop.close()

        return self.return_error(asset_id=asset_id, tx_hash=tx_hash)


if __name__ == '__main__':
    import time

    print("started ")
    s_time = time.time()
    transaction = GetTransactionByTxHash()
    # transaction.proxy = "http://127.0.0.1:7890"

    # # ETH
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="ETH",
    #     tx_hash="0xe1cecd67758eb0f6ce7b690eb821dffcc4a538b03da2ec47f32ca2bc29b2d451")
    # print(result)
    # print(error_message)
    # print("runtime : ", time.time() - s_time)
    # print("finished ")

    # # XLM
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="XLM",
    #     tx_hash="e1e7a93ee5a519644df499df5d9173e019d9da3a2b59db026715bd90264e5a04")
    # print(result)
    # print(error_message)

    # # XRP
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="XRP",
    #     tx_hash="71991B600519C0DAC61F0530597B62AB8AEECF00F720971F046F1DB0705021E3")
    # print(result)
    # print(error_message)

    # # DOT
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="DOT",
    #     tx_hash="0x47c64915522458cc4b54131b1a23b380ac3c90606f4c9a9e3270bc6a7cd7d632")
    # print(result)
    # print(error_message)

    # # DOT
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="DOT",
    #     tx_hash="0x8a443930535247e3fd8065bfb8039636c894b30aba50d3cbbb1af061958407e9",
    #     source_url='https://polkadot.webapi.subscan.io/api/scan/extrinsic')
    # print(result)
    # print(error_message)

    # # LUNA
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="LUNA",
    #     tx_hash="34777F7125350C9C902B2DA21ABC5B63213F772D01E870D934CAE20BFA878BFD",
    #     source_url='https://polkadot.webapi.subscan.io/api/scan/extrinsic')
    # print(result)
    # print(error_message)

    # # WND
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="WND",
    #     tx_hash="0x3f6435951fb6e7563507121ef13cbd9b345d15ba6971f4d95e1e025985bb4b93",
    #     dev=True)
    # print(result)
    # print(error_message)

    # # DOGE
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="DOGE",
    #     tx_hash="5c05c716e512d1d1a507167320447f27489296e6117285d9df4aff4c5ea95440")
    # print(result)
    # print(error_message)

    # # BTC
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="BTC",
    #     tx_hash="5a486465973153b3ed2f9e74dda5b14c09c623b4c1b4d607bb864596435f098d")
    # print(result)
    # print(error_message)

    # # LTC
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="LTC",
    #     tx_hash="1ed334137bae3270f30ecbac0d3e69bd805642e9c3b09c50cde725dcef8344b8")
    # print(result)
    # print(error_message)

    # # DASH
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="DASH",
    #     tx_hash="49596523da9cac82f3ef1d99c841777f3f7fa16d720b61f725efab8b9f69426b")
    # print(result)
    # print(error_message)

    # # NEAR
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="NEAR",
    #     tx_hash="7LKP9gsGXQfWjdfqSAiEePjNvYbZa6XSqu3tkQdFuq1u")
    # print(result)
    # print(error_message)

    # # USDC
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="USDC",
    #     tx_hash="0x0ae1f6cb7698977cc52e875b8ca2b3246bebcea573e055f16c3792f2e3b22a04")
    # print(result)
    # print(error_message)

    # # USDT_ERC20
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="USDT_ERC20",
    #     tx_hash="0xb3d4c578bc46008be976768822bdea3e9c14c40980b26e0db748d546a05048d5")
    # print(result)
    # print(error_message)

    # # GOLD
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="GOLD",
    #     tx_hash="0xeefb395334f86a9fed563ec77b2166682e8b35ff07cc1a81f013c37a50bf958b")
    # print(result)
    # print(error_message)

    # # SILV
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="SILV",
    #     tx_hash="0xc3a0a22c883edb88dbf87495b527c798d06ba92d0b64bf96cd7180a03d9ced15")
    # print(result)
    # print(error_message)

    # # ADA
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="ADA",
    #     tx_hash="36a3d1f5794789c80333d5d28cd96dc6ec354accda09987b4aeb62a55f521353")
    # print(result)
    # print(error_message)

    # # TRX
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="TRX",
    #     tx_hash="1c4482647c0825e09b3f64ff8a2db78cdfa6cd45e068799f48061b1b62c9fd8c")
    # print(result)
    # print(error_message)

    # # TRX_USDT_S2UZ
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="TRX_USDT_S2UZ",
    #     tx_hash="76c4690c60215e2b856be9a6ba73244857185309333227018c924dcddcfd3208")
    # print(result)
    # print(error_message)

    # # USDT_ERC20
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="USDT_ERC20",
    #     tx_hash="0x47a27b49f733434fe1d99375a23bd33c7e978fbecd03ce32cd6258712550a410")
    # print(result)

    # # SOL
    # result, error_message = transaction.async_get_transcation(
    #     asset_id="SOL",
    #     tx_hash="5ZaRy9ocafC4sUmChhp85yrR4zzeeXVcMhDNivZBPVWgxfCh1H2ZtocHc4FVZFsjfZxkPyqpLmFW6V8kZ6TJgjGJ"
    # )
    # print(result)
    # print(error_message)

    # Alchemy
    result, error_message = transaction.async_get_transcation(
        asset_id="Alchemy",
        tx_hash="0x3f19b04404bd87040ec83a0620d7e44cf7bf805750851a9e26608f19c351b5cc"
    )
    print(result)
    print(error_message)

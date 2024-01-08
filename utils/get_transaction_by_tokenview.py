import os
import sys
import requests
import uuid

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import otc_pb2


apikey = "5zaZqYI8KiGqBKFlXTwY"


def return_data(tx_hash, asset_id, quantity='', source_address=[], destination_address=[], blokchain=''):
    result = [otc_pb2.ResultV1(
        tx_hash=tx_hash,
        asset_id=asset_id,
        quantity=str(quantity),
        source_address=list(set(source_address)),
        destination_address=list(set(destination_address)),
        blokchain=blokchain)]
    return result, []


def GetTransactionByTxHashFromETH(asset_id, tx_hash):
    """从 tokenview 获取 ETH 链的数据"""
    url = f"https://services.tokenview.io/vipapi/tx/eth/{tx_hash}?apikey={apikey}"
    payload={}
    headers = {}
    proxy = {"https": "http://127.0.0.1:7890"}
    response = requests.request("GET", url, proxies=proxy, headers=headers, data=payload)
    hash_data = response.json()
    data = hash_data["data"]
    print({"source_address": data["from"], "destination_address": data["to"], "quantity": data["value"], 
            "blokchain": data["network"], "asset_id": asset_id})

    return_data(tx_hash=tx_hash, asset_id=asset_id, quantity=data["value"], source_address=data["from"],
                destination_address=data["to"], blokchain=data["network"])


def get_transaction_by_tx_hash_from_trx(asset_id, tx_hash):
    """从 tokenview 获取 TRX 链的数据"""
    url = f"https://services.tokenview.io/vipapi/tx/trx/{tx_hash}?apikey={apikey}"
    payload = {}
    headers = {}
    proxy = {"https": "http://127.0.0.1:7890"}
    response = requests.request("GET", url, proxies=proxy, headers=headers, data=payload)
    print(response.text)
    hash_data = response.json()
    data = hash_data["data"]

    token_transfer = data.get("tokenTransfer", [])
    source_address = []
    destination_address = []
    if token_transfer:
        for txn in token_transfer:
            source_address.append(txn["from"])
            destination_address.append(txn["to"])

        print({"source_address": source_address, "destination_address": destination_address, "quantity": data["value"],
               "blokchain": data["network"], "asset_id": asset_id})
        return return_data(tx_hash=tx_hash, asset_id=asset_id, quantity=data["value"], source_address=source_address,
                           destination_address=destination_address, blokchain=data["network"])
    else:
        print({"source_address": data["from"], "destination_address": data["to"], "quantity": data["value"],
                "blokchain": data["network"], "asset_id": asset_id})

        return return_data(tx_hash=tx_hash, asset_id=asset_id, quantity=data["value"], source_address=[data["from"]],
                    destination_address=[data["to"]], blokchain=data["network"])


def get_transaction_by_tx_hash_from_ltc(asset_id, tx_hash):
    """从 tokenview 获取 TRX 链的数据"""
    url = f"https://services.tokenview.io/vipapi/tx/ltc/{tx_hash}?apikey={apikey}"
    payload = {}
    headers = {}
    proxy = {"https": "http://127.0.0.1:7890"}
    response = requests.request("GET", url, proxies=proxy, headers=headers, data=payload)
    hash_data = response.json()

    data = hash_data["data"]
    inputs = data["inputs"]
    source_address_list = []
    outputs = data["outputs"]
    destin_address = []
    quantity = 0

    for input in inputs:
        source_address_list.append(input["address"])
        quantity += float(input["value"])
    for out in outputs:
        destin_address.append(out["address"])

    print({"source_address": source_address_list, "destination_address": destin_address, "quantity": quantity,
            "blokchain": data["network"], "asset_id": asset_id})

    return return_data(tx_hash=tx_hash, asset_id=asset_id, quantity=str(quantity), source_address=source_address_list,
                destination_address=destin_address, blokchain=data["network"])


def get_transaction_by_tx_hash_from_sol(asset_id, tx_hash):
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

    response = requests.post('https://explorer-api.mainnet-beta.solana.com/', headers=headers, json=json_data)
    hash_data = response.json()
    result = hash_data.get("result", {})
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

    print({"source_address": source_address, "destination_address": destination_address, "quantity": quantity,
           "blokchain": "SOLANA", "asset_id": asset_id})

    return return_data(tx_hash=tx_hash, asset_id=asset_id, quantity=str(quantity), source_address=source_address,
                       destination_address=destination_address, blokchain="SOLANA")


if __name__ == '__main__':
    get_transaction_by_tx_hash_from_sol("SOL","572kqxxu7EjFPys9xU7be5bcuAbsniZk5TynsaKpxrFd3pzDxtZdS82pVKrbvUzswMvPGiQJbsU4jewVnrQPcDV1")
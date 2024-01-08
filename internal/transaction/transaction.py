"""
transaction相关的业务逻辑
"""
import os
import json
import decimal
import time
import uuid
from datetime import datetime
import copy
import asyncio
import pathlib
import sys
import traceback

sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))

from fireblocks_sdk import VAULT_ACCOUNT, EXTERNAL_WALLET, TransferPeerPath
from google.protobuf.json_format import MessageToJson, MessageToDict

import grpc
import zerocap_market_data_pb2
import zerocap_market_data_pb2_grpc
import exec_pb2
import admin_pb2_grpc

from config.config import config
from db.models import db, FeeTypeEnum, TreasuryStatusEnum, FeeNotionalEnum
from db_api.users_api import query_tenant_by_user_id
from internal.rfq.data_helper import get_kyc_and_pa_and_name_by_account
from internal.transaction.data_helper import get_withdrawal, update_withdrawal, get_transactions_by_txn_alias, \
    create_transaction, update_transaction, get_treasury, insert_treasury, update_treasury, \
    get_email_entity_id_by_user_id, check_address, check_is_portal_support_asset, check_txn_amount, \
    handle_fiat_and_cannot_transfer, handle_no_fiat_and_cannot_transfer, check_payment_parameter, \
    check_settle_check_parameter, add_deposit, add_withdrawal, get_txn_data_by_tx_id, \
    update_yields_pending_rejected, update_deposit_by_tx_id, get_deposit, \
    update_withdrawal_by_tx_id, get_pending_quantity_by_txn_alias, create_yieldspending, query_interwallet_by_wallet_id, \
    update_deposit, handle_blotter, get_transactions_by_alias, whether_repeatedly_payment, get_deposit_by_tx_id, \
    get_withdrawals_by_tx_id, update_quotes_transaction_by_txn_alias, query_transaction_by_txn_alias, get_receipt_data, \
    update_fill_by_alias

from internal.wallet.data_helper import get_wallet_pool_by_user_id_and_asset_id
from internal.yield_manager import yield_manager
from external_api.fireblocks.fireblocks_gateway import fireblocks_gateway
from utils.calc import Calc
from utils.dict_utils import ObjDict
from utils.consts import StatusRejected, StatusCancelled, StatusFailed, StatusBlocked, StatusCompleted, StatusPending, \
    DefaultWorkspace, ResponseStatusSuccessful, StatusApproved, EntityVesper, EntityZerocap, \
    StatusSuccess, TRXAssets, PendingIncrease, PendingDecrease, USDTChain, BSCAssets
from utils.date_time_utils import iso8601, timer
from utils.logger import logger
from utils.zc_exception import ZCException
from utils.get_transaction import GetTransactionByTxHash
from utils.log_utils import LogDecorator

from db_api.asset_api import get_asset_source_url, get_asset_fb_id, is_fiat_asset, check_asset_is_main_or_altion
from db_api.account_api import query_workspace_by_account_id_vault_id
from db_api.fb_support_asset_api import does_it_exist_from_fb
from db_api.balance_api import query_balances_by_account_id, get_balance_by_account_id_and_asset


@timer
def check_to_portal(request):
    """
    :param request:
    :return:
    check_result: 1, 2, 3
    """
    result_ok = 1
    result_address_error = 2
    result_balance_error = 3
    check_result = result_ok  # 初始状态表示检查通过
    address = ""
    external_wallet_id = ""
    try:
        asset_map = {value: key for key, value in config.get('CONFIG_ASSET').get('ASSET_MAPPING').items()}
        asset_id = asset_map.get(request.asset_id, request.asset_id)
        # 检查是不是 fb 支持的币种
        if not does_it_exist_from_fb(asset_id):
            error_message = f"The asset '{asset_id}' is not supported by Fireblocks, please check the supported assets endpoint."
            raise ZCException(error_message)

        quantity = request.quantity
        workspace = request.workspace
        if not workspace:
            workspace = DefaultWorkspace
        # vault = get_vault_by_user_id(user_id)
        vault_id = request.vault_id
        account_id = request.account_id
        if not vault_id or not account_id:
            raise ZCException("parameter cannot be empty")
        # 根据 account_id、vault_id、asset_id 查询 externalwalletproptrading 表
        wallets = get_wallet_pool_by_user_id_and_asset_id(asset_id=asset_id,
                                                          vault_id=vault_id,
                                                          account_id=account_id,
                                                          workspace=workspace)
        if wallets is None:
            check_result = result_address_error
            external_wallet_dic = yield_manager.add_address(account_id, asset_id, vault_id, workspace)
            if external_wallet_dic:
                address = external_wallet_dic["address"]
                external_wallet_id = external_wallet_dic["external_wallet_id"]
            return dict(status=ResponseStatusSuccessful,
                        check_result=check_result, address=address,
                        external_wallet_id=external_wallet_id)
        address = wallets[0]["address"]
        external_wallet_id = wallets[0]["external_wallet_id"]
        if wallets[0]["status"] != StatusApproved:
            check_result = result_address_error  # 地址检查不通过
            return dict(status=ResponseStatusSuccessful,
                        check_result=check_result, address=address,
                        external_wallet_id=external_wallet_id)
        all_vault = fireblocks_gateway.get_all_vault(vault_id, account_id)
        for asset in all_vault["assets"]:
            if asset["id"] == asset_id and asset.get("address", "") == wallets[0]["address"]:
                source = TransferPeerPath(VAULT_ACCOUNT, vault_id)
                destination = TransferPeerPath(EXTERNAL_WALLET, external_wallet_id)
                fee = fireblocks_gateway.get_transaction_estimate_fee(asset_id, quantity, source, destination, account_id, vault_id)
                if Calc(quantity) + Calc(fee["medium"]["networkFee"]) > Calc(asset["balance"]).value:
                    check_result = result_balance_error
                break

        return dict(status=ResponseStatusSuccessful,
                    check_result=check_result, address=address,
                    external_wallet_id=external_wallet_id)
    except Exception as e:
        if '"code":1034' in e.__str__():
            check_result = result_address_error
            return dict(status=ResponseStatusSuccessful,
                        check_result=check_result, address=address,
                        external_wallet_id=external_wallet_id)
        if '"code":1905' in e.__str__():
            check_result = result_balance_error
            return dict(status=ResponseStatusSuccessful,
                        check_result=check_result, address=address,
                        external_wallet_id=external_wallet_id)
        if isinstance(e, ZCException):
            raise e
        raise ZCException(str(e))


@timer
def create_transaction_and_update_withdrawals(request):
    """
    :param request:
    :return:
    """
    update_withdrawal(request.withdrawal_alias, {"status": StatusPending})
    result = check_to_portal(request)
    if result.get('status') != ResponseStatusSuccessful or result.get('check_result') == 2:  # status为3余额不足也会发起转账
        return ""
    #  转账时将正式币转为测试币（ config中ASSET_MAPPING key是测试币，value是正式币 ）
    asset_map = {value: key for key, value in config['CONFIG_ASSET']['ASSET_MAPPING'].items()}
    asset_id = asset_map.get(request.asset_id, request.asset_id)
    quantity = request.quantity
    withdrawal_alias = request.withdrawal_alias
    external_wallet_id = result.get('external_wallet_id')
    address = result.get('address')
    account_id = request.account_id
    # vault = get_vault_by_user_id(user_id)
    transactions = get_transactions_by_txn_alias(request.txn_alias)
    entity = transactions.get('entity', '').lower()
    if entity == EntityVesper:
        vault_id = config["ZEROCAP_OTC_MAPPING"]["vesper"]["vault_id"]
        workspace = config["ZEROCAP_OTC_MAPPING"]["vesper"]["workspace"]
    elif entity == EntityZerocap:
        vault_id = config["ZEROCAP_OTC_MAPPING"]["zerocap"]["vault_id"]
        workspace = config["ZEROCAP_OTC_MAPPING"]["zerocap"]["workspace"]
    else:
        raise ZCException("transactions entity error")

    if not workspace or not vault_id:
        raise ZCException("workspace error or vault_id error")

    note = f"otc_deposit|{withdrawal_alias}|{account_id}|{request.vault_id}"
    source = TransferPeerPath(VAULT_ACCOUNT, vault_id)
    destination = TransferPeerPath(EXTERNAL_WALLET, external_wallet_id)
    fireblocks_gateway.workspace_base = workspace
    fb_client = fireblocks_gateway.fireblock_client(workspace=workspace)
    trace_id = request.trace_id
    logger.info(
        {
            'type': 'info_record',
            'trace_id': trace_id,
            'func': 'create_transaction_and_update_withdrawals',
            'message': 'create_transaction_info',
            'info': {
                'asset_id': asset_id,
                'uantity': float(quantity),
                'source_vault_id': vault_id,
                'destination_external_wallet_id': external_wallet_id,
                'note': note,
                'account_id': account_id
            }
        }
    )
    result = fireblocks_gateway.create_transaction(asset_id,
                                                   float(quantity),
                                                   source,
                                                   destination,
                                                   note=note,
                                                   account_id=request.account_id,
                                                   vault_id=request.vault_id,
                                                   treat_as_gross_amount=True,
                                                   fb_client=fb_client)
    if result.get("id", None):
        tx_id = result["id"]
        update_data = {"tx_id": tx_id, "status": "pending"}
        update_withdrawal(withdrawal_alias, update_data)
        timestamp = int(time.time() * 1000)
        token = str(uuid.uuid1())

        email, entity_id = get_email_entity_id_by_user_id(request.user_id)
        transaction_dic = {
            'user_id': email,
            'tx_id': tx_id,
            'tx_hash': '',
            'source_id': vault_id,
            'source_type': 'VAULT_ACCOUNT',
            'destination_type': 'EXTERNAL_WALLET',
            'destination_id': external_wallet_id,
            'destination_address': address,
            'asset_id': asset_id,
            'amount': quantity,
            'created_at': timestamp,
            'last_updated': timestamp,
            'datetime': iso8601(timestamp),
            'token': token,
            'type': 'withdrawal_confirmation',
            'operation': 'TRANSFER',
            'status': result["status"],
            'note': note,
            'vault_id': request.vault_id,
            'email': email,
            'entity_id': entity_id
        }
        create_transaction(transaction_dic)
        return tx_id


def create_ems_transaction(request):
    """
    :param request:
    :return:
    """
    trace_id = request.trace_id
    user_id = request.user_id
    account_id = request.account_id
    vault_id = request.vault_id
    withdrawal_alias = request.withdrawal_alias
    withdrawal = None
    if withdrawal_alias:
        withdrawal, _ = get_withdrawal(withdrawal_alias=withdrawal_alias)
    if withdrawal and withdrawal[0]["tx_id"]:
        # 有tx_id则表示以前发起过转账 判断转账状态
        tx_id = withdrawal[0]["tx_id"]
        transaction_info = fireblocks_gateway.get_transaction(tx_id=tx_id, account_id=account_id, vault_id=vault_id)
        logger.info({
            'type': 'info_record',
            'trace_id': trace_id,
            'func': 'create_ems_transaction',
            'message': 'current_transaction_info',
            'info': transaction_info
        })
        if transaction_info.get("status", "") in [StatusRejected, StatusCancelled, StatusBlocked,
                                                  StatusFailed]:  # 转账失败
            tx_id = create_transaction_and_update_withdrawals(request)
            if tx_id:
                return dict(status=ResponseStatusSuccessful,
                            user_id=user_id,
                            tx_id=tx_id)
        elif transaction_info.get("status", "") == StatusCompleted:
            # 转账完成
            update_withdrawal(withdrawal_alias, {"status": StatusSuccess})  # 回写覆盖 withdraws  表 status 为 success
            update_transaction(tx_id, {"status": StatusCompleted})  # 更新transactionhistory status 为COMPLETED
            return dict(status=ResponseStatusSuccessful, user_id=user_id,
                        tx_id=tx_id)
        else:
            # 订单正在进行中(取消上一个交易，重新发起交易，并回写覆盖withdraws 表tx_id)
            fireblocks_gateway.cancel_transaction(tx_id, account_id=account_id, vault_id=vault_id)  # 取消上一个交易
            tx_id = create_transaction_and_update_withdrawals(request)
            if tx_id:
                return dict(status=ResponseStatusSuccessful,
                            tx_id=tx_id)
    else:  # 没有tx_id则直接发起转账
        tx_id = create_transaction_and_update_withdrawals(request)
        if tx_id:
            return dict(status=ResponseStatusSuccessful,
                        tx_id=tx_id)

    raise ZCException("Failed to create_transaction_and_update_withdrawals(not get tx_id).")


@timer
def get_treasury_list(request):
    """展示treasury"""
    # 获取参数
    user_id = request.user_id
    trader = request.trader
    asset_id = request.asset_id
    date_start = request.date_start
    date_end = request.date_end
    treasury_alias = request.treasury_alias
    account_id = request.account_id

    if request.fee_type == "separate":
        fee_type = FeeTypeEnum.Separate
    elif request.fee_type == "included":
        fee_type = FeeTypeEnum.Included
    else:
        fee_type = request.fee_type
    if request.status == "pending":
        status = TreasuryStatusEnum.Pending
    elif request.status == "completed":
        status = TreasuryStatusEnum.Completed
    else:
        status = request.status

    page = int(request.page)
    limit = int(request.limit)
    treasury, total = get_treasury(user_id=user_id, trader=trader, asset_id=asset_id, date_start=date_start,
                                   date_end=date_end, page=page, limit=limit, fee_type=fee_type, status=status,
                                   treasury_alias=treasury_alias, account_id=account_id)
    message = "" if treasury else "No Treasury Fits"
    return dict(status=ResponseStatusSuccessful, message=message, treasury=treasury, total=total)


@timer
def add_treasury(request):
    """
    新增一条treasury
    :param request:
    :return:
    """
    fee_type = request.fee_type
    user_id = request.user_id
    fee_notional = request.fee_notional
    created_at = int(request.created_at)
    treasury_alias = str(uuid.uuid1())
    account_id = request.account_id
    destination_address = request.destination_address

    # 校验参数
    if not user_id:
        raise ZCException("UserId is None")
    # 检查是否是正数字符串
    check_params_is_number_and_greater_then_zero(request.amount, request.fee)
    if request.amount == "0":
        raise ZCException("param amount must greater than zero")

    if not request.entity or request.entity not in [EntityVesper, EntityZerocap]:
        raise ZCException("wrong entity")

    if request.asset_id not in ['AUD', 'EUR', 'GBP', 'USD', 'CAD', 'NZD']:
        # 不是六种法币情况下,如果tx_hash为空,status必须是pending
        if not request.tx_hash and request.status not in ["pending"]:
            raise ZCException("if not tx_hash, status must to be pending")
        # 不是六种法币,destination_address不能为空
        if not destination_address:
            raise ZCException("destination_address is None")

    if request.status == "pending":
        status = TreasuryStatusEnum.Pending
    elif request.status == "completed":
        status = TreasuryStatusEnum.Completed
    elif request.status == "deleted":
        status = TreasuryStatusEnum.Deleted
    else:
        raise ZCException("wrong status")

    fee = decimal.Decimal(request.fee)
    amount = decimal.Decimal(request.amount)

    # 计算 fee_amount, total  当选择USDT或者USDC时， fee_notional固定为base
    fee_amount, total, amount = compute_fee_amount_and_total(fee_notional, amount, fee, fee_type)

    add_date = datetime.utcnow()
    # updated_at在创建时候等于created_at是业务输入时间。
    updated_at = created_at

    # 构建treasury
    treasury = {
        "treasury_alias": treasury_alias,
        "user_id": user_id,
        "asset_id": request.asset_id,
        "amount": str(amount),
        "fee": fee,
        "fee_type": FeeTypeEnum.Separate if fee_type == "separate" else FeeTypeEnum.Included,
        "total": total,
        "fee_notional": FeeNotionalEnum.Bps if fee_notional == "bps" else FeeNotionalEnum.Base,
        "tx_hash": request.tx_hash,
        "destination_address": request.destination_address,
        "trader_identifier": request.trader_identifier,
        "status": status,
        "fee_amount": fee_amount,
        "created_at": created_at,
        "add_date": add_date,
        "updated_at": updated_at,
        "notes": request.notes,
        "vault_id": request.vault_id,
        "account_id": account_id,
        "entity": request.entity,
        "settlement_destination": request.settlement_destination
    }
    try:
        treasury_id = insert_treasury(treasury)
        treasury.update({"id": str(treasury_id), "fee_type": fee_type,
                         "fee_notional": fee_notional, "status": request.status, "add_date": str(add_date),
                         "fee": request.fee, "total": str(total),
                         "fee_amount": str(fee_amount), "created_at": request.created_at,
                         "updated_at": str(updated_at), "entity": request.entity})
        logger.info(f"insert_treasury_success, treasury_id: {treasury_id}, treasury_alias: {treasury_alias}")
        receipt_status = gen_treasury_trader_receipt(treasury)

        # 调用blotter函数
        request_dict = {"new_alias": treasury_alias, "old_alias": "", "blotter_type": "treasury"}
        blotter(ObjDict(request_dict))
        if receipt_status != "success":
            logger.error(f"gen_treasury_trader_receipt_error: {receipt_status}")
            return dict(status=ResponseStatusSuccessful,
                        message="create_treasury_success, but gen_treasury_trader_receipt_error", treasury=treasury)
        return dict(status=ResponseStatusSuccessful, message="create_treasury_success", treasury=treasury)
    except Exception as err:
        logger.error("insert_treasury_error", exc_info=True)
        raise err


@timer
def edit_treasury(request):
    """
    修改treasury
    :param request:
    :return:
    """
    fee_type = request.fee_type
    user_id = request.user_id
    fee_notional = request.fee_notional
    created_at = int(request.created_at)
    old_treasury_alias = request.treasury_alias
    new_treasury_alias = str(uuid.uuid1())
    account_id = request.account_id
    destination_address = request.destination_address

    # 校验参数
    if request.asset_id not in ['AUD', 'EUR', 'GBP', 'USD', 'CAD', 'NZD'] and request.status != "deleted":
        # 不是六种法币情况下,如果tx_hash为空,status必须是pending
        if not request.tx_hash and request.status not in ["pending"]:
            raise ZCException("if not tx_hash, status must to be pending")
        # 不是六种法币,destination_address不能为空
        if not destination_address:
            raise ZCException("destination_address is None")

    if not request.entity or request.entity not in [EntityVesper, EntityZerocap]:
        raise ZCException("wrong entity")

    if request.status == "pending":
        status = TreasuryStatusEnum.Pending
    elif request.status == "completed":
        status = TreasuryStatusEnum.Completed
    elif request.status == "deleted":
        status = TreasuryStatusEnum.Deleted
    else:
        raise ZCException("wrong status")

    if not user_id:
        raise ZCException("UserId is None")

    # 检查是否是正数字符串
    check_params_is_number_and_greater_then_zero(request.amount, request.fee, request.total)
    if request.amount == "0":
        raise ZCException("param amount must greater than zero")
    if request.total == "0":
        raise ZCException("param total must greater than zero")
    fee = decimal.Decimal(request.fee)
    amount = decimal.Decimal(request.amount)
    total = decimal.Decimal(request.total)

    if fee_type == "separate":
        # 计算 fee_amount, total  当选择USDT或者USDC时， fee_notional固定为base
        fee_amount, total, amount = compute_fee_amount_and_total(fee_notional, amount, fee, fee_type)
    else:
        amount, fee_amount = compute_amount_fee_amount_by_total(total, fee, fee_notional)

    updated_at = int(datetime.utcnow().timestamp())*1000
    add_date = datetime.utcnow()

    # 构建treasury
    treasury = {
        "user_id": user_id,
        "asset_id": request.asset_id,
        "amount": str(amount),
        "fee": fee,
        "fee_type": FeeTypeEnum.Separate if fee_type == "separate" else FeeTypeEnum.Included,
        "total": total,
        "fee_notional": FeeNotionalEnum.Bps if fee_notional == "bps" else FeeNotionalEnum.Base,
        "tx_hash": request.tx_hash,
        "destination_address": request.destination_address,
        "trader_identifier": request.trader_identifier,
        "status": status,
        "fee_amount": fee_amount,
        "created_at": created_at,
        "updated_at": updated_at,
        "notes": request.notes,
        "treasury_alias": new_treasury_alias,
        "add_date": add_date,
        "vault_id": request.vault_id,
        "account_id": account_id,
        "entity": request.entity,
        "settlement_destination": request.settlement_destination
    }
    try:
        treasury_id = update_treasury(treasury, old_treasury_alias)
        treasury.update(
            {"fee_type": fee_type, "fee_notional": fee_notional, "status": request.status,
             "fee": request.fee, "total": str(total),
             "fee_amount": str(fee_amount), "created_at": request.created_at, "updated_at": str(updated_at),
             "id": str(treasury_id), "add_date": str(add_date), "entity": request.entity})
        logger.info(f"update_treasury_success, treasury_alias: {request.treasury_alias}")
        if status != TreasuryStatusEnum.Deleted:
            receipt_status = gen_treasury_trader_receipt(treasury)
            # 调用blotter函数
            request_dict = {"new_alias": new_treasury_alias, "old_alias": old_treasury_alias,
                            "blotter_type": "treasury"}
            blotter(ObjDict(request_dict))
            if receipt_status != "success":
                logger.error(f"gen_treasury_trader_receipt_error: {receipt_status}")
                return dict(status=ResponseStatusSuccessful,
                            message="update_treasury_success, but gen_treasury_trader_receipt_error", treasury=treasury)

        else:
            # 调用blotter函数
            request_dict = {"new_alias": old_treasury_alias, "old_alias": old_treasury_alias, "blotter_type": "treasury"}
            blotter(ObjDict(request_dict))

        return dict(status=ResponseStatusSuccessful, message="update_treasury_success", treasury=treasury)
    except Exception as err:
        logger.error("update_treasury_error", exc_info=True)
        raise err


def compute_fee_amount_and_total(fee_notional, amount, fee, fee_type):
    """
    计算fee_amount和total
    """
    total = ""
    fee_amount = ""
    if fee_notional == "bps":
        fee_amount = amount * fee / 10000
        if fee_type == "separate":
            total = amount + fee_amount
        elif fee_type == "included":
            total = amount
            amount = total - fee_amount

    elif fee_notional == "base":
        fee_amount = fee
        if fee_type == "separate":
            total = amount + fee_amount
        elif fee_type == "included":
            total = amount
            amount = total - fee_amount
    if amount <= 0:
        raise ZCException("amount must greater than zero while fee_type is included")
    return fee_amount, total, amount


def compute_amount_fee_amount_by_total(total, fee, fee_notional):
    total = decimal.Decimal(total)
    fee = decimal.Decimal(fee)
    if fee_notional == "bps":
        amount = total/(decimal.Decimal(1)+fee/10000)
        fee_amount = total - amount
    else:
        amount = total - fee
        fee_amount = fee
    if amount <= 0:
        raise ZCException("amount must greater than zero while fee_type is included")
    return amount, fee_amount


def gen_treasury_trader_receipt(treasury):
    fee_notional = treasury.get("fee_notional")
    if fee_notional == 'base':
        fees = f"{treasury.get('fee')} {treasury.get('asset_id')}"
    elif fee_notional == 'bps':
        fees = f"{(decimal.Decimal(treasury.get('fee')) / 100).quantize(decimal.Decimal('0.00'))} %"
    else:
        logger.error(f"treasury Fee notional wrong treasury_id:{treasury.get('treasury_id')}, "
                     f"fee_national:{treasury.get('fee_notional')}")
        raise ZCException(f"treasury Fee notional wrong treasury_id:{treasury.get('treasury_id')}, "
                          f"fee_national:{treasury.get('fee_notional')}")
    receipt_status = "success"
    receipt_data = dict(
        txn_alias="",
        treasury_alias=treasury.get("treasury_alias"),
        user_id=treasury.get("user_id"),
        trader_identifier=treasury.get("trader_identifier"),
        base_asset=treasury.get("asset_id"),
        quote_asset=treasury.get("asset_id"),
        created_at=int(treasury.get("created_at")),
        side="Treasury",
        quantity=treasury.get("amount"),
        price="1.0000",
        quote_quantity=treasury.get("amount"),
        fees=fees,
        total=treasury.get("total"),
        entity=f"{treasury.get('entity')}_treasury",
        fee_notional=fee_notional,
        order_type="Market",
        account_id=treasury.get("account_id"),
        flag_treasury=True,
    )
    try:
        zmd_gen_receipt(receipt_data)
    except Exception:
        receipt_status = "failed"
    return receipt_status


def zmd_gen_receipt(receipt_data):
    """
    发送凭据，调用zmd接口
    :param receipt_data:
    :return:
    """
    zmd_host = os.environ.get('ZEROCAP_MONITOR_GRPC_ZMD')
    with grpc.insecure_channel(zmd_host) as channel:
        stub = zerocap_market_data_pb2_grpc.ZerocapMarketDataStub(channel)
        receipt_res = stub.GenTradeReceipt(zerocap_market_data_pb2.GenTradeReceiptRequestV1(**receipt_data))

        if receipt_res.status != "success":
            logger.error("Talos WS zmd_gen_receipt: gen trader receipt failed!")
            raise Exception("gen trader receipt failed!")


def is_number_str(s):
    """
    判断是否是数字字符串，包括小数型
    :param s: str
    :return: bool
    """
    try:
        float(s)
        return True
    except ValueError:
        return False


def check_params_is_number_and_greater_then_zero(*strs):
    """
    检查字符串是否是正数字符串
    :param strs: str
    :return:
    """
    for s in strs:
        if not is_number_str(s):
            raise ZCException(f"Param Value {s} is not digital")

        if decimal.Decimal(s) < 0:
            raise ZCException(f"Param Value {s} must greater then zero")


@timer
def get_transaction_from_chain(request):
    asset_id = request.asset_id  # 币的名称
    tx_id = request.tx_id  # 交易 hash 值
    if asset_id == "" or tx_id == "":
        raise ZCException("tx_id、 asset_id cannot be empty!")

    transaction = GetTransactionByTxHash()
    source_url = get_asset_source_url(asset_id)
    logger.info(f"Get Transaction By '{source_url}' , asset_id='{asset_id}' , tx_id='{tx_id}'")
    result, error_message = transaction.async_get_transcation(
        source_url=source_url, asset_id=asset_id, tx_hash=tx_id)

    json_data = json.loads(MessageToJson(result[0]))
    if "quantity" in json_data:
        return dict(status=ResponseStatusSuccessful, error_message=error_message, result=result)
    else:
        result, error_message = transaction.async_get_transcation(
            source_url="", asset_id=asset_id, tx_hash=tx_id)
    return dict(status=ResponseStatusSuccessful, error_message=error_message, result=result)


def settle_check(request):

    # 参数非空校验及数量校验
    logger.info("参数非空校验及数量校验等等")
    check_settle_check_parameter(request)

    user_id = request.user_id
    account_id = request.account_id
    vault_id = request.vault_id
    asset = request.asset
    side = request.side
    txn_alias = request.txn_alias
    amount = request.quantity
    entity = request.entity
    inspection_items = request.inspection_items

    # USDT链数据转成USDT
    if asset in USDTChain:
        asset = 'USDT'

    # 特殊处理USDT_AVAX
    if asset == 'USDT_AVAX':
        asset = 'USDT2_AVAX'
    elif asset == 'BNB':
        asset = 'BNB_BSC'

    # 查询tenant
    tenant = query_tenant_by_user_id(user_id)

    # 如果要检查的为空,则全都检查
    if not inspection_items:
        inspection_items = ["is_portal", "kyc", "fb_address_balance", "is_fiat"]

    result = {}
    if "is_portal" in inspection_items:
        # 检查币种是否是 portal 支持的
        is_portal = check_is_portal_support_asset(asset)
        result["is_portal"] = str(is_portal)
    if "kyc" in inspection_items:
        # 检查客户是否通过了 kyc
        kyc_approved, pa_agreed, name = get_kyc_and_pa_and_name_by_account(account_id)
        result["kyc"] = str(kyc_approved)
    if "fb_address_balance" in inspection_items:
        fb_address_balance = fb_and_address_and_balances_check(account_id, vault_id, asset, side, amount, entity, tenant, txn_alias)
        result['fb_address_balance'] = fb_address_balance
    if "is_fiat" in inspection_items:
        # 检查币种是不是法币
        is_fiat, bank_list = is_fiat_asset(asset, account_id)
        result["is_fiat"] = str(is_fiat)
        result["user_bank_list"] = bank_list

    # amount检查
    amount_res = check_txn_amount(txn_alias, asset, side, amount)
    if not amount_res:
        raise ZCException("quantity plus what has been used is greater than the total number of transactions!")
    result["status"] = ResponseStatusSuccessful
    return result


def fb_and_address_and_balances_check(account_id, vault_id, asset_id, side, amount, entity, tenant, txn_alias):

    # 如果asset_id是USDT,则获取USDT的链数据
    if asset_id == 'USDT':
        asset_list = [(key, vaule) for key, vaule in config['USDT'].items()]
    else:
        asset_list = [('', asset_id)]

    result = []
    loop = asyncio.new_event_loop()

    tasks = []

    for network, asset in asset_list:
        # 检查时将正式币转为测试币（ config中ASSET_MAPPING key是测试币，value是正式币 ）
        asset_map = {value: key for key, value in config['CONFIG_ASSET']['ASSET_MAPPING'].items()}
        asset = asset_map.get(asset, asset)

        # 检查地址是否添加
        wallet_id = check_address(asset, tenant, account_id, side, entity, vault_id)
        tasks.append(loop.create_task(balances_check(account_id, vault_id, asset, side, entity, txn_alias)))
        tasks.append(loop.create_task(fee_check(asset, entity, vault_id, amount, account_id, side, wallet_id, network)))

    data_list = loop.run_until_complete(asyncio.gather(*tasks))
    new_data_list = [(data_list[i], data_list[i+1]) for i in range(0, len(data_list), 2)]
    for banlances_data, fee_data in new_data_list:
        is_gas_fee = True
        remain_amount = banlances_data['balance_amount']
        if fee_data['asset_id'] in TRXAssets + BSCAssets:
            fee = fee_data['fee']
            trx_amount = banlances_data['trx_available_amount']
            if float(fee) > float(trx_amount) or not fee_data['fee_flag']:
                logger.error(
                    f"TRX小于 fee费用！account_id：{account_id}, vault_id：{vault_id}, trx available: {trx_amount}，"
                    f"fee： {float(fee)}  asset_id: {fee_data['asset_id']}")
                is_gas_fee = False

        result.append(dict(
            network=fee_data['network'],
            fb_id=fee_data['fb_id'],
            wallet_id=fee_data['wallet_id'],
            balance=str(remain_amount),
            is_gas_fee=is_gas_fee))
    return result


async def fee_check(asset_id, entity, vault_id, amount, account_id, side, wallet_id,  network=None):

    async def get_transaction_estimate_fee(asset_id, amount, source, destination, workspace):
        try:
            fb_client = fireblocks_gateway.fireblock_client(workspace=workspace)
            body = {
                "assetId": asset_id,
                "source": source.__dict__,
                "destination": destination.__dict__,
                "amount": float(amount),
                "operation": 'TRANSFER',  # FB 规定必须是 TRANSFER, 不然无法获取 fee 数据
            }
            result = await fb_client._post_request_async("/v1/transactions/estimate_fee", body)
            result['fee_flag'] = True
            logger.info(f"get_transaction_estimate_fee： result： {result}")
        except:
            logger.error(f"get_transaction_estimate_fee error： {traceback.format_exc()}")
            logger.error(f"get_transaction_estimate_fee error： asset_id： {asset_id}")
            result = {
                'fee_flag': False,
                'medium': {'networkFee': '0'}
            }
            logger.error(f"get_transaction_estimate_fee error： result： {result}")
        return result

    # payment时,检查该交易员同一个币种,是否有正在成交的记录,有则为False表示不能转账
    # transfer_accounts = 'True'
    # if side == 'payment':
    #     txh_status = get_transactionshistory_status(asset_id, account_id, vault_id)
    #     if txh_status:
    #         transfer_accounts = 'False'

    # 检查是否是 fb 支持的币种
    fb_id = get_asset_fb_id(asset_id)

    # trx 链 校验 gas费， 其他链暂时不校验
    if asset_id in TRXAssets + BSCAssets:
        otc_wallet_info = config['ZEROCAP_OTC_MAPPING'][entity]
        if side == 'payment':
            workspace = query_workspace_by_account_id_vault_id(account_id, vault_id)
            if not workspace or workspace not in ('zerocap_staking', 'zerocap_portal'):
                logger.error(
                    f"balances_check, user workspace acquisition failed！account_id：{account_id}, vault_id：{vault_id}")
                raise Exception("balances_check, user workspace acquisition failed！")
            if workspace == 'zerocap_staking':
                external_wallet_id = otc_wallet_info['internal_wallet_to_zerocap_staking']
            else:
                external_wallet_id = otc_wallet_info['internal_wallet_to_zerocap_portal']

            source = TransferPeerPath(VAULT_ACCOUNT, vault_id)
            destination = TransferPeerPath(EXTERNAL_WALLET, external_wallet_id)
            fee = await get_transaction_estimate_fee(asset_id, amount, source, destination, workspace)
            fee_amount = fee["medium"]["networkFee"]
        else:
            # fee 获取
            # 获取otc钱包的资产信息
            otc_vault_id = otc_wallet_info['vault_id']
            workspace = otc_wallet_info['workspace']
            source = TransferPeerPath(VAULT_ACCOUNT, otc_vault_id)
            destination = TransferPeerPath(EXTERNAL_WALLET, wallet_id)
            fee = await get_transaction_estimate_fee(asset_id, amount, source, destination, workspace)
            fee_amount = fee["medium"]["networkFee"]
        return {"asset_id": asset_id, "fee": fee_amount, 'fb_id': fb_id, 'wallet_id': wallet_id, "network": network,
                'fee_flag': fee['fee_flag']}
    else:
        return {"asset_id": asset_id, "fee": '0', 'fb_id': fb_id, 'wallet_id': wallet_id, "network": network,
                'fee_flag': False}


async def balances_check(account_id, vault_id, asset_id, side, entity, txn_alias=None):
    if side not in ('payment', 'settlement'):
        logger.error(f"balances_check, invaild side！side：{side}")
        raise Exception("balances_check, invaild side！")

    otc_wallet_info = config['ZEROCAP_OTC_MAPPING'][entity]
    workspace = query_workspace_by_account_id_vault_id(account_id, vault_id)
    if not workspace or workspace not in ('zerocap_staking', 'zerocap_portal'):
        logger.error(f"balances_check, user workspace acquisition failed！account_id：{account_id}, vault_id：{vault_id}")
        raise Exception("balances_check, user workspace acquisition failed！")

    if side == 'payment':
        pending_quantity = get_pending_quantity_by_txn_alias(txn_alias, "payment")
        balances_result = query_balances_by_account_id(account_id, vault_id, asset_id)
        if not balances_result:
            logger.error(
                f"获取币种余额异常, 没有获取到数据！account_id：{account_id}, vault_id：{vault_id}, asset_id: {asset_id}")
            return {"asset_id": asset_id, "balance_amount": '0', "trx_available_amount": "0"}

        balances_quantity = balances_result[0]['quantity']
        balance_amount = str(Calc(Calc(balances_quantity) - Calc(pending_quantity)))

        if asset_id in TRXAssets + BSCAssets:
            # 查trx链上的数量，跟fee对比，如果小的话，直接抛出异常
            asset_map = {value: key for key, value in config['CONFIG_ASSET']['ASSET_MAPPING'].items()}
            if asset_id in TRXAssets:
                chain_asset_id = asset_map.get("TRX", "TRX")
            else:
                chain_asset_id = asset_map.get("BNB", "BNB")

            balances_result = query_balances_by_account_id(account_id, vault_id, chain_asset_id)
            if not balances_result:
                logger.error(
                    f"获取币种余额异常, 没有获取到数据！account_id：{account_id}, vault_id：{vault_id}, asset_id: {chain_asset_id}")
                return {"asset_id": asset_id, "balance_amount": balance_amount, "trx_available_amount": "0"}

            trx_available_amount = balances_result[0]['quantity']
        else:
            trx_available_amount = '0'
    else:
        # 检查是否是 fb 支持的币种
        fb_id = get_asset_fb_id(asset_id)
        if not fb_id:
            return {"asset_id": asset_id, "balance_amount": 0, "trx_available_amount": "0"}

        # 获取otc钱包的资产信息
        otc_vault_id = otc_wallet_info['vault_id']
        res_gateway = await get_vaults_data(otc_wallet_info['workspace'], otc_vault_id, asset_id)
        pending_quantity = get_pending_quantity_by_txn_alias(txn_alias, "settlement")
        if not res_gateway:
            logger.error(
                f"fb otc资产获取异常, 没有获取到数据！account_id：{account_id}, vault_id：{otc_vault_id}, asset_id: {asset_id}")
            return {"asset_id": asset_id, "balance_amount": '0', "trx_available_amount": "0"}

        available_amount = res_gateway['available']
        balance_amount = str(Calc(Calc(available_amount) - Calc(pending_quantity)))
        # 如果eth链上的，跟eth
        # trx 链 校验 gas费， 其他链暂时不校验
        if asset_id in TRXAssets + BSCAssets:
            # 查trx链上的数量，跟fee对比，如果小的话，直接抛出异常
            asset_map = {value: key for key, value in config['CONFIG_ASSET']['ASSET_MAPPING'].items()}
            if asset_id in TRXAssets:
                chain_asset_id = asset_map.get("TRX", "TRX")
            else:
                chain_asset_id = asset_map.get("BNB", "BNB")
            res_gateway = await get_vaults_data(otc_wallet_info['workspace'], otc_vault_id, chain_asset_id)

            if not res_gateway:
                logger.error(f"otc资产获取： res_gateway： {res_gateway}")
                logger.error(
                    f"fb otc资产获取异常, 钱包中没有TRX对应资产！account_id：{account_id}, vault_id：{otc_vault_id}, asset_id: {asset_id}")
                return {"asset_id": asset_id, "balance_amount": balance_amount, "trx_available_amount": "0"}
            else:
                trx_available_amount = res_gateway['available']
        else:
            trx_available_amount = 0

    return {"asset_id": asset_id, "balance_amount": balance_amount, "trx_available_amount": trx_available_amount}


async def get_vaults_data(workspace, vault_id, asset_id):
    result = {
    }
    try:
        fb_client = fireblocks_gateway.fireblock_client(workspace=workspace)

        res = None
        counter = 0
        while not res and counter < 10:
            counter += 1
            # res = await fb_client._get_request_aysnc(f"/v1/vault/accounts/{vault_id}")
            res = await fb_client._get_request_aysnc(f"/v1/vault/accounts/{vault_id}/{asset_id}")

            if not res:
                time.sleep(0.5)

        result = copy.deepcopy(res)

    except Exception as e:
        logger.error(str(e))
        # send_slack(
        #     channel='SLACK_API_OPS',
        #     subject="get_vault failed",
        #     content=f"vault_id={vault_id} e={e}"
        # )

    return result


def handle_create_ems_transacation(request):
    blotter_data = {}
    with db.atomic():
        logger.info("开始进行转账操作")
        alias = str(uuid.uuid1())
        is_usdt = False
        # USDT转成USDT链数据
        if request.network:
            is_usdt = True
            request.asset_id = config['USDT'][request.network]
        
        # 特殊处理USDT_AVAX
        if request.asset_id == 'USDT_AVAX':
            request.asset_id = 'USDT2_AVAX'
        elif request.asset_id == 'BNB':
            request.asset_id = 'BNB_BSC'

        #  转账时将正式币转为测试币（ config中ASSET_MAPPING key是测试币，value是正式币 ）
        asset_map = {value: key for key, value in config['CONFIG_ASSET']['ASSET_MAPPING'].items()}
        asset_id = asset_map.get(request.asset_id, request.asset_id)

        # 根据用户的vault_id，account_id在 externalwalletproptrading 获取到外部钱包，查不到为空
        account_id = request.account_id
        side = request.side
        vault_id = request.vault_id
        wallet_id = request.wallet_id
        entity = request.entity
        amount = request.amount
        logger.info("获取用户工作区")
        workspace = query_workspace_by_account_id_vault_id(account_id, vault_id)
        if not workspace:
            logger.error(
                f"handle_create_ems_transacation, user workspace acquisition failed！account_id：{account_id}, vault_id：{request.vault_id}")
            raise Exception("user workspace acquisition failed！")

        logger.info("查询source_address和 destination_address")
        # payment、settlement 之前检查是否是多笔重复添加
        whether_repeatedly_payment(request.txn_alias, request.asset_id, side, amount, is_usdt)
        if side == 'payment':
            # 查询内部钱包地址，查询 internal_wallets获取address, 查不到为空
            destination_address = query_interwallet_by_wallet_id(wallet_id, asset_id)
            result = get_wallet_pool_by_user_id_and_asset_id(asset_id, vault_id, account_id, 'Zerocap')
            if result is None:
                source_address = ""
            else:
                source_address = result[0]['address']
        else:
            # 查询外部钱包，查不到为空
            result = get_wallet_pool_by_user_id_and_asset_id(asset_id, vault_id, account_id, 'Zerocap', wallet_id)
            if result is None:
                destination_address = ""
            else:
                destination_address = result[0]['address']

            # 根据 otc的配置，获取到 internal_wallet_id， 查询 internal_wallets获取address
            otc_wallet_info = config['ZEROCAP_OTC_MAPPING'][entity]
            if workspace == 'zerocap_staking':
                inertnal_wallet_id = otc_wallet_info['internal_wallet_to_zerocap_staking']
            else:
                inertnal_wallet_id = otc_wallet_info['internal_wallet_to_zerocap_portal']
            # 查询内部钱包地址，查询 internal_wallets获取address, 查不到为空
            source_address = query_interwallet_by_wallet_id(inertnal_wallet_id, asset_id)

        # 转账状态查询以及发起转账，不允许同一笔单子多次同时转账;(USDT例外)
        logger.info("create_otc_transaction_and_update_withdrawals start")
        request_dict = MessageToDict(request, including_default_value_fields=True, preserving_proto_field_name=True)
        request_dict['alias'] = alias
        request_dict['source_address'] = source_address
        request_dict['destination_address'] = destination_address
        request_dict['comment_note'] = request.note
        tx_id = create_otc_transaction_and_update_withdrawals(ObjDict(request_dict))
        logger.info("create_otc_transaction_and_update_withdrawals end")
        request_dict['tx_id'] = tx_id

        # 新增一条记录
        try:
            logger.info(f"add_new_deposit_or_withdrawal_record start")
            blotter_data = add_new_deposit_or_withdrawal_record(ObjDict(request_dict))
            logger.info("add_new_deposit_or_withdrawal_record end")
        except Exception as e:
            # 取消链上转账
            fireblocks_gateway.cancel_transaction(tx_id, account_id=request.account_id, vault_id=request.vault_id)
            logger.error(f"add_new_deposit_or_withdrawal_record error: {traceback.format_exc()}")
            raise ZCException(f"add_new_deposit_or_withdrawal_record error error: {e}")

        # # 如果勾选 Notify Customer 发送邮件通知
        # if is_notify_customer:
        #     logger.info("handle_create_ems_transacation 开始发送邮件")
        #     email_service = EmailService()
        #     operate_type = "withdrawal" if side == "payment" else "deposit"
        #     logger.info(f"发送邮件参数：account_id: {account_id}, amount: {amount}, asset_id: {asset_id}, "
        #                 f"operate_type: {operate_type}, email_service: {email_service}")
        #     send_fiat_or_altcoin_mail(request, operate_type, email_service)
    # 事务结束后再调用 blotter
    blotter(ObjDict(blotter_data))


def add_settle(request):
    check_payment_parameter(request)
    category = request.category

    if category == 'fb':
        # 判断币种是否在 asset_id中
        handle_create_ems_transacation(request)
    elif category == 'fiat':
        handle_fiat_and_cannot_transfer(request)
    else:
        handle_no_fiat_and_cannot_transfer(request)

    # 自动交割 settle 接口
    ems_host = os.environ.get('ZEROCAP_MONITOR_GRPC_ADMIN', 'localhost:5004')
    with grpc.insecure_channel(ems_host) as channel:
        stub = admin_pb2_grpc.AdminStub(channel)
        receipt_res = stub.SettleTrade(exec_pb2.SettleTradeRequestV1(txn_alias=request.txn_alias))

        if receipt_res.status != "success":
            logger.error("SettleTrade: failed!")
            raise Exception("SettleTrade: failed!")
    return {"status": "successful"}


def add_new_deposit_or_withdrawal_record(request):
    created_at = int(time.time() * 1000)
    if request.side == "payment":
        # 新增 deposit 记录
        deposit_data = {
            "deposit_alias": request.alias,
            "txn_alias": request.txn_alias,
            "asset_id": request.asset_id,
            "quantity": request.amount,
            "receiving_address": request.destination_address,
            "sending_address": request.source_address,
            "tx_hash": "",
            "created_at": created_at,
            "status": "pending",
            "bank_details": "",
            "trader_identifier": request.trader_identifier,
            "account_id": request.account_id,
            "note": request.note,
            "tx_id": request.tx_id  # 对应 fiat txn history 记录的 tx_id
        }
        add_deposit(deposit_data)

    elif request.side == 'settlement':
        # 新增 withdrawal 记录
        withdrawal_data = {
            "withdrawal_alias": request.alias,
            "txn_alias": request.txn_alias,
            "asset_id": request.asset_id,
            "quantity": request.amount,
            "receiving_address": request.destination_address,
            "sending_address": request.source_address,
            "tx_hash": "",
            "withdrawal_time": created_at,
            "created_at": created_at,
            "status": "pending",
            "to_portal": True,
            "trader_identifier": request.trader_identifier,
            "vault_id": request.vault_id,
            "account_id": request.account_id,
            "note": request.note,
            "tx_id": request.tx_id
        }
        add_withdrawal(withdrawal_data)

    # 调用blotter函数
    request_dict = {"new_alias": request.txn_alias, "old_alias": request.txn_alias, "blotter_type": "transaction"}
    return request_dict


def create_otc_transaction(data):
    if data.tx_id:
        # 有tx_id则表示以前发起过转账 判断转账状态
        transaction_info = fireblocks_gateway.get_transaction(data.tx_id, account_id=data.account_id, vault_id=data.vault_id)
        logger.info({
            'type': 'info_record',
            'func': 'create_otc_transaction',
            'message': 'current_transaction_info',
            'info': transaction_info
        })
        if transaction_info.get("status", "") in [StatusRejected, StatusCancelled, StatusBlocked,
                                                  StatusFailed]:  # 转账失败
            tx_id = create_otc_transaction_and_update_withdrawals(data)
            if tx_id:
                return dict(status=ResponseStatusSuccessful,
                            user_id=data.user_id,
                            tx_id=tx_id)
        elif transaction_info.get("status", "") == StatusCompleted:
            # 转账完成
            if data.side == "payment":
                update_deposit_by_tx_id(data.tx_id, {"status": StatusSuccess})
            else:
                update_withdrawal_by_tx_id(data.tx_id, {"status": StatusSuccess})  # 回写覆盖 withdraws  表 status 为 success
            update_transaction(data.tx_id, {"status": StatusCompleted})  # 更新transactionhistory status 为COMPLETED
            return dict(status=ResponseStatusSuccessful, user_id=data.user_id,
                        tx_id=data.tx_id)
        else:
            # 订单正在进行中(取消上一个交易，重新发起交易，并回写覆盖withdraws 表tx_id)
            fireblocks_gateway.cancel_transaction(data.tx_id, account_id=data.account_id, vault_id=data.vault_id)  # 取消上一个交易
            tx_id = create_otc_transaction_and_update_withdrawals(data)
            if tx_id:
                return dict(status=ResponseStatusSuccessful,
                            tx_id=tx_id)
    raise ZCException("Failed to create_transaction_and_update_withdrawals(not get tx_id).")


@timer
def create_otc_transaction_and_update_withdrawals(request):
    """
    :param request:
    :return:
    """
    #  转账时将正式币转为测试币（ config中ASSET_MAPPING key是测试币，value是正式币 ）
    asset_map = {value: key for key, value in config['CONFIG_ASSET']['ASSET_MAPPING'].items()}
    asset_id = asset_map.get(request.asset_id, request.asset_id)
    data_dict = {
        "asset_id": asset_id,
        "account_id": request.account_id,
        "vault_id": request.vault_id,
        "side": request.side,
        "amount": request.amount,
        "wallet_id": request.wallet_id,
        "entity": request.entity,
    }
    logger.info(f"create_otc_transaction_and_update_withdrawals, 转账参数检查: {data_dict}")
    check_to_settle(asset_id, request.account_id, request.vault_id, request.side, request.amount, request.wallet_id, request.entity, request.txn_alias, request.asset_id)

    if request.side == 'payment':
        workspace = query_workspace_by_account_id_vault_id(request.account_id, request.vault_id)
        note = f"otc_payment|{request.alias}|{request.account_id}|{request.vault_id}"
        destination_type = "INTERNAL_WALLET"
        side_type = "payment_confirmation"
        from_account_type = "custody"
        to_account_type = "ZC OTC"
        source_vault_id = request.vault_id
        operation = 'WITHDRAWAL'
    else:
        # vault = get_vault_by_user_id(user_id)
        transactions = get_transactions_by_txn_alias(request.txn_alias)
        entity = transactions.get('entity', '').lower()
        if entity == EntityVesper:
            otc_vault_id = config["ZEROCAP_OTC_MAPPING"]["vesper"]["vault_id"]
            workspace = config["ZEROCAP_OTC_MAPPING"]["vesper"]["workspace"]
        elif entity == EntityZerocap:
            otc_vault_id = config["ZEROCAP_OTC_MAPPING"]["zerocap"]["vault_id"]
            workspace = config["ZEROCAP_OTC_MAPPING"]["zerocap"]["workspace"]
        else:
            raise ZCException("transactions entity error")

        if not workspace or not otc_vault_id:
            raise ZCException("workspace error or vault_id error")

        note = f"otc_settlement|{request.alias}|{request.account_id}|{request.vault_id}"
        destination_type = "EXTERNAL_WALLET"
        side_type = "settlement_confirmation"
        from_account_type = "ZC OTC"
        to_account_type = "custody"
        source_vault_id = otc_vault_id
        operation = 'DEPOSIT'

    source = TransferPeerPath(VAULT_ACCOUNT, source_vault_id)
    destination = TransferPeerPath(EXTERNAL_WALLET, request.wallet_id)
    fireblocks_gateway.workspace_base = workspace
    fb_client = fireblocks_gateway.fireblock_client(workspace=workspace)
    logger.info(
        {
            'type': 'info_record',
            'func': 'create_transaction_and_update_withdrawals',
            'message': 'create_transaction_info',
            'info': {
                'asset_id': asset_id,
                'quantity': float(request.amount),
                'source_vault_id': source_vault_id,
                'destination_external_wallet_id': request.wallet_id,
                'note': note,
                'account_id': request.account_id
            }
        }
    )
    result = fireblocks_gateway.create_transaction(asset_id,
                                                   float(request.amount),
                                                   source,
                                                   destination,
                                                   note=note,
                                                   account_id=request.account_id,
                                                   vault_id=request.vault_id,
                                                   # treat_as_gross_amount=True,
                                                   fb_client=fb_client)
    if result.get("id", None):
        tx_id = result["id"]
        update_data = {"tx_id": tx_id, "status": "pending"}
        if request.side == 'payment':
            update_withdrawal(request.alias, update_data)
        else:
            update_deposit(request.alias, update_data)

        timestamp = int(time.time() * 1000)
        email, entity_id = get_email_entity_id_by_user_id(request.user_id)
        transaction_dic = {
            # 'user_id': email,
            'tx_id': tx_id,
            'tx_hash': request.tx_hash,
            'source_id': source_vault_id,
            'source_type': 'VAULT_ACCOUNT',
            'source_address': request.source_address,
            'destination_type': destination_type,
            'destination_id': request.wallet_id,
            'destination_address': request.destination_address, # 目前地址，传入
            'asset_id': asset_id,
            'amount': request.amount,
            'created_at': timestamp,
            'last_updated': timestamp,
            'datetime': iso8601(timestamp),
            'token': "",
            "numConfirms": "",
            'type': side_type,
            'operation': operation,
            'status': result["status"],
            'note': note,
            'vault_id': request.vault_id,
            'email': email,
            'entity_id': entity_id,
            'interest_earned': 0,
            'comment': request.comment_note,
            'from_account_type': from_account_type,
            'to_account_type': to_account_type,
            'account_id': request.account_id
        }

        yield_pending_dic = {
            "yield_id": str(uuid.uuid1()),
            "asset_id": asset_id,
            "user_id": email,
            "amount": request.amount,
            "apr": 0,
            "term": "",
            "type": "custody",
            "status": PendingIncrease if request.side == 'payment' else PendingDecrease,
            "created_at": iso8601(timestamp),
            "last_updated": iso8601(timestamp),
            "amount_change": request.amount,
            "interest_usd": '0',
            "interest_crypto": '0',
            "operate": 'deposit' if request.side == 'payment' else 'withdrawal',
            "tx_id": tx_id,
            "entity_id": entity_id,
            "account_id": request.account_id,
            "email": email,
            "vault_id": request.vault_id,
        }
        try:
            logger.info(f"create_otc_transaction_and_update_withdrawals, transaction_dic: {transaction_dic}")
            create_transaction(transaction_dic)
            logger.info(f"create_otc_transaction_and_update_withdrawals, yield_pending_dic: {yield_pending_dic}")
            create_yieldspending(yield_pending_dic)
        except Exception as e:
            # 取消链上转账
            fireblocks_gateway.cancel_transaction(tx_id, account_id=request.account_id, vault_id=request.vault_id)
            logger.error(f"create_transaction or create_yieldspending error: {traceback.format_exc()}")
            raise ZCException(f"create_transaction or create_yieldspending error: {e}")
        return tx_id


def check_to_settle(asset_id, account_id, vault_id, side, amount, wallet_id, entity, txn_alias, origin_asset_id):
    # 币种检查；
    logger.info("check_to_settle, 币种检查")
    result = check_asset_is_main_or_altion(asset_id)
    if not result:
        logger.error("check_to_settle, 币种检查异常, 不在main，altion中!")
        raise Exception("check_to_settle, asset business_type error")

    # 检查是不是 fb 支持的币种
    logger.info("check_to_settle, 检查是不是 fb 支持的币种")
    if not does_it_exist_from_fb(asset_id):
        error_message = f"The asset '{asset_id}' is not supported by Fireblocks, please check the supported assets endpoint."
        raise ZCException(error_message)

    # 检查钱包（暂时不做）
    # 检查余额（是否需要算利息，暂定不算）
    logger.info("check_to_settle, 检查余额")
    loop = asyncio.new_event_loop()
    tasks = []
    tasks.append(loop.create_task(balances_check(account_id, vault_id, asset_id, side, entity, txn_alias)))
    tasks.append(
        loop.create_task(fee_check(asset_id, entity, vault_id, amount, account_id, side, wallet_id)))

    data_list = loop.run_until_complete(asyncio.gather(*tasks))
    new_data_list = [(data_list[i], data_list[i + 1]) for i in range(0, len(data_list), 2)]
    banlances_data, fee_data = new_data_list[0]

    remain_amount = banlances_data['balance_amount']
    if fee_data['asset_id'] in TRXAssets + BSCAssets:
        fee = fee_data['fee']
        trx_amount = banlances_data['trx_available_amount']
        if float(fee) > float(trx_amount) or not fee_data['fee_flag']:
            logger.error(
                f"TRX小于 fee费用！account_id：{account_id}, vault_id：{vault_id}, trx available: {trx_amount}，"
                f"fee： {float(fee)} asset_id: {fee_data['asset_id']}")
            raise Exception("check_to_settle, The fee amount is greater than the balance")

    if Calc(remain_amount).numeric() < Calc(amount).numeric():
        logger.error(f"check_to_settle, 余额小于转账数量! remain_amount: {remain_amount}, amount: {amount}")
        raise Exception("check_to_settle, The transaction amount is greater than the balance")

    logger.info("check_to_settle, 检查剩余的转账数是否足够转账")
    result = check_txn_amount(txn_alias, origin_asset_id, side, amount)
    if not result:
        logger.error(f"check_to_settle, txn amout 小于 transaction amount 总数量!")
        raise Exception("check_to_settle, The transaction amount is greater than the txn remain amount")


def get_ems_transfer(request):
    tx_id = request.tx_id
    account_name = request.account_name
    individual_email = request.individual_email

    if not tx_id or not account_name or not individual_email:
        raise ZCException("parameter can not be empty!")

    txn = get_txn_data_by_tx_id(tx_id)
    transfer_type = f"from {txn.from_account_type} to {txn.to_account_type}"
    transfer_amount = txn.amount
    current_balance = get_balance_by_account_id_and_asset(txn.account_id, txn.asset_id)
    status = txn.status

    if txn.substatus:
        fireblock_status = f"FAILED-{txn.substatus}"
    else:
        fireblock_status = "FAILED"

    if txn.asset_id == txn.fee_currency:
        total_amount_sent_on_chain = Calc(Calc(transfer_amount) + Calc(txn.fee))
    else:
        total_amount_sent_on_chain = txn.amount

    side = txn.type.split("_")[0]
    new_balance = ""
    if side == "payment":
        new_balance = Calc(Calc(Calc(current_balance) - Calc(transfer_amount)) - Calc(txn.fee))
    elif side == "settlement":
        new_balance = Calc(Calc(current_balance) + Calc(transfer_amount))

    transfer_data = dict(
        tx_id=tx_id,
        account_name=account_name,
        individual_email=individual_email,
        transfer_type=transfer_type,
        asset_id=txn.asset_id,
        current_balance=current_balance,
        new_balance=str(new_balance),
        transfer_amount=transfer_amount,
        transaction_fee=txn.fee,
        status=status,
        fireblock_status=fireblock_status,
        total_amount_sent_on_chain=str(total_amount_sent_on_chain),
        amount_from_client=str(total_amount_sent_on_chain),
        fee_asset=txn.fee_currency if txn.fee_currency else txn.asset_id
    )

    return dict(
        status=ResponseStatusSuccessful,
        transfer_data=transfer_data
    )


def reject_ems_transfer(request):
    tx_id = request.tx_id

    if not tx_id:
        raise ZCException("parameter can not be empty!")

    # 获取 txn 数据
    txn = get_txn_data_by_tx_id(tx_id)

    # 取消链上转账
    # fireblocks_gateway.cancel_transaction(tx_id, account_id=txn.account_id, vault_id=txn.vault_id)

    # 更新 yields pending 表
    update_data = {
        "status": "rejected"
    }
    update_yields_pending_rejected(tx_id, update_data)

    # 更新 transactions history 表
    update_transaction(tx_id, {"status": "REJECTED"})

    side = txn.type.split("_")[0]
    # 更新 deposit or withdrawal 表
    if side == "payment":
        update_deposit_by_tx_id(tx_id, update_data)
    elif side == "settlement":
        update_withdrawal_by_tx_id(tx_id, update_data)

    return dict(
        status=ResponseStatusSuccessful
    )


def ems_transfer_resend(request):
    tx_id = request.tx_id

    if not tx_id:
        raise ZCException("parameter can not be empty!")

    # resend 转账, 需要将上一笔 txn history 记录置为 DELETED, 重新创建 txn history 记录
    update_transaction(tx_id=tx_id, update_data={"status":"DELETED"})

    # 获取转账的参数
    txn = get_txn_data_by_tx_id(tx_id)
    alias = str(uuid.uuid1())
    data = ObjDict(dict(
            side = 'payment' if txn.type == 'payment_confirmation' else 'settlement',
            alias = alias,
            amount = txn.amount,
            account_id = txn.account_id,
            vault_id = txn.vault_id,
            asset_id = txn.asset_id,
            tx_hash = txn.tx_hash,
            comment_note = txn.comment,
            source_address = txn.source_address,
            destination_address = txn.destination_address,
            wallet_id = txn.destination_id,
            tx_id = tx_id
        ))

    if data.side == 'payment':
        res = get_deposit()
    else:
        res, _ = get_withdrawal()
    if res and res[0]["txn_alias"]:
        data.txn_alias = res[0]["txn_alias"]
        res_txn = get_transactions_by_alias(data.txn_alias)
        data.user_id = res_txn.user_id
        data.entity = res_txn.entity
    # 转账参数验证
    if not data.txn_alias:
        raise ZCException('txn alias not found')
    if not data.user_id:
        raise ZCException('user id not found')
    if not data.entity:
        raise ZCException('entity not found')

    # 重新发起转账
    res = create_otc_transaction(data)
    created_at = int(time.time() * 1000)
    if res:
        update_data = {"status": "rejected"}
        if txn.type == 'payment_confirmation' and res.get('tx_id', None):
            # 更新deposits表中的status为fialed
            update_deposit_by_tx_id(tx_id, update_data)
            # 获取deposits表数据
            deposit_res = get_deposit_by_tx_id(tx_id)
            # 新增一条deposits数据
            add_deposit({
                "deposit_alias": alias,
                "txn_alias": deposit_res.txn_alias,
                "asset_id": deposit_res.asset_id,
                "quantity": deposit_res.quantity,
                "receiving_address": deposit_res.receiving_address,
                "sending_address": deposit_res.sending_address,
                "tx_hash": deposit_res.tx_hash,
                "created_at": created_at,
                "status": "pending",
                "bank_details": deposit_res.bank_details,
                "trader_identifier": deposit_res.trader_identifier,
                "account_id": deposit_res.account_id,
                "note": deposit_res.note,
                "tx_id": res.get('tx_id', None)
            })
        else:
            # 更新withdrawals表中的status为fialed
            update_withdrawal_by_tx_id(tx_id, update_data)
            # 获取withdrawals表数据
            withdrawals_res = get_withdrawals_by_tx_id(tx_id)
            # 新增一条deposits数据
            add_withdrawal({
                "withdrawal_alias": alias,
                "txn_alias": withdrawals_res.txn_alias,
                "asset_id": withdrawals_res.asset_id,
                "quantity": withdrawals_res.quantity,
                "receiving_address": withdrawals_res.receiving_address,
                "sending_address": withdrawals_res.sending_address,
                "tx_hash": withdrawals_res.tx_hash,
                "withdrawal_time": created_at,
                "created_at": created_at,
                "status": "pending",
                "to_portal": withdrawals_res.to_portal,
                "bank_details": withdrawals_res.bank_details,
                "trader_identifier": withdrawals_res.trader_identifier,
                "vault_id": withdrawals_res.vault_id,
                "account_id": withdrawals_res.account_id,
                "note": withdrawals_res.note,
                "tx_id": res.get('tx_id', None)
            })

    return dict(
        status=ResponseStatusSuccessful
        )


@LogDecorator()
def blotter(request):
    response = handle_blotter(request)
    return response


def update_aaa_symbol(request):
    # 参数校验
    with db.atomic() as tc:

        if not request.base_asset or not request.quote_asset:
            raise ZCException("base_asset or quote_asset can not empty!")

        base_asset = request.base_asset
        quote_asset = request.quote_asset

        if request.txn_alias:
            # 更新quotes, transaction数据
            update_data = {"base_asset": base_asset, "quote_asset": quote_asset}
            update_quotes_transaction_by_txn_alias(update_data, request.txn_alias, tc)

            # 数据落盘后生成 receipt
            txn_result = query_transaction_by_txn_alias(request.txn_alias)
            receipt_data = get_receipt_data(txn_result)
            zmd_gen_receipt(receipt_data)

            # 调用blotter
            request_dict = {"new_alias": request.txn_alias, "blotter_type": "transaction"}
            blotter(ObjDict(request_dict))

        elif request.fill_alias:
            # 更新 fills 数据
            update_data = {"base_asset": base_asset, "quote_asset": quote_asset}
            update_fill_by_alias(update_data, request.fill_alias, tc)

            # 调用blotter
            request_dict = {"new_alias": request.fill_alias, "blotter_type": "fills"}
            blotter(ObjDict(request_dict))

        else:
            raise ZCException("Incorrect operation options!")

    return dict(status=ResponseStatusSuccessful)


if __name__ == "__main__":
    # print(get_vaults_data("Zerocap", "38"))

    # import otc_pb2
    # request = otc_pb2.SettleCheckRequestV1(
    #     user_id='edc374833e2144c28afbe654dbcf6d46',
    #     account_id="6d30ce83-6b46-4f09-951c-a4433370e198",
    #     trader_identifier="e37c11ee-491a-4cb2-b739-d6f2ad1d39da",
    #     vault_id="75",
    #     asset="BTC",
    #     inspection_items=["is_portal", "kyc", "fb_address_balance", "is_fiat"],
    #     side="payment",
    #     txn_alias="e8478993-5cc7-4154-8cab-2e9207016913",
    #     entity="zerocap",
    #     quantity="12",
    # )
    #
    # print(settle_check(request))
    #
    # transaction_info = fireblocks_gateway.get_transaction(tx_id='4347af6a-b5c8-4535-9528-8183d9fe267b')
    # print(transaction_info)

    # res = get_vaults_data('zerocap_portal', 38)
    # print(res)

    # print(fb_and_address_and_balances_check("e3ef543e-e9e6-40e8-8100-e1e7e221bb93", "81", "USDT", "settlement", "2.925",
    #                                   "vesper", "zerocap_portal", "db11b560-b333-479f-bc37-5fc265551141"))

    fb_client = fireblocks_gateway.fireblock_client(workspace='Zerocap')

    res = None
    counter = 0
    while not res and counter < 10:
        counter += 1
        # res = fb_client._get_request(f"/v1/vault/accounts/222")
        res = fb_client._get_request(f"/v1/vault/accounts/222/BTC_TEST")

        if res and 'assets' in res.keys() and len(res['assets']) <= 0:
            time.sleep(0.5)
            res = None
            continue

    result = copy.deepcopy(res)
    print(result)

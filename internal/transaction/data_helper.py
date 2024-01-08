import uuid
import time
import sys

from google.protobuf.json_format import MessageToDict
sys.path.append("../../")

from google.protobuf.json_format import MessageToDict
from functools import reduce
from peewee import JOIN, operator
from utils.calc import Calc, retain_significant_digits
from utils.dict_utils import ObjDict
from db.models import db, Withdrawals, Transactions, TransactionsHistory, Treasury, TreasuryStatusEnum, Users, \
    InternalWallets, ExternalWalletPropTrading, Assets, Deposits, FiatTransactionsHistory, UserBankInfo, YieldsPending, \
    Quotes, Fills


from config.config import OTCSupportedFiat, CHANNEL_DEFAULT_ORDER, config, ASSETS_SETTING
from db_api.account_api import get_account_name, get_entity_id_by_user_id, get_entity_name
from db_api.balance_api import update_balance_by_account_id, get_price_by_redis_or_historical
from db_api.account_api import get_client_name, get_email_by_user_id, send_fiat_or_altcoin_mail
from db_api.asset_api import is_fiat_asset
from internal.users.data_helper import get_email_by_user_id, get_treasury_by_alias, get_fills_by_alias
from internal.rfq.data_helper import get_history_price_by_asset, get_kyc_and_pa_and_name_by_account
from utils.get_market_price import get_symbol_price_by_ccxt_or_redis
from utils.date_time_utils import timestamp_to_time, timer
from utils.consts import EntityVesper, EntityZerocap, ZerocapPortalWorkSpce, VivaWorkSpce, ResponseStatusSuccessful
from utils.email_service import EmailService
from utils.zc_exception import ZCException
from utils.date_time_utils import iso8601
from utils.logger import logger
from celery_async_task.send_tasks import send_task_to_queue


@timer
def get_withdrawal(asset_id=None, amount_start=None, amount_end=None, status=None,
                   created_before=None, created_after=None, page=None,
                   limit=None, amount_usd_start=None, amount_usd_end=None, asset_quote=None,
                   withdrawal_alias=None, txn_alias=None, tx_id=None):
    withdraw_select = Withdrawals.select()
    if asset_id:
        withdraw_select = withdraw_select.where(Withdrawals.asset_id == asset_id)
    if amount_start:
        withdraw_select = withdraw_select.where(
            Withdrawals.quantity.cast('float') >= float(amount_start))
    if amount_end:
        withdraw_select = withdraw_select.where(
            Withdrawals.quantity.cast('float') <= float(amount_end))
    if status:
        withdraw_select = withdraw_select.where(Withdrawals.status == status)
    if created_before:
        withdraw_select = withdraw_select.where(
            Withdrawals.created_at >= created_before)
    if created_after:
        withdraw_select = withdraw_select.where(
            Withdrawals.created_at >= created_after)
    if asset_id and amount_usd_start:
        amount_usd_crypt = float(amount_usd_start) / float(asset_quote)
        withdraw_select = withdraw_select.where(
            Withdrawals.quantity.cast('float') >= float(amount_usd_crypt))
    if asset_id and amount_usd_end:
        amount_usd_crypt = float(amount_usd_end) / float(asset_quote)
        withdraw_select = withdraw_select.where(
            Withdrawals.quantity.cast('float') <= float(amount_usd_crypt))
    if withdrawal_alias:
        withdraw_select = withdraw_select.where(
            Withdrawals.withdrawal_alias == withdrawal_alias)
    if txn_alias:
        withdraw_select = withdraw_select.where(
            Withdrawals.txn_alias == txn_alias)
    if tx_id:
        withdraw_select = withdraw_select.where(
            Withdrawals.tx_id == tx_id)
    total = withdraw_select.count()
    if page and limit:
        withdraw_select = withdraw_select.paginate(int(page), int(limit))
    withdraw_select = withdraw_select.order_by(Withdrawals.created_at.desc())
    if withdraw_select:
        result = []
        for i in withdraw_select:
            data = {
                'account_id': i.account_id,
                'vault_id': i.vault_id,
                'asset_id': i.asset_id,
                'operation': 'Withdrawals',
                'quantity': i.quantity,
                'status': i.status,
                'tx_id': i.tx_id,
                'create_at': timestamp_to_time(i.created_at),
                'txn_alias': i.txn_alias,
            }
            result.append(data)
        return result, total
    return [], total


def update_withdrawal(withdrawal_alias, update_data):
    return Withdrawals.update(update_data).where(Withdrawals.withdrawal_alias == withdrawal_alias).execute()


def update_deposit(deposit_alias, update_data):
    return Deposits.update(update_data).where(Deposits.deposit_alias == deposit_alias).execute()


def get_transactions_by_txn_alias(txn_alias):
    transaction = Transactions.select().where(
        Transactions.txn_alias == txn_alias).first()
    if transaction:
        return {
            'txn_alias': transaction.txn_alias,
            'user_id': transaction.user_id,
            'entity': transaction.entity,
        }


def create_transaction(transaction_dic):
    transaction_lst = [transaction_dic]
    TransactionsHistory.insert_many(transaction_lst).execute()


def update_transaction(tx_id, update_data):
    TransactionsHistory.update(update_data).where(TransactionsHistory.tx_id == tx_id).execute()


def insert_treasury(treasury_dic):
    treasury = Treasury.create(**treasury_dic)
    return treasury.id


@timer
def update_treasury(treasury_dic, old_treasury_alias):
    # 无论是更新还是删除。 都要将旧的数据置为逻辑删除状态
    old_treasury = Treasury.select().where(Treasury.treasury_alias == old_treasury_alias)[0]
    old_treasury.status = TreasuryStatusEnum.Deleted
    old_treasury.save()
    treasury_id = old_treasury.id
    # 是更新的时候。则新增一条数据
    if treasury_dic.get("status") != TreasuryStatusEnum.Deleted:
        treasury = Treasury.create(**treasury_dic)
        treasury_id = treasury.id
    return treasury_id


def get_treasury(user_id=None, trader=None, asset_id=None, date_start=None, date_end=None, page=1, limit=50,
                 fee_type=None, status=None, treasury_alias=None, account_id=None):
    query_treasury = Treasury.select()
    query_treasury = query_treasury.where(Treasury.status != TreasuryStatusEnum.Deleted)
    if user_id:
        query_treasury = query_treasury.where(Treasury.user_id == user_id)
    if account_id:
        query_treasury = query_treasury.where(Treasury.account_id == account_id)
    if trader:
        query_treasury = query_treasury.where(Treasury.trader_identifier == trader)
    if fee_type:
        query_treasury = query_treasury.where(Treasury.fee_type == fee_type)
    if status:
        query_treasury = query_treasury.where(Treasury.status == status)
    if asset_id:
        query_treasury = query_treasury.where(Treasury.asset_id == asset_id)
    if treasury_alias:
        query_treasury = query_treasury.where(Treasury.treasury_alias == treasury_alias)
    if date_start:
        query_treasury = query_treasury.where(Treasury.created_at >= int(date_start))
    if date_end:
        query_treasury = query_treasury.where(Treasury.created_at <= int(date_end))
    total = query_treasury.count()
    if page and limit:
        query_treasury = query_treasury.paginate(int(page), int(limit))
    query_treasury = query_treasury.order_by(Treasury.created_at.desc())
    if query_treasury:
        result = []
        for i in query_treasury:
            user_id = i.user_id
            user_email = get_email_by_user_id(user_id)
            trader_email = get_email_by_user_id(i.trader_identifier)
            account_name = get_account_name(i.account_id)
            data = {
                'id': str(i.id),
                'treasury_alias': i.treasury_alias,
                'user_id': user_id,
                'asset_id': i.asset_id,
                'amount': str(Calc(i.amount)),
                'fee': str(Calc(i.fee)),
                'fee_type': i.fee_type.value,
                'total': str(Calc(i.total)),
                'fee_notional': i.fee_notional.value,
                'tx_hash': i.tx_hash,
                'destination_address': i.destination_address,
                'trader_identifier': i.trader_identifier,
                'status': i.status.value,
                'fee_amount': str(Calc(i.fee_amount)),
                'add_date': str(int(i.add_date.timestamp()) * 1000),
                'created_at': str(i.created_at),  # 时间戳格式返回
                # 'created_at': timestamp_to_time(i.created_at),  # 时间字符串返回 like "2022-12-06 16:45:05"
                'updated_at': str(i.updated_at),
                'notes': i.notes,
                'account_id': i.account_id,
                'vault_id': i.vault_id,
                'user_email': user_email,
                'trader_email': trader_email,
                'account_name': account_name,
                'entity': i.entity,
                'receipt_sent': 'true' if i.receipt_sent else 'false',
                'settlement_destination': i.settlement_destination
            }
            result.append(data)
        return result, total
    return [], total


def get_email_entity_id_by_user_id(user_id):
    res = Users.select(Users.email, Users.entity_id).where(Users.user_id == user_id).first()

    if not res:
        raise Exception("Invalid user id!")
    return res.email, res.entity_id


def check_is_portal_support_asset(asset):
    """
    检查币种是否是 portal 支持的币种
    """
    # 6种法币属于portal支持的币种
    if asset in OTCSupportedFiat:
        return True
    res = Assets.select(Assets.business_type).where(Assets.business_type.in_(['main', 'altcoin', 'off-fb']) & (Assets.id==asset)).first()
    if not res:
        return False
    # # off-fb 虽然也是 portal 支持的类型，但是不能进行链上转账
    # if res.business_type == 'off-fb':
    #     return False
    return True


def get_used_amount(used_lst):
    used_amount = Calc('0')
    for amount in used_lst:
        used_amount = Calc(used_amount) + Calc(amount)
    return used_amount


def check_txn_amount(txn_alias, asset_id, side, amount):
    """
    txn_alis: transaction 记录唯一标识
    asset_id: 当前要转账的币种
    side: payment or settlement
    amount: 本次转账的数量
    """
    txn_res = Transactions.select(Transactions.quantity, Transactions.total, Transactions.side
                                    ).where(Transactions.txn_alias==txn_alias).first()

    txn_amount = Calc(0)
    used_amount = Calc(0)

    # 转账数量不可为 0
    if Calc(amount).value == Calc(0).value:
        return False

    if side == "payment":
        # payment 时 side 为 buy 使用 total, sell 使用 quantity
        if txn_res.side == "buy":
            txn_amount = Calc(txn_res.total)
        else:
            txn_amount = Calc(txn_res.quantity)

        # 查 deposits 表获取记录
        deposit_res = Deposits.select(Deposits.quantity).where(
            (Deposits.txn_alias == txn_alias) & (Deposits.asset_id == asset_id) & ((Deposits.status == 'success') | (Deposits.status == 'pending')))
        if deposit_res:
            used_lst = [res.quantity for res in deposit_res]
            used_amount = get_used_amount(used_lst)

    elif side == "settlement":
        # settle ment 与 payment 相反
        if txn_res.side == "buy":
            txn_amount = Calc(txn_res.quantity)
        else:
            txn_amount = Calc(txn_res.total)

        withdrawal_res = Withdrawals.select(Withdrawals.quantity).where(
            (Withdrawals.txn_alias == txn_alias) & (Withdrawals.asset_id == asset_id) & ((Withdrawals.status == 'success') | (Withdrawals.status == 'pending')))
        if withdrawal_res:
            used_lst = [res.quantity for res in withdrawal_res]
            used_amount = get_used_amount(used_lst)

    # 已用数量 + 本次转账数量
    logger.info(f"已用数量:{used_amount}, 本次转账数量:{amount}, Transactions表的数量:{txn_amount.value}")
    total_amount = Calc(Calc(used_amount) + Calc(amount))
    if total_amount.value > txn_amount.value:
        return False
    return True


def check_address(asset_id, tenant, account_id, side, entity, vault_id):

    if tenant == "zerocap_portal":
        destination_workspace = ZerocapPortalWorkSpce
    elif tenant == "viva":
        destination_workspace = VivaWorkSpce
    else:
        raise ZCException(f"Invalid tenant:{tenant}!")

    if entity == EntityVesper:
        vault_id_otc = config["ZEROCAP_OTC_MAPPING"]["vesper"]["vault_id"]
    elif entity == EntityZerocap:
        vault_id_otc = config["ZEROCAP_OTC_MAPPING"]["zerocap"]["vault_id"]
    else:
        raise ZCException(f"Invalid entity:{entity}")

    wallet_id = ''
    # Payment
    if side == 'payment':
        res = InternalWallets.select(InternalWallets.internal_wallet_id).where(
            InternalWallets.asset_id == asset_id,
            InternalWallets.vault_id == vault_id_otc,
            InternalWallets.source_workspace == 'Zerocap',
            InternalWallets.status == 'APPROVED',
            InternalWallets.destination_workspace == destination_workspace).first()
        if res:
            wallet_id = res.internal_wallet_id
    # Settlement
    elif side == 'settlement':
        res = ExternalWalletPropTrading.select(ExternalWalletPropTrading.external_wallet_id).where(
            ExternalWalletPropTrading.asset_id == asset_id,
            ExternalWalletPropTrading.vault_id == vault_id,
            ExternalWalletPropTrading.account_id == account_id,
            ExternalWalletPropTrading.status == 'APPROVED',
            ExternalWalletPropTrading.workspace == 'Zerocap').first()
        if res:
            wallet_id = res.external_wallet_id
    else:
        raise ZCException("Invalid type!")

    return wallet_id


def add_fiat_transaction_history(fiat_txn_data):
    logger.info(f"add fiat txn history data: {fiat_txn_data}")
    FiatTransactionsHistory.insert(fiat_txn_data).execute()


def add_deposit(deposit_data):
    logger.info(f"add deposit data: {deposit_data}")
    Deposits.insert(deposit_data).execute()


def add_withdrawal(withdrawal_data):
    logger.info(f"add withdrawal data: {withdrawal_data}")
    Withdrawals.insert(withdrawal_data).execute()


def delete_extra_zero(num):
    num_list = str(num).split(".")
    if len(num_list) == 1:
        return num_list[0]
    result = num_list[0] + "." + num_list[1].rstrip("0")
    return result.rstrip(".")


def get_assets_type(assets_list=None):
    # 获取币种类型，数字币、法币、稳定币等等
    flt = [Assets.status == 'active']
    if assets_list:
        flt.append(Assets.id.in_(assets_list))
    response = Assets.select().where(reduce(operator.and_, flt))
    result = {}
    if response:
        for res in response:
            if res.type == "Fiat":
                asset_type = "fiat"
            elif res.type != "Fiat" and str(res.is_stable) == "False":
                asset_type = "crypto"
            elif str(res.is_stable) == 'True':
                asset_type = "stable_currency"
            else:
                logger.error(f"Invalid asset id: {res.id}!")
                raise Exception("Invalid asset id!")
            result[res.id] = asset_type
    return result


def get_process_digits(asset_id, amount):
    # 数字币，需要特殊处理
    special_assets = ['BTC', 'ETH']
    asset_type = get_assets_type([asset_id])[asset_id]
    logger.info(f"asset type {asset_type} asset id {asset_id}")

    # 数字币
    if asset_type == 'crypto' and asset_id not in special_assets:
        # 大于 1 直接截断, 小于 1 保留 4 位有效位数
        new_amount = Calc.get_num_by_prec(amount, 4) if Calc(amount).value >= Calc(1).value else retain_significant_digits(
            amount, 4)
        return new_amount
    elif asset_id in special_assets:
        # BTC、ETH: 数字币特殊处理, 数量保留 4 位, 直接截断
        new_amount = delete_extra_zero(Calc.get_num_by_prec(amount, 4))  # BTC ETH 数量不补 0
        return new_amount

    new_amount = Calc.get_num_by_prec(amount, ASSETS_SETTING[asset_type]['quantity'])
    logger.info(f"new_amount {new_amount}")
    return new_amount


def handle_fiat_and_cannot_transfer(request):
    """
    用来处理不能转账, 但是是法币的情况, 保持事务操作:
    1. 不在六种支持的法币中，直接返回错误提示;
    2. 不需要创建 txn history, 记录 fiat txn history;
    3. 同步 balances 表余额, balances 记录更新需将原有的记录置为 inactive, 再插入新的记录:
        a. payment 操作需要减去余额
        b. settlement 操作并且选择提到银行账户, 不需要同步 balances 余额
        c. settlement 操作并且没有选择提到银行账户, 需要同步 balances 余额
        d. settlement 操作时如果没有 balances 数据要直接新增一条记录
    4. 同步 deposits(payment)、withdrawal(settlement) 表:
        a. tx_hash、receiving_address、sending_address 字段为空
        b. settlement 并提到银行, withdrawal 表中 bank_details 记录 userbankinfo 表中的 bank_id, 没有则留空
        c. settlement 操作时, withdrawal 表中的 to_portal 写死为 true
    5. 勾选 Notify Customer 时，需发送邮件通知
    """
    side = request.side
    asset_id = request.asset_id
    amount = request.amount
    user_id = request.user_id
    account_id = request.account_id
    trader_identifier = request.trader_identifier
    vault_id = request.vault_id
    txn_alias = request.txn_alias
    note = request.note

    if request.asset_id not in OTCSupportedFiat:
        message = "not supported"
        return message

    alias = str(uuid.uuid1())
    transfer_notes = f"otc_{side}|{alias}|{account_id}|{vault_id}"

    # 检查是否是多笔重复添加
    whether_repeatedly_payment(request.txn_alias, asset_id, side, amount, False)

    with db.atomic():
        # 获取 fiat txn 记录相关数据
        tx_id = str(uuid.uuid1())  # fiat txn history 唯一 id, 关联 deposit or withdrawal 的 tx_id
        created_at = int(time.time() * 1000)
        _, _, individual_name, _ = get_client_name(user_id)
        trader_email = get_email_by_user_id(trader_identifier)
        user_email = get_email_by_user_id(user_id)
        entity_id = get_entity_id_by_user_id(user_id)

        # 计算 amount_usd
        if asset_id == "USD":
            price = 1
        else:
            price = get_price_by_redis_or_historical(asset_id)
        amount_usd = Calc(Calc(amount) * Calc(price))

        # 记录 fiat txn history
        fiat_txn_data = {
            "tx_id": tx_id,
            "user_id": '',
            "asset_id": asset_id,
            "amount": amount,
            "bank_account": "",
            "name_reference": individual_name,  # user id 对应的 individual name
            "customer_name": individual_name,  # user id 对应的 individual name
            "datetime": iso8601(created_at),
            "description": "",
            "channel": "",
            "category": side,  # side, payment or settlement
            "notified_customer": request.is_notify_customer,  # 是否选择发送通知
            "from_account_type": "custody" if side == "payment" else "ZC OTC",  # payment 是 custody, settlement 是 ZC OTC
            "to_account_type": "ZC OTC" if side == "payment" else "custody",  # payment 是 ZC OTC, settlement 是 custody
            "trade_id": "",
            "notes": transfer_notes,
            "comment": note,
            "created_at": created_at,
            "last_updated": created_at,
            "admin_id": trader_email,  # 当前交易员的 Email
            "email": user_email,  # 当前被操作用户的 Email
            "operate": "WITHDRAWAL" if side == "payment" else "DEPOSIT",
            "amount_usd": str(amount_usd),  # 数量 * 价格， 如果是 USD 默认为数量
            "status": "COMPLETED",
            "account_id": account_id,
            "vault_id": vault_id,
            "entity_id": entity_id
        }
        add_fiat_transaction_history(fiat_txn_data)

        if side == "payment":
            # 更新 balances 表，减去转账数量, 如果没有 balances 记录，直接抛错
            update_balance_by_account_id(account_id, vault_id, asset_id, amount, user_id, side)

            # 新增 deposit 记录
            deposit_data = {
                "deposit_alias": alias,
                "txn_alias": txn_alias,
                "asset_id": asset_id,
                "quantity": amount,
                "receiving_address": "",
                "sending_address": "",
                "tx_hash": "",
                "created_at": created_at,
                "status": "success",
                "bank_details": "",
                "trader_identifier": trader_identifier,
                "account_id": account_id,
                "note": note,
                "tx_id": tx_id  # 对应 fiat txn history 记录的 tx_id
            }
            add_deposit(deposit_data)

        elif side == "settlement":
            # 根据是否勾选 bank transfer 来判断是否要更新 balances 记录, 如果没有对应的 balances 记录，需要新增一条
            if not request.is_bank_transfer:
                burden_amount = Calc(Calc(request.amount) * Calc(-1))
                update_balance_by_account_id(account_id, vault_id, asset_id, str(burden_amount), user_id, side)

            # 新增 withdrawal 记录
            withdrawal_data = {
                "withdrawal_alias": alias,
                "txn_alias": txn_alias,
                "asset_id": asset_id,
                "quantity": amount,
                "receiving_address": "",
                "sending_address": "",
                "tx_hash": "",
                "withdrawal_time": created_at,
                "created_at": created_at,
                "status": "success",
                "to_portal": False,
                "trader_identifier": trader_identifier,
                "vault_id": vault_id,
                "account_id": account_id,
                "note": note,
                "tx_id": tx_id
            }
            if request.is_bank_transfer:
                bank_detail = request.bank_detail.replace("\"\"", "")
                withdrawal_data["bank_details"] = bank_detail

                # 如果勾选了 bank transfer 需要再记录1条反方向的 fiat txn
                fiat_txn_data["tx_id"] = str(uuid.uuid1())  # 反向记录生成新的 tx_id
                fiat_txn_data["from_account_type"] = "custody"
                fiat_txn_data["to_account_type"] = "external_withdrawal"
                fiat_txn_data["description"] = f"ems_deposit_{tx_id}"
                fiat_txn_data["operate"] = "WITHDRAWAL"
                add_fiat_transaction_history(fiat_txn_data)

            # 记录 withdrawal 数据
            add_withdrawal(withdrawal_data)

        # # 调用blotter函数
        # request_dict = {"new_alias": request.txn_alias, "old_alias": request.txn_alias, "blotter_type": "transaction"}
        # handle_blotter(ObjDict(request_dict))

        # 如果勾选 Notify Customer 发送邮件通知
        if request.is_notify_customer:
            email_service = EmailService()
            operate_type = "withdrawal" if side == "payment" else "deposit"
            request.amount = get_process_digits(asset_id, amount)
            logger.info(f"process digits: {request.amount}")
            send_fiat_or_altcoin_mail(request, operate_type, email_service)

            # 如果勾选了 bank transfer 需要再发一个反方向的的邮件
            if request.is_bank_transfer:
                operate_type = "deposit" if side == "payment" else "withdrawal"
                logger.info(f"is_bank_transfer process digits: {request.amount}")
                send_fiat_or_altcoin_mail(request, operate_type, email_service)


def handle_no_fiat_and_cannot_transfer(request):
    """
    用来处理不能转账, 且不是法币的情况, 保持事务操作:
    1. 需要创建 transactionshistory 记录，不需创建 fiattransactionshistory 记录;
    2. 同步 balances 表余额, balances 记录更新需将原有的记录置为 inactive, 再插入新的记录:
        a. payment 操作需要减去余额
        b. settlement 操作并且选择提到银行账户, 不需要同步 balances 余额
        c. settlement 操作并且没有选择提到银行账户, 需要同步 balances 余额
        d. settlement 操作时如果没有 balances 数据要直接新增一条记录
    3. 同步 deposits(payment)、withdrawal(settlement) 表:
        a. tx_hash、receiving_address、sending_address 字段为空
        b. settlement 并提到银行, withdrawal 表中 bank_details 记录 userbankinfo 表中的 bank_id, 没有则留空
        c. settlement 操作时, withdrawal 表中的 to_portal 写死为 true
    4. 勾选 Notify Customer 时，需发送邮件通知
    """
    comment = request.note
    alias = str(uuid.uuid1())
    transfer_notes = f"otc_{request.side}|{alias}|{request.account_id}|{request.vault_id}"

    # 检查是否是多笔重复添加
    whether_repeatedly_payment(request.txn_alias, request.asset_id, request.side, request.amount, False)

    with db.atomic():
        # 记录 txn history
        add_transaction_history(request.side, request.user_id, request.asset_id, request.amount, 
                                request.account_id, request.vault_id, comment, transfer_notes, request.tx_hash)

        if request.side == "payment":
            # 更新 balances 表，减去转账数量, 如果没有 balances 记录，直接抛错
            update_balance_by_account_id(request.account_id, request.vault_id, request.asset_id, request.amount, request.user_id, 
                                         request.side, request.network)

            # 新增 deposit 记录
            deposit_data = {
                "deposit_alias": alias,
                "txn_alias": request.txn_alias,
                "asset_id": request.asset_id,
                "quantity": request.amount,
                "receiving_address": "",
                "sending_address": "",
                "tx_hash": "",
                "created_at": int(time.time() * 1000),
                "status": "success",
                "bank_details": "",
                "trader_identifier": request.trader_identifier,
                "account_id": request.account_id,
                "note": request.note,
                "tx_id": ""}
            # 新增 deposit 记录
            add_deposit(deposit_data)

        elif request.side == "settlement":
            # 更新 balances 记录, 如果没有对应的 balances 记录，需要新增一条
            burden_amount = Calc(Calc(request.amount) * Calc(-1))
            update_balance_by_account_id(request.account_id, request.vault_id, request.asset_id, str(burden_amount), 
                                         request.user_id, request.side, request.network)

            # 新增 withdrawal 记录
            created_at = int(time.time() * 1000)
            withdrawal_data = {
                "withdrawal_alias": alias,
                "txn_alias": request.txn_alias,
                "asset_id": request.asset_id,
                "quantity": request.amount,
                "receiving_address": "",
                "sending_address": "",
                "tx_hash": "",
                "withdrawal_time": created_at,
                "created_at": created_at,
                "status": "success",
                "to_portal": False,
                "trader_identifier": request.trader_identifier,
                "vault_id": request.vault_id,
                "account_id": request.account_id,
                "note": request.note,
                "tx_id": ""}
            if request.is_bank_transfer:
                withdrawal_data["bank_details"] = request.bank_detail
            add_withdrawal(withdrawal_data)

        # # 调用blotter函数
        # request_dict = {"new_alias": request.txn_alias, "old_alias": request.txn_alias, "blotter_type": "transaction"}
        # handle_blotter(ObjDict(request_dict))

        # 如果勾选 Notify Customer 发送邮件通知
        if request.is_notify_customer:
            email_service = EmailService()
            operate_type = "withdrawal" if request.side == "payment" else "deposit"
            request.amount = get_process_digits(request.asset_id, request.amount)
            send_fiat_or_altcoin_mail(request, operate_type, email_service)


def add_transaction_history(side, user_id, asset_id, amount, account_id, vault_id, comment, notes, tx_hash=''):
    user_email = get_email_by_user_id(user_id)
    entity_id = get_entity_id_by_user_id(user_id)
    timestamp = int(time.time()) * 1000

    # 获取asset_id对应的USD的价格
    res_data = get_symbol_price_by_ccxt_or_redis(f"{asset_id}/USD", CHANNEL_DEFAULT_ORDER, "two_way")
    if res_data['buy_price']['price'] != 0:
        price = res_data['buy_price']['price']
    elif res_data['sell_price']['price'] != 0:
        price = res_data['sell_price']['price']
    else:
        # 价格超时，去 historical 获取价格
        price = get_history_price_by_asset(asset_id)
    amount_usd = Calc(Calc(amount) * Calc(price))

    if side == 'payment':
        type_txn = 'payment_confirmation'
        from_account_type = 'custody'
        to_account_type = 'ZC OTC'
        operation = 'WITHDRAWAL'

    else:
        type_txn = 'settlement_confirmation'
        from_account_type = 'ZC OTC'
        to_account_type = 'custody'
        operation = 'DEPOSIT'

    txn_data = {
            'user_id': '',
            'tx_id': str(uuid.uuid4()),
            'tx_hash': tx_hash,
            'asset_id': asset_id,
            'amount': amount,
            'created_at': timestamp,
            'last_updated': timestamp,
            'datetime': iso8601(timestamp),
            'token': '',
            'type': type_txn,
            'operation': operation,
            'status': 'COMPLETED',
            'note': notes,
            'interest_earned': '0',
            'amount_usd': amount_usd,
            'webhook_updated': False,
            'comment': comment,
            'account_id': account_id,
            'vault_id': vault_id,
            'email': user_email,
            'entity_id': entity_id,
            'from_account_type': from_account_type,
            'to_account_type': to_account_type,
        }
    logger.info(f"add txn history data: {txn_data}")
    TransactionsHistory.insert(txn_data).execute()


def check_payment_parameter(request):
    # 将 grpc 的 message 转为字典
    # including_default_value_fields 将未传的参数也会转化
    # preserving_proto_field_name 保留原本的参数名，不会进行大小写转换
    parameter = MessageToDict(request, including_default_value_fields=True, preserving_proto_field_name=True)
    need_check_empty = ['category', 'txn_alias', 'asset_id', 'side', 'amount', 'account_id', 'vault_id', 'user_id',
                        'trader_identifier', 'entity']

    need_check_exist = ['is_bank_transfer', 'is_notify_customer']
    for column in need_check_exist:
        if column not in parameter.keys():
            logger.error(f"check_payment_parameter, invalid argument, {column} is absent!")
            text = f"{column} is absent!"
            raise ZCException(text)

    for key, val in parameter.items():

        if key == 'category' and val not in ('fb', 'fiat', 'off_fb'):
            raise Exception("invaild category!")

        if  key == 'side' and val not in ('payment', 'settlement'):
            raise Exception("invaild side!")

        if key == 'entity' and val not in ("zerocap", "vesper"):
            raise Exception("invaild entity!")

        # 需要校验参数need_check_empty不能为空
        if key in need_check_empty and not val:
            logger.error(f"check_payment_parameter, invalid argument, {key} is empty!")
            text = f"{key} is empty!"
            raise ZCException(text)


def check_settle_check_parameter(request):
    # 将 grpc 的 message 转为字典
    # including_default_value_fields 将未传的参数也会转化
    # preserving_proto_field_name 保留原本的参数名，不会进行大小写转换
    parameter = MessageToDict(request, including_default_value_fields=True, preserving_proto_field_name=True)
    need_check_empty = ['user_id', 'account_id', 'vault_id', 'trader_identifier', 'asset', 'quantity', 'side', 'entity',
                        'txn_alias', 'base_asset', 'quote_asset']
    need_check_quantity = ['quantity']
    need_check_isdigit = ['vault_id']
    for key, val in parameter.items():

        # 需要校验参数need_check_empty不能为空
        if key in need_check_empty and not val:
            logger.error(f"settle_check invalid argument, {key} is empty!")
            text = f"{key} is empty!"
            raise ZCException(text)

        # 需要校验参数need_check_isdigit为正整数
        if key in need_check_isdigit and val and not val.isdigit():
            logger.error(f"settle_check invalid argument, {key} must be a positive integer")
            text = f"{key} must be a positive integer"
            raise ZCException(text)

        # 需要校验quantity
        if key in need_check_quantity:
            if not val:
                logger.error(f"settle_check invalid argument, {key} is empty!")
                text = f"{key} is empty!"
                raise ZCException(text)
            if not Calc.is_num(val):
                logger.error(f"settle_check invalid argument, {key} is not a number!")
                text = f"{key} is not a number!"
                raise ZCException(text)
            if float(val) <= 0:
                logger.error(f"settle_check invalid argument, {key} must be greater than 0!")
                text = f"{key} must be greater than 0!"
                raise ZCException(text)

        if key == "side" and val != "payment" and val != "settlement":
            logger.error("settle_check invalid argument, side type incorrect")
            text = "side type incorrect"
            raise ZCException(text)

        if key == "entity" and val not in ["zerocap", "vesper"]:
            logger.error("check_settle_check_parameter: Invalid entity!")
            raise ZCException("Invalid entity!")


def get_deposit(txn_alias=None, tx_id=None, deposit_alias=None):
    deposit_select = Deposits.select()
    if txn_alias:
        deposit_select = deposit_select.where(
            Deposits.txn_alias == txn_alias)
    if tx_id:
        deposit_select = deposit_select.where(
            Deposits.tx_id == tx_id)
    if deposit_alias:
        deposit_select = deposit_select.where(
            Deposits.deposit_alias == deposit_alias)

    deposit_select = deposit_select.order_by(Deposits.created_at.desc())
    if deposit_select:
        result = []
        for i in deposit_select:
            data = {
                'account_id': i.account_id,
                'asset_id': i.asset_id,
                'operation': 'Deposits',
                'quantity': i.quantity,
                'status': i.status,
                'tx_id': i.tx_id,
                'create_at': timestamp_to_time(i.created_at),
                'txn_alias': i.txn_alias,
            }
            result.append(data)
        return result
    return []


def get_txn_data_by_tx_id(tx_id):
    res = TransactionsHistory.select(TransactionsHistory.asset_id, TransactionsHistory.from_account_type,
                               TransactionsHistory.to_account_type, TransactionsHistory.fee_currency,
                               TransactionsHistory.fee, TransactionsHistory.substatus, TransactionsHistory.type,
                               TransactionsHistory.status, TransactionsHistory.amount, TransactionsHistory.vault_id,
                               TransactionsHistory.account_id, TransactionsHistory.note, TransactionsHistory.tx_hash,
                               TransactionsHistory.comment, TransactionsHistory.source_address,
                               TransactionsHistory.destination_address, TransactionsHistory.destination_id
                               ).where(TransactionsHistory.tx_id == tx_id).first()
    if not res:
        raise ZCException("invalid tx_id!")
    return res


def update_yields_pending_rejected(tx_id, update_data):

    YieldsPending.update(update_data).where(YieldsPending.tx_id == tx_id).execute()


def create_yieldspending(yieldspending_dic):
    yieldspending_lst = [yieldspending_dic]
    YieldsPending.insert_many(yieldspending_lst).execute()


def query_interwallet_by_wallet_id(wallet_id, asset_id):
    res = InternalWallets.select(InternalWallets.address)
    if wallet_id:
        res = res.where(InternalWallets.internal_wallet_id == wallet_id)

    if asset_id:
        res = res.where(InternalWallets.asset_id == asset_id)

    res = res.first()
    return res.address if res else ''


def update_deposit_by_tx_id(tx_id, update_data):
    Deposits.update(update_data).where(Deposits.tx_id == tx_id).execute()


def update_withdrawal_by_tx_id(tx_id, update_data):
    Withdrawals.update(update_data).where(Withdrawals.tx_id == tx_id).execute()


def get_pending_quantity_by_txn_alias(txn_alias, side):
    response = []
    if side == "payment":
        response = Deposits.select(Deposits.quantity).where(
            (Deposits.txn_alias == txn_alias) & (Deposits.status == 'pending'))
    elif side == "settlement":
        response = Withdrawals.select(Withdrawals.quantity).where(
            (Withdrawals.txn_alias == txn_alias) & (Withdrawals.status == 'pending'))

    quantity = Calc(0)
    for res in response:
        quantity = Calc(quantity + Calc(res.quantity))
    return quantity


def get_deposit_by_txn_alias(txn_alias):
    res = Deposits.select(Deposits, TransactionsHistory)\
        .join(TransactionsHistory, JOIN.LEFT_OUTER, on=(TransactionsHistory.note.contains(Deposits.deposit_alias)))\
        .where((Deposits.txn_alias == txn_alias) & (Deposits.status == 'success'))
    tx_hash_list = []
    created_at_lsit = []
    note_list = []
    for i in res:
        created_at_lsit.append(i.created_at)
        if i.tx_hash:
            tx_hash_list.append(i.tx_hash)
        if hasattr(i, 'transactionshistory') and i.transactionshistory.note:
            note_list.append(i.transactionshistory.note)
    if created_at_lsit:
        return {'created_at': min(created_at_lsit),
                'tx_hash': '|'.join(tx_hash_list),
                'note': note_list}
    return None


def get_withdrawals_by_txn_alias(txn_alias):
    res = Withdrawals.select(Withdrawals, TransactionsHistory)\
        .join(TransactionsHistory, JOIN.LEFT_OUTER, on=(TransactionsHistory.note.contains(Withdrawals.withdrawal_alias)))\
        .where((Withdrawals.txn_alias == txn_alias) & (Withdrawals.status == 'success'))
    tx_hash_list = []
    created_at_lsit = []
    note_list = []
    quantity_list = []
    for i in res:
        created_at_lsit.append(i.created_at)
        quantity_list.append(float(i.quantity))
        if i.tx_hash:
            tx_hash_list.append(i.tx_hash)
        if hasattr(i, 'transactionshistory') and i.transactionshistory.note:
            note_list.append(i.transactionshistory.note)
    if created_at_lsit:
        return {'created_at': min(created_at_lsit),
                'tx_hash': '|'.join(tx_hash_list),
                'note': note_list,
                'quantity_list': quantity_list}
    return None


def get_withdrawals_quantity_by_txn_alias(txn_alias):
    res = Withdrawals.select(Withdrawals.quantity).where((Withdrawals.txn_alias == txn_alias) & (Withdrawals.status == 'success'))
    if res:
        all_quantity = sum([float(i.quantity) for i in res if i.quantity is not None])
    else:
        all_quantity = 0
    return all_quantity


def get_deposit_quantity_by_txn_alias(txn_alias):
    res = Deposits.select(Deposits.quantity).where((Deposits.txn_alias == txn_alias) & (Deposits.status == 'success'))
    if res:
        all_quantity = sum([float(i.quantity) for i in res if i.quantity is not None])
    else:
        all_quantity = 0
    return all_quantity


def get_assets_stable():
    # 获取稳定币
    res = Assets.select(Assets.ticker).where((Assets.status == 'active') & (Assets.is_stable == True))
    stable_currency = []
    for i in res:
        stable_currency.append(i.ticker)
    return stable_currency


def get_assets_fiat():
    # 获取非USD的法币
    res = Assets.select(Assets.ticker).where((Assets.status == 'active') & (Assets.type == 'Fiat') &
                                             (Assets.ticker != 'USD'))
    stable_currency = []
    for i in res:
        stable_currency.append(i.ticker)
    return stable_currency


def handle_transaction(new_alias, trade_conv):
    # 查询transaction表数据
    res = get_transactions_by_alias(new_alias)
    status = res.status
    trader_emil = get_email_by_user_id(res.trader_identifier)
    entity_name = get_entity_name(res.account_id)
    user_emil = get_email_by_user_id(res.user_id)
    stable_currency = get_assets_stable()
    fiats = get_assets_fiat()
    if res.fee_notional == 'bps':
        fee = f'{Calc(Calc(res.fee) / Calc(100)).value} %'
    elif res.fee_notional == 'base':
        fee = f'{res.fee} {res.base_asset}'
    elif res.fee_notional == 'quote':
        fee = f'{res.fee} {res.quote_asset}'
    else:
        raise ZCException('Invalid fee_notional')

    # 获取asset/USD的价格(币种美金价格)
    price = {'base': '0', 'quote': '0'}
    assets = {'base': res.base_asset, 'quote': res.quote_asset}
    for key in assets:
        value = assets[key]
        if value == 'USD':
            quote_price = '1'
        else:
            res_data = get_symbol_price_by_ccxt_or_redis(f"{value}/USD", CHANNEL_DEFAULT_ORDER, "two_way")
            if res_data['buy_price']['price'] != 0:
                quote_price = res_data['buy_price']['price']
            elif res_data['sell_price']['price'] != 0:
                quote_price = res_data['sell_price']['price']
            else:
                logger.error(f"blotter: could not get price: {value}/USD")

                # 从history_price中获取,对key对USD的价格
                quote_price = get_history_price_by_asset(value)
                if quote_price == "0":
                    logger.error(f"get_history_price_by_asset: could not get price: {value}")
        price[key] = quote_price

    # 计算markup_USD
    otc_usd_markup = str(Calc(Calc(Calc(abs(Calc(res.quote_price) - Calc(res.raw_price))) * Calc(price['quote'])) * Calc(res.quantity)))

    # 计算fee_USD
    if res.fee_notional == 'base':
        otc_usd_fee = str(Calc(Calc(res.fee_amount) * Calc(price['base'])))
    else:
        otc_usd_fee = str(Calc(Calc(res.fee_amount) * Calc(price['quote'])))

    # 计算cust_volume_otc
    cust_volume_otc = str(Calc(Calc(res.quote_quantity) * Calc(price['quote'])))

    res_deposit = get_deposit_by_txn_alias(new_alias)
    date_payment_arrived = ''
    payment_txid_or_reference = ''
    note_deposit = []
    if res_deposit:
        date_payment_arrived = handle_timestamp(res_deposit.get('created_at', ''))[1]
        payment_txid_or_reference = res_deposit.get('tx_hash', '')
        note_deposit = res_deposit.get('note', [])

    deposits_flag = False
    all_deposits_quantity = get_deposit_quantity_by_txn_alias(new_alias)
    if all_deposits_quantity > 0:
        if res.side == 'buy':
            deposits_quantity = float(res.total)
        else:
            deposits_quantity = float(res.quantity)

        if Calc(all_deposits_quantity).value >= Calc(deposits_quantity).value or \
            Calc(abs(all_deposits_quantity - deposits_quantity)).value <= Calc(deposits_quantity/1000).value:
            deposits_flag = True

    res_withdrawals = get_withdrawals_by_txn_alias(new_alias)
    date_settlement_sent = ''
    settlement_txid_reference = ''
    asset_location = 'N'
    note_withdrawals = []
    if res_withdrawals:
        date_settlement_sent = handle_timestamp(res_withdrawals.get('created_at', ''))[1]
        settlement_txid_reference = res_withdrawals.get('tx_hash', '')
        note_withdrawals = res_withdrawals.get('note', [])
        asset_location = 'Y'

    withdrawals_flag = False
    all_withdrawals_quantity = get_withdrawals_quantity_by_txn_alias(new_alias)
    if all_withdrawals_quantity > 0:
        if res.side == 'buy':
            withdrawals_quantity = float(res.quantity)
        else:
            withdrawals_quantity = float(res.total)

        # 如果提现数大于等于转账数，或者提现数和转账数的差额小于千分之一，默认为完全提取了
        if Calc(all_withdrawals_quantity).value >= Calc(withdrawals_quantity).value or \
            Calc(abs(all_withdrawals_quantity - withdrawals_quantity)).value <= Calc(withdrawals_quantity/1000).value:
            withdrawals_flag = True

    kyc_approved, _, _ = get_kyc_and_pa_and_name_by_account(res.account_id)
    # 默认为新增数据，如果old_alias存在，且new_alias的状态不是deleted，为编辑数据
    settled = 'N'
    if not kyc_approved:
        color = 'red'
    else:
        asset = res.base_asset if res.side == 'buy' else res.quote_asset
        fiat_flag, bank_list = is_fiat_asset(asset, '')
        color = 'cyan' if fiat_flag == 'True' else 'green'
        if deposits_flag and withdrawals_flag and status == 'completed':
            settled = 'Y'
            color = 'white'
        elif deposits_flag and not withdrawals_flag and all_withdrawals_quantity == 0:
            color = 'orange'

    note_withdrawals.extend(note_deposit)
    notes = '#'.join(note_withdrawals)

    # 交易对中含有BTC或着ETH
    btc_eth = ''
    btc_eth_pnl = ''
    # 稳定币对USD的
    stablecoin_vol = ''
    stablecoin_vol_pnl = ''
    # 稳定币对非USD的法币
    fx_stablecoin = ''
    fx_stablecoin_pnl = ''
    # 其他
    altcoin_vol = ''
    altcoin_vol_pnl = ''
    if res.base_asset in ['BTC', 'ETH'] or res.quote_asset in ['BTC', 'ETH']:
        btc_eth = cust_volume_otc
        btc_eth_pnl = str(Calc(Calc(res.pnl) * Calc(price['quote'])))
    # 稳定币对USD的
    elif (res.base_asset in stable_currency and res.quote_asset == 'USD') or \
            (res.quote_asset in stable_currency and res.base_asset == 'USD'):
        stablecoin_vol = cust_volume_otc
        stablecoin_vol_pnl = str(Calc(Calc(res.pnl) * Calc(price['quote'])))
    # 稳定币对非USD的法币
    elif (res.base_asset in stable_currency and res.quote_asset in fiats) or \
            (res.quote_asset in stable_currency and res.base_asset in fiats):
        fx_stablecoin = cust_volume_otc
        fx_stablecoin_pnl = str(Calc(Calc(res.pnl) * Calc(price['quote'])))
    else:
        altcoin_vol = cust_volume_otc
        altcoin_vol_pnl = str(Calc(Calc(res.pnl) * Calc(price['quote'])))

    data = {
        'trade': trade_conv.get(trader_emil, trader_emil),
        'settled': settled,
        'is_ems': 'Y',
        'ems_status': 'H' if res.hedge == 'live hedge' else 'NH',
        'setting_to': res.settlement_destination,
        'trade_no': '',                        # 稍后处理
        'data_time': handle_timestamp(res.created_at)[0],
        'counterparty': entity_name,
        'reference': user_emil,
        'referer': '',
        'counterparty_bs_1': 'B' if res.side == 'buy' else 'S',
        'base_asset_ccy': res.base_asset,
        'base_amount': res.quantity,
        'counterparty_bs_2': 'S' if res.side == 'buy' else 'B',
        'quote_asset_ccy': res.quote_asset,
        'quote_amount': res.total,
        'counterparty_rate': res.quote_price,
        'fee': fee,
        'ref_fee': '',
        'otc_usd_markup': otc_usd_markup,
        'otc_usd_fee': otc_usd_fee,
        'prop_fx_hedge': '',
        'cust_volume_otc': cust_volume_otc,
        'date_payment_arrived': date_payment_arrived,
        'payment_txid_or_reference': payment_txid_or_reference,
        'date_settlement_sent': date_settlement_sent,
        'settlement_txid_reference': settlement_txid_reference,
        'portal_balance_adjustment': asset_location,
        'asset_location': '',
        'notes': notes,
        'btc_eth': btc_eth,
        'altcoin_vol': altcoin_vol,
        'stablecoin_vol': stablecoin_vol,
        'treasury': '',
        'fx_stablecoin': fx_stablecoin,
        'btc_eth_pnl': btc_eth_pnl,
        'altcoin_vol_pnl': altcoin_vol_pnl,
        'stablecoin_vol_pnl': stablecoin_vol_pnl,
        'treasury_pnl': '',
        'fx_stablecoin_pnl': fx_stablecoin_pnl,
        'data_type': 'txn',
        'txn_alias': '',
        'color': color,
        'order_id': '',
        'data_source': ''
    }
    return data, status


def handle_fills(new_alias, trade_conv):
    # 查询fills表数据
    res = get_fills_by_alias(new_alias)
    status = res.status
    trader_emil = get_email_by_user_id(res.trader_identifier)
    txn_alias = ''
    if res.txn_alias:
        txn_alias = res.txn_alias

    data = {
        'trade': trade_conv.get(trader_emil, trader_emil),
        'settled': '',
        'is_ems': 'Y',
        'ems_status': 'Talso' if res.data_sources == 'talos_trade_history' else 'Fills',
        'setting_to': res.settlement_destination,
        'trade_no': '',                        # 稍后处理
        'data_time': handle_timestamp(res.created_at)[0],
        'counterparty': res.dealers,
        'reference': '',                        # 稍后处理
        'referer': '',
        'counterparty_bs_1': 'S' if res.side == 'buy' else 'B',          # 稍后处理
        'base_asset_ccy': res.base_asset,
        'base_amount': res.quantity,
        'counterparty_bs_2': 'B' if res.side == 'buy' else 'S',
        'quote_asset_ccy': res.quote_asset,
        'quote_amount': res.quote_quantity,
        'counterparty_rate': res.exec_price,
        'fee': '',
        'ref_fee': '',
        'otc_usd_markup': '',
        'otc_usd_fee': '',
        'prop_fx_hedge': '',
        'cust_volume_otc': '',
        'date_payment_arrived': 'LP',
        'payment_txid_or_reference': 'LP',
        'date_settlement_sent': 'LP',
        'settlement_txid_reference': 'LP',
        'portal_balance_adjustment': '',
        'asset_location': '',
        'notes': '',
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
        'data_type': 'fills',
        'txn_alias': txn_alias,
        'color': '',
        'order_id': '',
        'data_source': ''
    }
    return data, status


def handle_treasury(new_alias, trade_conv):
    # 查询treasury表数据
    res = get_treasury_by_alias(new_alias)
    status = res.status.value
    trader_emil = get_email_by_user_id(res.trader_identifier)
    entity_name = get_entity_name(res.account_id)
    user_emil = get_email_by_user_id(res.user_id)

    if res.fee_notional.value == 'bps':
        fee = f'{Calc(Calc(res.fee) / Calc(100)).value} %'
    elif res.fee_notional.value == 'base':
        fee = f'{res.fee} {res.asset_id}'
    else:
        raise ZCException('Invalid fee_notional')

    if res.asset_id == 'USD':
        quote_price = '1'
    else:
        res_data = get_symbol_price_by_ccxt_or_redis(f"{res.asset_id}/USD", CHANNEL_DEFAULT_ORDER, "two_way")
        if res_data['buy_price']['price'] != 0:
            quote_price = res_data['buy_price']['price']
        elif res_data['sell_price']['price'] != 0:
            quote_price = res_data['sell_price']['price']
        else:
            logger.error(f"blotter: could not get price: {res.asset_id}/USD")

            # 从history_price中获取,对key对USD的价格
            quote_price = get_history_price_by_asset(res.asset_id)
            if quote_price == "0":
                logger.error(f"get_history_price_by_asset: could not get price: {res.asset_id}")

    # 计算fee_USD
    otc_usd_fee = str(Calc(Calc(res.fee_amount) * Calc(quote_price)))
    # 计算cust_volume_otc
    cust_volume_otc = str(Calc(Calc(res.amount) * Calc(quote_price)))

    data = {
        'trade': trade_conv.get(trader_emil, trader_emil),
        'settled': '',
        'is_ems': 'Y',
        'ems_status': 'TSY',
        'setting_to': res.settlement_destination,
        'trade_no': '',                        # 稍后处理
        'data_time': handle_timestamp(res.created_at)[0],
        'counterparty': entity_name,
        'reference': user_emil,
        'referer': '',
        'counterparty_bs_1': 'B',
        'base_asset_ccy': res.asset_id,
        'base_amount': res.amount,
        'counterparty_bs_2': 'S',
        'quote_asset_ccy': res.asset_id,
        'quote_amount': res.total,
        'counterparty_rate': '1.0000',
        'fee': fee,
        'ref_fee': '',
        'otc_usd_markup': '',
        'otc_usd_fee': otc_usd_fee,
        'prop_fx_hedge': '',
        'cust_volume_otc': cust_volume_otc,
        'date_payment_arrived': handle_timestamp(res.created_at)[1],
        'payment_txid_or_reference': '',    # 稍后处理
        'date_settlement_sent': handle_timestamp(res.created_at)[1],
        'settlement_txid_reference': res.destination_address,
        'portal_balance_adjustment': '',
        'asset_location': '',
        'notes': res.notes,
        'btc_eth': '',
        'altcoin_vol': '',
        'stablecoin_vol': '',
        'treasury': cust_volume_otc,   # amount转USD
        'fx_stablecoin': '',
        'btc_eth_pnl': '',
        'altcoin_vol_pnl': '',
        'stablecoin_vol_pnl': '',
        'treasury_pnl': otc_usd_fee,   # fee notional转USD
        'fx_stablecoin_pnl': '',
        'data_type': 'treasury',
        'txn_alias': '',
        'color': '',
        'order_id': '',
        'data_source': ''
    }
    return data, status


def handle_blotter(request):
    old_alias = request.old_alias
    new_alias = request.new_alias
    blotter_type = request.blotter_type
    logger.info(f'handle_blotter old_alias: {old_alias}, new_alias: {new_alias}, blotter_type: {blotter_type}')

    trade_conv = {
        "kurt@zerocap.io": "KG",
        "william@zerocap.com": "WF",
        "berkeley@zerocap.com": "BC",
        "joe@zerocap.com": "JW",
        "parth@zerocap.com":"PS",
        "sam.holman@zerocap.com": "SH",
        "caleb.wong@zerocap.com": "CW",
        "denzy.rebello@zerocap.com": "DR",
        "edward.goldman@zerocap.com": "EG",
        "toby@zerocap.com": "TC",
        "jon@zerocap.com": "JD"}

    if blotter_type == 'transaction':
        data, status = handle_transaction(new_alias, trade_conv)
    elif blotter_type == 'fills':
        data, status = handle_fills(new_alias, trade_conv)
    elif blotter_type == 'treasury':
        data, status = handle_treasury(new_alias, trade_conv)
    else:
        raise ZCException('Invalid blotter type')

    # 判断是add_blotter 或 edit_blotter
    data['operate'] = 'add_blotter'
    if new_alias:
        data['old_alias'] = ''
        data['new_alias'] = new_alias

    if old_alias and status != 'deleted':
        data['old_alias'] = old_alias
        data['operate'] = 'edit_blotter'
    elif old_alias and status == 'deleted':
        data['old_alias'] = old_alias
        data['operate'] = 'deleted_blotter'

    logger.info(f'data: {data}')
    send_task_to_queue(**data)
    return dict(
        status=ResponseStatusSuccessful
    )


def get_deposit_by_tx_id(tx_id):
    return Deposits.select().where(Deposits.tx_id == tx_id).first()


def get_withdrawals_by_tx_id(tx_id):
    return Withdrawals.select().where(Withdrawals.tx_id == tx_id).first()


def get_transactions_by_alias(txn_alias):
    response = Transactions.select().where(Transactions.txn_alias == txn_alias).first()
    return response


def handle_timestamp(timestamp):
    time_stamp = int(timestamp) / 1000
    # 转换为其他日期格式,如:"%Y-%m-%d %H:%M:%S"
    time_array = time.localtime(time_stamp)
    alp_format_time = time.strftime("%d-%b-%Y", time_array)
    num_format_time = time.strftime("%d/%m/%Y", time_array)
    return alp_format_time, num_format_time


def whether_repeatedly_payment(txn_alias, asset_id, side, amount, is_usdt):
    """
    payment 发起前检查 deposit 表中是否已经有数据存在，有数据存在则抛错;
    如果是 usdt 则检查转账数量是否大于 txn 记录中的总额, 大于总额也要抛错;
    """
    logger.info(f"whether_repeatedly_payment: txn_alias: {txn_alias}, asset_id: {asset_id}, side: {side}, is_usdt: {is_usdt}")
    if is_usdt:
        amount_check = check_txn_amount(txn_alias, asset_id, side, amount)
        if not amount_check:
            raise ZCException("The transfer amount is greater than the txn total!")
        return

    if side == "payment":
        deposit_res = Deposits.select(Deposits.deposit_alias).where(
            (Deposits.txn_alias == txn_alias) & (Deposits.asset_id == asset_id) & ((Deposits.status == 'success') | (Deposits.status == 'pending'))).first()
        if deposit_res:
            logger.info(f"不可重复添加 payment txn_alias: {txn_alias}, deposit_alias: {deposit_res.deposit_alias}")
            raise ZCException("Payment cannot be added repeatedly!")

    elif side == "settlement":
        withdrawal_res = Withdrawals.select(Withdrawals.withdrawal_alias).where(
            (Withdrawals.txn_alias == txn_alias) & (Withdrawals.asset_id == asset_id) & ((Withdrawals.status == 'success') | (Withdrawals.status == 'pending'))).first()
        if withdrawal_res:
            logger.info(f"不可重复添加 settlement txn_alias: {txn_alias}, withdrawal_alias: {withdrawal_res.withdrawal_alias}")
            raise ZCException("Settlement cannot be added repeatedly!")


def update_quotes_transaction_by_txn_alias(update_dict, txn_alias, tc):
    Quotes.update(update_dict).where(Quotes.txn_alias == txn_alias).execute()
    Transactions.update(update_dict).where(Transactions.txn_alias == txn_alias).execute()
    tc.commit()  # 数据落盘


def get_receipt_data(txn_data):
    """
    拼接发送凭据data
    :param txn_data:
    :return:
    """
    receipt_data = {
        "txn_alias": txn_data['txn_alias'],
        "user_id": txn_data['user_id'],
        "account_id": txn_data['account_id'],
        "base_asset": txn_data['base_asset'],
        "quote_asset": txn_data['quote_asset'],
        "created_at": txn_data['created_at'],
        "side": txn_data['side'],
        "quantity": txn_data['quantity'],
        "price": txn_data['quote_price'],
        "quote_quantity": txn_data['quote_quantity'],
        "fees": "",
        "total": txn_data['total'],
        "entity": txn_data['entity'],
        "trader_identifier": txn_data['trader_identifier'],
        "hedge": txn_data['hedge'],
        "fee_notional": txn_data['fee_notional'],
        "order_type": txn_data['order_type']
    }

    fees = get_fees(txn_data['fee_notional'], txn_data['fee'], txn_data['base_asset'], txn_data['quote_asset'])
    receipt_data["fees"] = fees
    return receipt_data


def get_fees(fee_notional, fee, base_asset, quote_asset):
    """
    fee 字段特殊处理
    :param fee_notional:
    :param fee:
    :param base_asset:
    :param quote_asset:
    :return:
    """
    # 生成交易凭据的 fees 计算
    if fee_notional == "bps":
        fee_pct = Calc(fee) / Calc(100)
        fees = f"{str(fee_pct)} %"
    elif fee_notional == "base":
        fees = f"{fee} {base_asset}"
    else:
        fees = f"{fee} {quote_asset}"
    return fees


def query_transaction_by_txn_alias(txn_alias):
    response = Transactions.select().where((Transactions.txn_alias==txn_alias) &
                                               (Transactions.status != 'deleted')).first()
    result = {}
    if response:
        result = {
            "id": response.id,
            "txn_alias": response.txn_alias,
            "fee": response.fee,
            "user_id": response.user_id,
            "first_name": response.first_name,
            "last_name": response.last_name,
            "base_asset": response.base_asset,
            "quote_asset": response.quote_asset,
            "created_at": response.created_at,
            "side": response.side,
            "quantity": response.quantity,
            "quote_price": response.quote_price,
            "quote_quantity": response.quote_quantity,
            "total": response.total,
            "entity": response.entity,
            "trader_identifier": response.trader_identifier,
            "hedge": response.hedge,
            "fee_notional": response.fee_notional,
            "order_type": response.order_type.value,
            "account_id": response.account_id,
        }
    return result


def update_fill_by_alias(update_data, fill_alias, tc):
    Fills.update(update_data).where(Fills.fill_alias == fill_alias).execute()
    tc.commit()  # 数据落盘


if __name__ == '__main__':
    # request = ObjDict(dict(
    #     txn_alias="5af1a354-ed7e-11ed-9cd8-0acc717cc6e2",
    #     asset_id="USD",
    #     side="settlement",
    #     amount=50,
    #     account_id="6d30ce83-6b46-4f09-951c-a4433370e198",
    #     vault_id=75,
    #     user_id="b0001660-4af8-44ba-a59a-50d64891529b",
    #     trader_identifier="e37c11ee-491a-4cb2-b739-d6f2ad1d39da",
    #     is_bank_transfer=False,
    #     is_notify_customer=False,
    #     bank_detail=None,
    #     note=''
    # ))
    # handle_fiat_and_cannot_transfer(request)
    # print(get_deposit_by_txn_alias('364473ad-77c6-46fc-86df-cda8382c8cb8'))
    handle_timestamp("1686193015000")


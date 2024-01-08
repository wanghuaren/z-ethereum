import os
import sys
from datetime import datetime
from peewee import CharField, DateTimeField, IntegerField, BooleanField, BigIntegerField, \
    TextField, FloatField, AutoField

sys.path.append(os.path.abspath(os.path.join(os.getcwd(), os.pardir)))
from db.base_models import BaseModel, BaseModelNoAddDate, EnumField, CustomizeEnum
from utils.retry_db import retry_db

db = retry_db


class Users(BaseModelNoAddDate):
    email = CharField(max_length=255, verbose_name='email')
    created_at = DateTimeField(verbose_name='created_at')
    updated_at = DateTimeField(verbose_name='updated_at')
    authentication_token = CharField(max_length=255, verbose_name='authentication_token')
    role = IntegerField(verbose_name='role')
    uid = CharField(max_length=255, verbose_name='uid')
    firstname = CharField(max_length=255, verbose_name='firstname')
    lastname = CharField(max_length=255, verbose_name='lastname')
    kyc_approved = BooleanField(verbose_name='kyc_approved')
    tc_agreed = BooleanField(verbose_name='tc_agreed')
    user_type = IntegerField(verbose_name='user_type', help_text="0:个人,1:公司, 2: 信托, 3: 组")
    address = CharField(max_length=255, verbose_name='address')
    company_number = CharField(max_length=255, verbose_name='company_number')
    frankie_entity_id = CharField(max_length=255, verbose_name='frankie_entity_id')
    trustee_name = CharField(max_length=255, verbose_name='trustee_name')
    company_name = CharField(max_length=255, verbose_name='company_name')
    tenant = CharField(max_length=255, verbose_name='tenant')
    workspace = CharField(max_length=255, verbose_name='workspace')
    initial_ip = CharField(max_length=255, verbose_name='initial_ip')
    trust_name = CharField(max_length=255, verbose_name="trust_name", help_text="信托名称")
    beneficiary_name = CharField(max_length=255, verbose_name="beneficiary_name", help_text="受益人")
    country = CharField(max_length=50, verbose_name="country", help_text="国家")
    phone = CharField(max_length=50, verbose_name="phone", help_text="电话")
    person_control = CharField(max_length=50, verbose_name="person_control", help_text="联系人")
    sp_wsc = BooleanField(verbose_name="sp_wsc", help_text="SP-WSC权限")
    user_id = CharField(max_length=50, verbose_name="user_id", help_text="唯一uuid")
    entity_id = CharField(max_length=50, verbose_name="entity_id", help_text="对应individual的entity_id")
    status = CharField(max_length=10, verbose_name='status', help_text="状态 active/blocked", default="active")
    signup_date = DateTimeField(verbose_name='signup_date')


class TxnOrderTypeEnum(CustomizeEnum):
    Limit = "Limit"
    Market = "Market"
    DMALimit = "DMA_Limit"


class TxnDataSourceEnum(CustomizeEnum):
    Rfq = "rfq"
    AddTransaction = "add transaction"
    Import = "import"
    Manual = "manual"
    DMACoinroutes = "dma_coinroutes"
    Null = None   # 老数据


class Transactions(BaseModel):
    txn_alias = CharField(max_length=255, verbose_name='txn_alias', null=True)
    userpubkey = CharField(max_length=255, verbose_name='userpubkey', null=True)
    base_asset = CharField(max_length=255, verbose_name='base_asset', null=True)
    quote_asset = CharField(max_length=255, verbose_name='quote_asset', null=True)
    side = CharField(max_length=255, verbose_name='side', null=True)
    quantity = CharField(max_length=255, verbose_name='quantity', null=True)
    quote_quantity = CharField(max_length=255, verbose_name='quote_quantity', null=True)
    total = CharField(max_length=255, verbose_name='total', null=True)
    filled_quantity = CharField(max_length=255, verbose_name='filled_quantity', null=True)
    user_id = CharField(max_length=255, verbose_name='user_id', null=True)
    first_name = CharField(max_length=255, verbose_name='first_name')
    last_name = CharField(max_length=255, verbose_name='last_name')
    raw_price = CharField(max_length=255, verbose_name='raw_price', null=True)
    quote_price = CharField(max_length=255, verbose_name='quote_price', null=True)
    exec_price = CharField(max_length=255, verbose_name='exec_price', null=True)
    markup = CharField(max_length=255, verbose_name='markup', null=True)
    fee = CharField(max_length=255, verbose_name='fee', null=True)
    pnl = CharField(max_length=255, verbose_name='pnl', null=True)
    created_at = BigIntegerField(verbose_name='created_at')
    canceled_at = BigIntegerField(verbose_name='canceled_at')
    updated_at = BigIntegerField(verbose_name='updated_at')
    status = CharField(max_length=255, verbose_name='status', null=True)
    filled_quote_quantity = CharField(max_length=255, verbose_name='filled_quote_quantity')
    trader_identifier = CharField(max_length=255, verbose_name='trader_identifier')
    markup_type = CharField(max_length=255, verbose_name='markup_type')
    fee_type = CharField(max_length=255, verbose_name='fee_type')
    memo = CharField(max_length=255, verbose_name='memo')
    entity = CharField(max_length=255, verbose_name='entity')
    add_date = DateTimeField(verbose_name='add_date')
    receipt_sent = BooleanField(verbose_name='receipt_sent', default=False)
    dealers = CharField(max_length=255, verbose_name='dealers')
    hedge = CharField(max_length=255, verbose_name='hedge')
    fee_notional = CharField(max_length=255, verbose_name='fee_notional')
    order_type = EnumField(enum=TxnOrderTypeEnum, max_length=10, verbose_name="order_type", help_text="订单类型,市价单:Market,限价单:Limit")
    data_source = EnumField(enum=TxnDataSourceEnum, max_length=30, verbose_name="data_source", help_text="txn 数据来源")
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="account_id")
    quote_dollar_value = CharField(max_length=100, verbose_name='quote_dollar_value', help_text='该笔订单美金数量')
    fee_amount = CharField(max_length=255, verbose_name='fee_amount', help_text="fee_amount")
    settlement_destination = CharField(max_length=50, verbose_name='settlement_destination', help_text="适用于blotter E列字段")


class Deposits(BaseModelNoAddDate):
    deposit_alias = CharField(max_length=255, verbose_name='deposit_alias', null=True)
    txn_alias = CharField(max_length=255, verbose_name='txn_alias', null=True)
    asset_id = CharField(max_length=255, verbose_name='asset_id', null=True)
    quantity = CharField(max_length=255, verbose_name='quantity', null=True)
    receiving_address = CharField(max_length=255, verbose_name='receiving_address')
    sending_address = CharField(max_length=255, verbose_name='sending_address')
    tx_hash = CharField(max_length=255, verbose_name='tx_hash')
    created_at = BigIntegerField(verbose_name='created_at', null=True)
    status = CharField(max_length=255, verbose_name='status', null=True)
    bank_details = CharField(max_length=255, verbose_name='bank_details')
    trader_identifier = CharField(max_length=255, verbose_name='trader_identifier', help_text='交易员 id')
    account_id = CharField(max_length=255, verbose_name='trader_identifier', help_text='交易账户实体')
    note = TextField(verbose_name='note', help_text='转账记录注释')
    tx_id = CharField(max_length=100, verbose_name='tx_id', )


class Vaults(BaseModel):
    user_id = CharField(max_length=255, verbose_name='user_id', null=True)
    name = CharField(max_length=255, verbose_name='name')
    vault_id = CharField(max_length=255, verbose_name='vault_id', index=True)
    created_at = DateTimeField(verbose_name='created_at')
    pending_yield_withdrawal = BooleanField(verbose_name='pending_yield_withdrawal')
    customer_ref_id = CharField(max_length=255, verbose_name='customer_ref_id')
    account_id = CharField(max_length=255, verbose_name='account_id')
    workspace = CharField(max_length=50, verbose_name='workspace', help_text='工作区', null=True)
    status = CharField(max_length=10, verbose_name='status', help_text="状态 active/inactive", default="active")


class Addresses(BaseModel):
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    user_id = CharField(max_length=255, verbose_name='user_id')
    address = CharField(max_length=255, verbose_name='address')
    created_at = BigIntegerField(verbose_name='created_at')
    last_updated = BigIntegerField(verbose_name='last_updated')
    status = CharField(max_length=20, verbose_name='status')
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="account_id")
    vault_id = CharField(max_length=255, verbose_name='vault_id', help_text="vault_id")
    address_id = CharField(max_length=255, verbose_name='address_id')


class ExternalWallets(BaseModel):
    name = CharField(max_length=255, verbose_name='name')
    user_id = CharField(max_length=255, verbose_name='user_id')
    external_wallet_id = CharField(max_length=255, verbose_name='external_wallet_id')
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    created_at = DateTimeField(verbose_name='created_at')
    last_updated = DateTimeField(verbose_name='last_updated')
    status = CharField(max_length=20, verbose_name='status')
    address = CharField(max_length=255, verbose_name='address')
    tag = CharField(max_length=255, verbose_name='tag')
    customer_ref_id = CharField(max_length=255, verbose_name='customer_ref_id')


class ExternalWalletPropTrading(BaseModel):
    id = BigIntegerField(verbose_name='id', index=True)
    name = CharField(max_length=255, verbose_name='name')
    user_id = CharField(max_length=255, verbose_name='user_id')
    external_wallet_id = CharField(max_length=255, verbose_name='external_wallet_id')
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    created_at = DateTimeField(verbose_name='created_at')
    last_updated = DateTimeField(verbose_name='last_updated')
    status = CharField(max_length=20, verbose_name='status')
    address = CharField(max_length=255, verbose_name='address')
    tag = CharField(max_length=255, verbose_name='tag')
    customer_ref_id = CharField(max_length=255, verbose_name='customer_ref_id')
    vault_id = CharField(max_length=255, verbose_name='vault_id')
    workspace = CharField(max_length=255, verbose_name='workspace')
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="account_id")


class TransactionsHistory(BaseModel):
    tx_id = CharField(max_length=255, verbose_name='tx_id', unique=True)
    tx_hash = CharField(max_length=255, verbose_name='tx_hash', null=True)
    amount = CharField(max_length=255, verbose_name='amount')
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    user_id = CharField(max_length=255, verbose_name='user_id', null=True)
    created_at = BigIntegerField(verbose_name='created_at')
    last_updated = CharField(max_length=255, verbose_name='last_updated')
    datetime = DateTimeField(verbose_name='datetime')
    source_type = CharField(max_length=255, verbose_name='source_type')
    source_id = CharField(max_length=255, verbose_name='source_id')
    destination_type = CharField(max_length=255, verbose_name='destination_type')
    destination_id = CharField(max_length=255, verbose_name='destination_id')
    destination_address = CharField(max_length=255, verbose_name='destination_address', null=True)
    numConfirms = CharField(max_length=255, verbose_name='numConfirms', null=True)
    fee = CharField(max_length=255, verbose_name='fee', null=True)
    fee_currency = CharField(max_length=255, verbose_name='fee_currency', null=True)
    operation = CharField(max_length=255, verbose_name='operation')
    status = CharField(max_length=255, verbose_name='status')
    note = CharField(max_length=255, verbose_name='note', null=True)
    token = CharField(max_length=255, verbose_name='token', null=True)
    type = CharField(max_length=255, verbose_name='type', null=True)
    group_id = CharField(max_length=255, verbose_name='group_id', null=True)
    source_address = CharField(max_length=255, verbose_name='source_address', null=True)
    from_account_type = CharField(max_length=255, verbose_name='from_account_type', null=True)
    to_account_type = CharField(max_length=255, verbose_name='to_account_type', null=True)
    interest_earned = CharField(max_length=255, verbose_name='interest_earned', null=True)
    amount_usd = CharField(max_length=255, verbose_name='amount_usd', null=True)
    webhook_updated = BooleanField(verbose_name='webhook_updated', default=False)
    substatus = CharField(max_length=255, verbose_name='substatus', null=True)
    comment = CharField(max_length=255, verbose_name="comment", default="", help_text="用户note")
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="用户操作的account_id")
    vault_id = CharField(max_length=11, verbose_name='vault_id', help_text='用户操作的vault账户', null=True)
    entity_id = CharField(max_length=50, verbose_name='entity_id', help_text='当前操作用户的email对应的individual的entity_id', null=True)
    email = CharField(max_length=255, verbose_name='email', help_text='当前操作用户的email', null=True)


class ApprovalGroup(BaseModel):
    group_id = CharField(max_length=255, verbose_name='group_id')
    name = CharField(max_length=255, verbose_name='name')
    created_at = BigIntegerField(verbose_name='created_at')
    last_updated = BigIntegerField(verbose_name='last_updated')
    status = CharField(max_length=255, verbose_name='status')
    approver_count = CharField(max_length=255, verbose_name="approver_count")


class Approvers(BaseModel):
    user_id = CharField(max_length=255, verbose_name='user_id')
    created_at = BigIntegerField(verbose_name='created_at')
    last_updated = BigIntegerField(verbose_name='last_updated')
    status = CharField(max_length=255, verbose_name='status')
    group_id = CharField(max_length=255, verbose_name='group_id')
    approve_role_id = CharField(max_length=255, verbose_name="approve_role_id")


class YieldApr(BaseModel):
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    apr = CharField(max_length=255, verbose_name='apr')
    type = CharField(max_length=255, verbose_name='type')
    term = CharField(max_length=255, verbose_name='term')
    status = CharField(max_length=255, verbose_name='status')
    created_at = CharField(max_length=20, verbose_name='created_at')
    last_updated = CharField(max_length=20, verbose_name='last_updated')
    tenant = CharField(max_length=255, verbose_name='tenant')
    interest = CharField(max_length=255, verbose_name='interest')


class Withdrawals(BaseModelNoAddDate):
    withdrawal_alias = CharField(max_length=255, verbose_name='withdrawal_alias', null=True)
    txn_alias = CharField(max_length=255, verbose_name='txn_alias', null=True)
    asset_id = CharField(max_length=255, verbose_name='asset_id', null=True)
    quantity = CharField(max_length=255, verbose_name='quantity', null=True)
    trader_identifier = CharField(max_length=255, verbose_name='trader_identifier', null=True)
    receiving_address = CharField(max_length=255, verbose_name='receiving_address')
    sending_address = CharField(max_length=255, verbose_name='sending_address')
    memo = CharField(max_length=255, verbose_name='memo')
    withdrawal_time = BigIntegerField(verbose_name='withdrawal_time', null=True)
    tx_hash = CharField(max_length=255, verbose_name='tx_hash')
    created_at = BigIntegerField(verbose_name='created_at', null=True)
    status = CharField(max_length=255, verbose_name='status', null=True)
    bank_details = CharField(max_length=255, verbose_name='bank_details')
    tx_id = CharField(max_length=255, verbose_name='tx_id', null=True)
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="account_id")
    vault_id = CharField(max_length=50, verbose_name='vault_id', help_text="vault_id")
    to_portal = BooleanField(verbose_name='to_portal')
    note = TextField(verbose_name='note', help_text='转账记录注释')


class Symbols(BaseModelNoAddDate):
    id = BigIntegerField(verbose_name='id')
    base_asset_id = CharField(max_length=255, verbose_name='base_asset_id')
    quote_asset_id = CharField(max_length=255, verbose_name='quote_asset_id')
    ticker = CharField(max_length=255, verbose_name='ticker')
    px_sig = BigIntegerField(verbose_name='px_sig')
    qty_sig = BigIntegerField(verbose_name='qty_sig')
    min_qty = CharField(max_length=255, verbose_name='min_qty')
    max_qty = CharField(max_length=255, verbose_name='max_qty')
    transaction_sizes = CharField(max_length=255, verbose_name='transaction_sizes')
    source = CharField(max_length=255, verbose_name='source')
    status = CharField(max_length=255, verbose_name='status')
    platform = CharField(max_length=255, verbose_name='platform')
    currency_sig = BigIntegerField(verbose_name='currency_sig', default=16)


class EMSSymbols(BaseModelNoAddDate):
    class Meta:
        database = db
        table_name = 'ems_symbols'

    base_asset_id = CharField(max_length=50, verbose_name='gck 数据填返回的 id')
    quote_asset_id = CharField(max_length=50, verbose_name='gck 数据填: USD/AUD/GBP/EUR/BTC/ETH')
    ticker = CharField(max_length=50, verbose_name='ticker', help_text='gck 数据填: 返回的 symbol + USD/AUD/GBP/EUR/BTC/ETH')
    px_sig = IntegerField(verbose_name='px_sig', help_text='价格保留精度')
    qty_sig = IntegerField(verbose_name='qty_sig', help_text='数量保留精度')
    max_qty = CharField(max_length=30, verbose_name='max_qty', help_text='最大交易量')
    min_qty = CharField(max_length=30, verbose_name='min_qty', help_text='最小交易量')
    is_quote = BooleanField(verbose_name='is_quote', help_text='是否能在 talos 上询价：false 不是，true 是')
    source = CharField(max_length=20, verbose_name='source', help_text='交易市场')
    supplier = CharField(max_length=20, verbose_name='supplier')
    status = CharField(max_length=10, verbose_name='status', help_text='active, inactive')
    note = TextField(verbose_name="note", help_text="gck id 发生变化，无法在新的列表中找到记录")
    security_id = CharField(max_length=30, verbose_name='security_id', help_text='交易对在 talos 中的唯一 id 值')
    created_at = BigIntegerField(verbose_name='created_at', help_text="创建时间")
    last_updated = BigIntegerField(verbose_name='updated_at', help_text="最后更新时间")
    last_quote_time = DateTimeField(verbose_name='last_quote_time', help_text='上次询价时间')


class Gckdata(BaseModelNoAddDate):
    id = CharField(max_length=255, verbose_name='name')
    name = CharField(max_length=255, verbose_name='name')
    symbol = CharField(max_length=255, verbose_name='symbol')
    current_price = CharField(max_length=255, verbose_name='current_price')
    market_cap = FloatField(verbose_name='market_cap')
    market_cap_rank = IntegerField(verbose_name='market_cap_rank')
    fully_diluted_valuation = FloatField(verbose_name='fully_diluted_valuation')
    total_volume = FloatField(verbose_name='total_volume')
    high_24h = FloatField(verbose_name='high_24h')
    low_24h = FloatField(verbose_name='low_24h')
    price_change_24h = FloatField(verbose_name='price_change_24h')
    price_change_percentage_24h = CharField(max_length=255, verbose_name='price_change_percentage_24h')
    market_cap_change_24h = FloatField(verbose_name='market_cap_change_24h')
    market_cap_change_percentage_24h = CharField(max_length=255, verbose_name='market_cap_change_percentage_24h')
    circulating_supply = FloatField(verbose_name='circulating_supply')
    total_supply = FloatField(verbose_name='total_supply')
    max_supply = FloatField(verbose_name='max_supply')
    ath = FloatField(verbose_name='ath')
    ath_change_percentage = CharField(max_length=255, verbose_name='ath_change_percentage')
    ath_date = DateTimeField(verbose_name='ath_date')
    atl = FloatField(verbose_name='atl')
    atl_change_percentage = CharField(max_length=255, verbose_name='atl_change_percentage')
    atl_date = DateTimeField(verbose_name='atl_date')
    roi = CharField(max_length=255, verbose_name='roi')
    last_updated = DateTimeField(verbose_name='last_updated')
    chain_id = CharField(max_length=255, verbose_name='chain_id')
    type = CharField(max_length=255, verbose_name='type', default='crypto')
    decimals = BigIntegerField(verbose_name='decimals')
    qty_prec = BigIntegerField(verbose_name='qty_prec', default=2)
    px_prec = BigIntegerField(verbose_name='px_prec', default=2)
    conf_blocks = BigIntegerField(verbose_name='conf_blocks', default=0)
    min_withdraw = CharField(max_length=255, verbose_name='min_withdraw', default='2')
    max_withdraw = CharField(max_length=255, verbose_name='max_withdraw', default='1000000')
    fee = CharField(max_length=255, verbose_name='fee', default='1')
    default_address = CharField(max_length=255, verbose_name='default_address', null=True)


class Assets(BaseModelNoAddDate):
    id = CharField(max_length=255, verbose_name='id')
    chain_id = CharField(max_length=255, verbose_name='chain_id')
    ticker = CharField(max_length=255, verbose_name='ticker')
    name = CharField(max_length=255, verbose_name='name')
    type = CharField(max_length=255, verbose_name='type')
    decimals = BigIntegerField(verbose_name='decimals')
    qty_prec = BigIntegerField(verbose_name='qty_prec')
    px_prec = BigIntegerField(verbose_name='px_prec')
    conf_blocks = BigIntegerField(verbose_name='conf_blocks')
    min_withdraw = CharField(max_length=255, verbose_name='min_withdraw')
    max_withdraw = CharField(max_length=255, verbose_name='max_withdraw')
    fee = CharField(max_length=255, verbose_name='fee')
    default_address = CharField(max_length=255, verbose_name='default_address')
    business_type = CharField(max_length=20, verbose_name='business_type')
    status = CharField(max_length=20, verbose_name='status')
    is_stable = BooleanField(verbose_name='is_stable', help_text='是否是稳定币：false 不是，true 是')
    coingecko_id = CharField(max_length=50, verbose_name='coingecko_id')
    fb_id = CharField(max_length=50, verbose_name='fb_id', help_text='protal相关的id')
    cmc_id = CharField(max_length=50, verbose_name='cmc_id')


class Chains(BaseModel):
    id = CharField(max_length=255, verbose_name="id")
    name = CharField(max_length=255, verbose_name="name")
    source_url = CharField(max_length=255, verbose_name="source_url")


class Fills(BaseModelNoAddDate):
    id = BigIntegerField(verbose_name='id')
    fill_alias = CharField(max_length=255, verbose_name='fill_alias')
    quote_alias = CharField(max_length=255, verbose_name='quote_alias')
    txn_alias = CharField(max_length=255, verbose_name='txn_alias')
    cppubkey = CharField(max_length=255, verbose_name='cppubkey')
    base_asset = CharField(max_length=255, verbose_name='base_asset')
    quote_asset = CharField(max_length=255, verbose_name='quote_asset')
    quantity = CharField(max_length=255, verbose_name='quantity')
    quote_quantity = CharField(max_length=255, verbose_name='quote_quantity')
    quote_price = CharField(max_length=255, verbose_name='quote_price')
    exec_price = CharField(max_length=255, verbose_name='exec_price')
    side = CharField(max_length=255, verbose_name='side')
    pnl = CharField(max_length=255, verbose_name='pnl')
    user_id = CharField(max_length=255, verbose_name='user_id')
    trader_identifier = CharField(max_length=255, verbose_name='trader_identifier')
    tx_ref = CharField(max_length=255, verbose_name='tx_ref')
    fill_type = CharField(max_length=255, verbose_name='fill_type')
    receiving_address = CharField(max_length=255, verbose_name='receiving_address')
    withdrawal_time = BigIntegerField(verbose_name='withdrawal_time', null=True)
    tx_hash = CharField(max_length=255, verbose_name='tx_hash')
    created_at = BigIntegerField(verbose_name='created_at', null=True)
    status = CharField(max_length=255, verbose_name='status', null=True)
    entity = CharField(max_length=255, verbose_name='entity')
    dealers = CharField(max_length=255, verbose_name='dealers')
    hedge = CharField(max_length=255, verbose_name='hedge')
    order_type = CharField(max_length=50, verbose_name='order_type', default='Market', help_text='限价单:Limit,即时单:Market')
    data_sources = CharField(max_length=50, verbose_name='data_source', default='hedge', help_text='Accept自动写入:hedge, AddFill手动写入:manual, Talos抓取:talos_trade_history')
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="account_id")
    vault_id = CharField(max_length=50, verbose_name='vault_id', help_text="vault_id")
    settlement_destination = CharField(max_length=50, verbose_name='settlement_destination', help_text="适用于blotter E列字段")


class FbSupportedAssets(BaseModelNoAddDate):
    id = CharField(max_length=100, verbose_name="id", primary_key=True)
    name = CharField(max_length=100, verbose_name="name")
    type = CharField(max_length=100, verbose_name="type")
    contract_address = CharField(max_length=255, verbose_name="contractAddress", null=True)
    native_asset = CharField(max_length=255, verbose_name="nativeAsset", null=True)
    decimals = BigIntegerField(verbose_name="decimals")
    issuer_address = CharField(max_length=255, null=True)
    coingecko_id = CharField(max_length=100, verbose_name="coingecko_id")

    class Meta:
        database = db
        db_table = 'fb_supported_assets'


class Risk(BaseModel):
    id = CharField(max_length=50, verbose_name="id")
    created_at = DateTimeField(verbose_name="created_at")
    last_updated = BigIntegerField(verbose_name='last_updated')
    trader_identifier = CharField(max_length=255, verbose_name="trader_identifier")
    asset_id = CharField(max_length=50, verbose_name="asset_id")
    exposure_quantity = CharField(max_length=50, verbose_name="exposure_quantity")
    exposure_value_usd = CharField(max_length=50, verbose_name="exposure_value_usd")
    trading_volume = CharField(max_length=50, verbose_name="trading_volume")
    trading_volume_usd = CharField(max_length=50, verbose_name="trading_volume_usd")
    pnl = CharField(max_length=50, verbose_name="pnl")
    risk_type = CharField(max_length=50, verbose_name="type")
    entity = CharField(max_length=50, verbose_name="entity")
    date = CharField(max_length=50, verbose_name="date")


class RiskLimits(BaseModel):
    id = CharField(max_length=50, verbose_name="id")
    trader_identifier = CharField(max_length=255, verbose_name="trader_identifier", help_text="交易员或者公司uuid")
    role = CharField(max_length=50, verbose_name="role", help_text="区分公司与交易员")
    alert_interval = CharField(max_length=50, verbose_name="alert_interval", help_text="pnl 报警间隔")
    stop_loss_limit = CharField(max_length=50, verbose_name="stop_loss_limit", help_text="止损限额")
    manager_email = TextField(verbose_name="manager_email", help_text="交易员的经理/报警接受者")
    status = CharField(max_length=50, verbose_name="status", help_text="状态 默认值:deleted/normal")
    note = TextField(verbose_name="note", help_text="备注")
    created_at = BigIntegerField(verbose_name="created_at", help_text="创建时间")
    update_at = BigIntegerField(verbose_name="update_at ", help_text="更新时间")

    class Meta:
        database = db
        table_name = 'risk_limits'


class RiskAlarm(BaseModel):
    id = CharField(max_length=50, verbose_name="id")
    trader_identifier = CharField(max_length=255, verbose_name="user_id", help_text="交易员")
    pnl = CharField(max_length=50, verbose_name="pnl", help_text="报警时的pnl")
    status = CharField(max_length=50, verbose_name="status", help_text="状态 默认值:deleted/normal")
    note = TextField(verbose_name="note", help_text="备注")
    created_at = BigIntegerField(verbose_name="created_at", help_text="报警时间")
    update_at = BigIntegerField(verbose_name="update_at ", help_text="更新时间")

    class Meta:
        database = db
        table_name = 'risk_alarm'


class LPConfig(BaseModel):
    id = CharField(max_length=50, verbose_name="id")
    liquidity_provider_name = CharField(max_length=255, verbose_name="liquidity_providern_ame", help_text="交易所名称")
    minimum_settlement_amount = CharField(max_length=50, verbose_name="minimum_settlement_amount", help_text="最低结算额度")
    status = CharField(max_length=50, verbose_name="status", help_text="状态 默认值:active/inactive")
    created_at = BigIntegerField(verbose_name="created_at", help_text="创建时间")
    update_at = BigIntegerField(verbose_name="update_at ", help_text="更新时间")

    class Meta:
        database = db
        table_name = 'lp_config'


class Quotes(BaseModelNoAddDate):
    id = CharField(max_length=255, verbose_name='id', index=True)
    quote_alias = CharField(max_length=255, verbose_name='quote_alias')
    txn_alias = CharField(max_length=255, verbose_name='txn_alias')
    userpubkey = CharField(max_length=255, verbose_name='userpubkey')
    user_id = CharField(max_length=255, verbose_name='user_id')
    trader_identifier = CharField(max_length=255, verbose_name='trader_identifier')
    base_asset = CharField(max_length=255, verbose_name='base_asset')
    quote_asset = CharField(max_length=255, verbose_name='quote_asset')
    side = CharField(max_length=255, verbose_name='side')
    quantity = CharField(max_length=255, verbose_name='asset_id')
    quote_quantity = CharField(max_length=255, verbose_name='quote_quantity')
    total = CharField(max_length=255, verbose_name='total')
    quantity_asset = CharField(max_length=255, verbose_name='quantity_asset')
    quote_price = CharField(max_length=255, verbose_name='quote_price')
    raw_price = CharField(max_length=255, verbose_name='raw_price')
    markup = CharField(max_length=255, verbose_name='markup')
    markup_type = CharField(max_length=255, verbose_name='markup_type')
    fee = CharField(max_length=255, verbose_name='fee')
    fee_type = CharField(max_length=255, verbose_name='fee_type')
    fee_pct = CharField(max_length=255, verbose_name='fee_pct')
    fee_total = CharField(max_length=255, verbose_name='fee_total')
    pnl = CharField(max_length=255, verbose_name='pnl')
    status = CharField(max_length=255, verbose_name='status')
    created_at = IntegerField(verbose_name='created_at')
    canceled_at = IntegerField(verbose_name='canceled_at')
    timeout = IntegerField(verbose_name='timeout')
    entity = CharField(max_length=255, verbose_name='entity')
    dealers = CharField(max_length=255, verbose_name='dealers')
    hedge = CharField(max_length=255, verbose_name='hedge')
    fee_notional = CharField(max_length=255, verbose_name='fee_notional', help_text="fee类型，分为bps, base, quote")
    parent_quote_alias = CharField(max_length=255, verbose_name='parent_quote_alias', help_text="quotes_alias继承标识")
    two_way_quote_alias = CharField(max_length=255, verbose_name='two_way_quote_alias', help_text="2 way标识")
    quote_type = CharField(max_length=255, verbose_name='quote_type')
    is_edit = CharField(max_length=255, verbose_name='is_edit', help_text="编辑价格标识")
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="account_id")
    vault_id = CharField(max_length=255, verbose_name='vault_id', help_text="vault_id")
    normal_quote = BooleanField(verbose_name='normal_quote', default=False)
    note = TextField(verbose_name="note", help_text="询价提示信息")
    settlement_destination = CharField(max_length=50, verbose_name='settlement_destination', help_text="适用于blotter E列字段")
    price_mode = CharField(max_length=20, verbose_name='price_mode', help_text='询价模式')


class OrderStatusEnum(CustomizeEnum):
    Open = "open"
    Filled = "filled"
    Canceled = "canceled"
    PartiallyFilled = "partially filled"
    Deleted = "deleted"


class FeeTypeEnum(CustomizeEnum):
    Separate = "separate"
    Included = "included"


class NotionalEnum(CustomizeEnum):
    Base = "base"
    Quote = "quote"


class FeeNotionalEnum(CustomizeEnum):
    Bps = "bps"
    Base = "base"
    Quote = "quote"


class EntityEnum(CustomizeEnum):
    zerocap = "zerocap"
    vesper = "vesper"


class SideEnum(CustomizeEnum):
    Buy = "buy"
    Sell = "sell"


class OrderTypeEnum(CustomizeEnum):
    Limit = "Limit"


class OrderHedgeEnum(CustomizeEnum):
    LiveHedge = "live hedge"
    NoHedge = "no hedge"


class OrderMarkUpTypeEnum(CustomizeEnum):
    Bps = "bps"
    Pips = "pips"


class Orders(BaseModel):
    id = AutoField()
    # order_alias 不是非必需，是下单前写入数据，下单后回写的依据
    order_alias = CharField(unique=True, max_length=255, verbose_name='order_alias')
    # txn_alias 关联 transactions 表
    txn_alias = CharField(unique=True, max_length=255, verbose_name='txn_alias')
    # order_id 也需要加上索引，websocket 收到更新时，可以快速定位
    order_id = CharField(unique=True, null=True, max_length=255, verbose_name='order_id', help_text="talos order id")
    order_type = EnumField(enum=OrderTypeEnum, max_length=10, verbose_name='order_type', help_text="订单类型")
    status = EnumField(enum=OrderStatusEnum, max_length=20, verbose_name='status', help_text="订单状态")
    base_asset = CharField(max_length=10, verbose_name='base_asset')
    quote_asset = CharField(max_length=10, verbose_name='quote_asset')
    side = EnumField(enum=SideEnum, max_length=10, verbose_name='side', help_text="buy or sell")
    total = CharField(max_length=30, verbose_name='total', help_text="成交量+成交部分的手续费")
    quantity = CharField(max_length=30, verbose_name='quantity', help_text="订单数量")
    leaves_quantity = CharField(max_length=30, verbose_name='leaves_quantity', help_text="剩余未完成数量")
    filled_quantity = CharField(max_length=30, verbose_name='filled_quantity', help_text="已完成数量")
    notional = EnumField(enum=NotionalEnum, max_length=10, verbose_name='notional', help_text="买卖对象，等同于 Quotes 表中的 quantity_asset")
    price = CharField(max_length=30, verbose_name='price', help_text="价格，限价单指 limit_price")
    avg_price = CharField(max_length=30, verbose_name='avg_price', help_text="平均价格")
    user_id = CharField(max_length=255, verbose_name='user_id', help_text="用户id")
    trader_identifier = CharField(max_length=255, verbose_name='trader_identifier', help_text="交易员")
    entity = EnumField(enum=EntityEnum, max_length=10, verbose_name='entity', help_text="交易主体")
    dealers = CharField(max_length=255, verbose_name='dealers', help_text="交易市场")
    fee = CharField(max_length=50, verbose_name='fee')
    fee_pct = CharField(max_length=10, verbose_name='fee_pct')
    fee_type = EnumField(enum=FeeTypeEnum, max_length=10, verbose_name='fee_type', help_text="费用类型")
    fee_total = CharField(max_length=50, verbose_name='fee_total')
    fee_notional = EnumField(enum=FeeNotionalEnum, max_length=10, verbose_name='fee_notional', help_text="收费对象")
    hedge = EnumField(enum=OrderHedgeEnum, max_length=30, verbose_name='hedge', help_text="是否下单，值为 live hedge 或 no hedge")
    markup = CharField(max_length=50, verbose_name='markup', help_text="上浮比率")
    markup_type = EnumField(enum=OrderMarkUpTypeEnum, max_length=10, verbose_name="markup_type", help_text="上浮类型")
    raw_price = CharField(max_length=30, verbose_name="raw_price", help_text="根据 markup算出的实际去 talos 下单的价格")
    note = TextField(verbose_name="note", help_text="下单失败提示信息")
    created_at = BigIntegerField(verbose_name='created_at', help_text="创建时间")
    updated_at = BigIntegerField(verbose_name='updated_at', help_text="更新时间(正常情况下，等于create_at)")
    canceled_at = BigIntegerField(verbose_name='canceled_at', null=True, default=None, help_text="取消时间")
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="account_id")
    vault_id = CharField(max_length=255, verbose_name='vault_id', help_text="vault_id")

    class Meta:
        database = db
        db_table = 'orders'


class TreasuryStatusEnum(CustomizeEnum):
    Pending = "pending"
    Completed = "completed"
    Deleted = "deleted"


class Treasury(BaseModel):
    id = AutoField()
    add_date = DateTimeField(verbose_name='add_date', help_text="写入数据库时间")
    user_id = CharField(max_length=255, verbose_name='user_id', help_text="用户id")
    asset_id = CharField(max_length=10, verbose_name='asset_id')
    amount = CharField(max_length=30, verbose_name='asset_id', help_text="订单数量")
    fee = CharField(max_length=50, verbose_name='fee', help_text="费用")
    fee_type = EnumField(enum=FeeTypeEnum, max_length=10, verbose_name='fee_type', help_text="费用类型")
    total = CharField(max_length=50, verbose_name='total', help_text="加上费用的总价格")
    fee_notional = EnumField(enum=FeeNotionalEnum, max_length=10, verbose_name='fee_notional', help_text="收费对象")
    fee_amount = CharField(max_length=50, verbose_name='fee_amount', help_text="总费用")
    tx_hash = CharField(max_length=255, verbose_name='tx_hash')
    destination_address = CharField(max_length=255, verbose_name='destination_address')
    trader_identifier = CharField(max_length=255, verbose_name='trader_identifier', help_text="交易员")
    status = EnumField(enum=TreasuryStatusEnum, max_length=20, verbose_name='status', help_text="状态")
    created_at = BigIntegerField(verbose_name="created_at", help_text="创建时间, 业务时间")
    updated_at = BigIntegerField(verbose_name="update_at ", help_text="更新时间")
    receipt_sent = BooleanField(verbose_name='receipt_sent', default=False)
    notes = CharField(max_length=255, verbose_name='notes', null=True)
    treasury_alias = CharField(max_length=255, verbose_name='treasury_alias')
    account_id = CharField(max_length=255, verbose_name='account_id', help_text="account_id")
    vault_id = CharField(max_length=255, verbose_name='vault_id', help_text="vault_id")
    entity = CharField(max_length=255, verbose_name='entity')
    settlement_destination = CharField(max_length=50, verbose_name='settlement_destination', help_text="适用于blotter E列字段")

    class Meta:
        database = db
        db_table = 'treasury'


class EntityRelation(BaseModel):
    """
    实体关系表
    """
    class Meta:
        database = db
        table_name = 'entity_relation'

    entity_id = CharField(max_length=50, verbose_name='entity_id', help_text='当前（子）实体的id', null=False)
    entity_type = CharField(max_length=20, verbose_name='entity_type', help_text='表示当前（子）实体的实体类型', null=False)
    parent_entity_id = CharField(max_length=50, verbose_name='parent_entity_id', help_text='外键，用于关联相关实体表，表示父级实体', null=False)
    parent_entity_type = CharField(max_length=20, verbose_name='parent_entity_type', help_text='外键，表示父级实体的类型', null=False)
    role = CharField(max_length=20, verbose_name='role', help_text='表示成员拥有权限的角色（viewer, initiator, approver）', null=False)
    status = CharField(max_length=10, verbose_name='status', help_text="状态 active/inactive", default="active")
    created_at = BigIntegerField(verbose_name='created_at', null=False, help_text="数据创建时间")
    last_updated = BigIntegerField(verbose_name='last_updated', null=False, help_text="数据最后修改时间")


class EntityAccount(BaseModel):
    """
    entity和account关联表
    """
    class Meta:
        database = db
        table_name = 'entity_account'

    entity_id = CharField(max_length=50, verbose_name='entity_id', null=False)
    account_id = CharField(max_length=50, verbose_name='account_id', null=False)
    status = CharField(max_length=50, verbose_name='status', null=False)
    created_at = BigIntegerField(verbose_name='created_at', null=False)
    last_updated = BigIntegerField(verbose_name='last_updated', null=False)


class TraderConfig(BaseModel):
    """
   记录加密后trader的key与secret
    """
    class Meta:
        database = db
        table_name = 'trader_config'

    id = CharField(max_length=50, verbose_name='id', null=False)
    email = CharField(max_length=255, verbose_name='email', null=False, help_text="交易员的email")
    trader_identifier = CharField(max_length=255, verbose_name='trader_identifier', help_text="交易员对应的user_id")
    key = CharField(max_length=255, verbose_name='key', null=False, help_text="交易员的key")
    secret = CharField(max_length=255, verbose_name='secret', null=False, help_text="交易员的secret")
    status = CharField(max_length=50, verbose_name='status', null=False, help_text="记录的状态")
    created_at = BigIntegerField(verbose_name='created_at', null=False, help_text="创建的时间")
    last_updated = BigIntegerField(verbose_name='last_updated', null=False, help_text="最后一次更新的时间")


class Accounts(BaseModel):
    """
    账户状态
    """
    account_id = CharField(max_length=50, verbose_name='account_id', null=False)
    account_status = CharField(max_length=50, verbose_name='account_status', null=False)
    status = CharField(max_length=50, verbose_name='status', null=False)
    created_at = BigIntegerField(verbose_name='created_at', null=False)
    last_updated = BigIntegerField(verbose_name='last_updated', null=False)


class AccountInfo(BaseModel):
    """
    账户信息
    """
    class Meta:
        database = db
        table_name = 'account_info'

    account_id = CharField(max_length=50, verbose_name='account_id', null=False)
    account_name = CharField(max_length=255, verbose_name='account_name', null=False)
    label = CharField(max_length=255, verbose_name='label', null=False)
    approver_count = IntegerField(verbose_name='approver_count', null=False)
    billing_custody = BooleanField(verbose_name='billing_custody', default=True)
    billing_insurance = BooleanField(verbose_name='billing_insurance', default=True)
    billing_currency = CharField(max_length=50, verbose_name='billing_currency', null=False)
    insurance_switch = BooleanField(verbose_name='insurance_switch', null=False)
    status = CharField(max_length=50, verbose_name='status', null=False)
    created_at = BigIntegerField(verbose_name='created_at', null=False)
    last_updated = BigIntegerField(verbose_name='last_updated', null=False)


class Individuals(BaseModel):
    """
    个人实体表
    """
    entity_id = CharField(max_length=50, help_text='individual实体唯一标识符')
    first_name = CharField(max_length=50, help_text='用户名')
    last_name = CharField(max_length=50, help_text='用户姓')
    tenant = CharField(max_length=20, help_text='表示用户所注册的哪家理财公司，zerocap_portal、viva')
    address = CharField(max_length=255, help_text='用户居住地址')
    phone = CharField(max_length=20, help_text='用户手机号码')
    country = CharField(max_length=50, help_text='用户所在国家（从地址中分析所得，不是用户国籍）')
    kyc_status = BooleanField(verbose_name='kyc_status', default=False, help_text='用户的KYC认证')
    sp_wsc = BooleanField(verbose_name='sp_wsc', default=False, help_text='表示是否通过whole sale certification的认证')
    status = CharField(max_length=10, default='active', help_text='individual实体状态，active、inactive')
    created_at = IntegerField(verbose_name='created_at', help_text='数据创建时间')
    last_updated = IntegerField(verbose_name='last_updated', help_text='数据最后修改时间')


class Companys(BaseModel):
    """
    公司实体表
    """
    entity_id = CharField(max_length=50, help_text='company实体唯一标识符')
    company_name = CharField(max_length=255, help_text='公司名')
    company_number = CharField(max_length=50, help_text='公司号')
    address = CharField(max_length=255, help_text='公司地址')
    person_control = CharField(max_length=255, help_text='控制人')
    phone = CharField(max_length=20, help_text='公司联系电话')
    country = CharField(max_length=50, help_text='用户所在国家（从地址中分析所得，不是用户国籍）')
    kyc_status = BooleanField(verbose_name='kyc_status', default=False, help_text='公司的KYC认证')
    sp_wsc = BooleanField(verbose_name='sp_wsc', default=False, help_text='表示是否通过whole sale certification的认证')
    status = CharField(max_length=10, default='active', help_text='company实体状态，active、inactive')
    created_at = IntegerField(verbose_name='created_at', help_text='数据创建时间')
    last_updated = IntegerField(verbose_name='last_updated', help_text='数据最后修改时间')


class Trusts(BaseModel):
    """
    机构实体表
    """
    entity_id = CharField(max_length=50, help_text='trust实体唯一标识符')
    trust_name = CharField(max_length=255, help_text='信托名')
    trustee_name = CharField(max_length=255, help_text='受益人名')
    address = CharField(max_length=255, help_text='信托地址')
    beneficiary_name = CharField(max_length=255, help_text='控制人')
    phone = CharField(max_length=20, help_text='公司联系电话')
    country = CharField(max_length=50, help_text='用户所在国家（从地址中分析所得，不是用户国籍）')
    kyc_status = BooleanField(verbose_name='kyc_status', default=False, help_text='公司的KYC认证')
    sp_wsc = BooleanField(verbose_name='sp_wsc', default=False, help_text='表示是否通过whole sale certification的认证')
    status = CharField(max_length=10, default='active', help_text='individual实体状态，active、inactive')
    created_at = IntegerField(verbose_name='created_at', help_text='数据创建时间')
    last_updated = IntegerField(verbose_name='last_updated', help_text='数据最后修改时间')


class Groups(BaseModel):
    """
    组实体表
    """
    entity_id = CharField(max_length=50, help_text='group实体唯一标识符')
    group_name = CharField(max_length=255, help_text='群组名')
    status = CharField(max_length=10, default='active', help_text='组实体状态，active、inactive')
    created_at = IntegerField(verbose_name='created_at', help_text='数据创建时间')
    last_updated = IntegerField(verbose_name='last_updated', help_text='数据最后修改时间')


class PrimeAgreementHistory(BaseModel):
    """
    保存签署记录
    """
    user_id = CharField(max_length=255, help_text='签署user_id', null=True)
    account_id = CharField(max_length=255, help_text='签署vault_id')
    pa_alias = CharField(max_length=255, help_text='协议唯一标识')
    ip = CharField(max_length=255, help_text='用户ip地址')
    created_at = BigIntegerField(help_text='录入时间')
    pa_agreed = BooleanField(verbose_name='pa_agreed', help_text='签署是否有效')
    last_updated = IntegerField(verbose_name='last_updated', help_text='更新时间')
    entity_id = CharField(max_length=50, verbose_name='entity_id', help_text='签署协议当前用户的individual表的entity_id', null=True)
    email = CharField(max_length=255, verbose_name='email', help_text='签署用户登陆的email', null=True)


class OtcCrm(BaseModel):
    id = BigIntegerField(verbose_name='id')
    counterpart = TextField(verbose_name='counterpart')
    trade_entity = CharField(max_length=255, verbose_name='trade_entity')
    client_type = CharField(max_length=255, verbose_name='client_type')
    markup_under = CharField(max_length=255, verbose_name='markup_under')
    markup_type = CharField(max_length=255, verbose_name='markup_type')
    markup_above = CharField(max_length=255, verbose_name='markup_above')
    fee_under = CharField(max_length=255, verbose_name='fee_under')
    fee_above = CharField(max_length=255, verbose_name='fee_above')
    fee_type = CharField(max_length=255, verbose_name='fee_type')
    quote_type = CharField(max_length=255, verbose_name='quote_type')
    receipt_delivery = CharField(max_length=255, verbose_name='receipt_delivery')
    notes = CharField(max_length=255, verbose_name='notes')
    add_date = DateTimeField(verbose_name='add_date')
    created_at = BigIntegerField(verbose_name='created_at')
    updated_at = BigIntegerField(verbose_name='updated_at')
    last_update = BigIntegerField(verbose_name='last_update')
    status = CharField(max_length=255, verbose_name='status')
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    filter_amount = CharField(max_length=255, verbose_name='filter_amount')
    account_id = CharField(max_length=50, verbose_name='account_id')
    class Meta:
        database = db
        table_name = 'otc_crm'


class Roles(BaseModelNoAddDate):
    role = CharField(max_length=255, verbose_name='role')
    view_ems = BooleanField(verbose_name='view_ems', default=False, help_text="")
    view_portal_admin = BooleanField(verbose_name='view_portal_admin', default=False, help_text="")
    trade = BooleanField(verbose_name='trade', default=False, help_text="")
    approve_yields = BooleanField(verbose_name='approve_yields', default=False, help_text="")
    created_at = DateTimeField(verbose_name='created_at')
    updated_at = DateTimeField(verbose_name='updated_at')


class Logins(BaseModel):
    user_id = CharField(max_length=255, verbose_name='user_id', null=True)
    created_at = CharField(max_length=20, verbose_name='created_at')
    datetime = DateTimeField(verbose_name='datetime')
    ip = CharField(max_length=128, verbose_name='ip')
    email = CharField(max_length=255, verbose_name='email', help_text='登陆用户的email', null=True)


class PrimeAgreement(BaseModel):
    """
    保存协议
    """
    pa_alias = CharField(max_length=255, help_text='协议唯一标识')
    created_at = DateTimeField(default=datetime.utcnow, help_text='协议录入时间')
    file_name = CharField(max_length=255, help_text='协议名称')
    status = CharField(max_length=10, help_text='协议状态 active/inactive', default='active')


class InternalWallets(BaseModel):
    id = BigIntegerField(verbose_name='id', index=True)
    name = CharField(max_length=255, verbose_name='name', help_text='名称')
    internal_wallet_id = CharField(max_length=255, verbose_name='internal_wallet_id')
    asset_id = CharField(max_length=255, verbose_name='asset_id', help_text='资产id')
    status = CharField(max_length=20, verbose_name='status', default='active', help_text='状态，active、inactive')
    address = CharField(max_length=255, verbose_name='address', help_text='币种地址')
    tag = CharField(max_length=255, verbose_name='tag')
    customer_ref_id = CharField(max_length=255, verbose_name='customer_ref_id', help_text='自定义标识，默认 internalwallet')
    vault_id = CharField(max_length=255, verbose_name='vault_id', help_text='账户id')
    source_workspace = CharField(max_length=255, verbose_name='source_workspace',
        help_text="源地址，如otc->custody转账，需将 custdoy 的钱包地址添加到 otc，source_workspace 记录的则是 custody 所属的 workspace")
    destination_workspace = CharField(max_length=255, verbose_name='destination_workspace',
        help_text="源地址，如otc->custody转账，需将 custdoy 的钱包地址添加到 otc，destination_workspace 记录的则是 otc 所属的 workspace")
    created_at = DateTimeField(verbose_name='created_at')
    last_updated = DateTimeField(verbose_name='last_updated')

    class Meta:
        database = db
        table_name = 'internal_wallets'


class IndividualAccountPreferences(BaseModel):
    class Meta:
        database = db
        table_name = 'individual_account_preferences'
    id = BigIntegerField(verbose_name="id", primary_key=True, help_text='主键')
    preferences_id = CharField(max_length=50, verbose_name="preferences_id", help_text='设置数据唯一标识符')
    entity_id = CharField(max_length=50, verbose_name="entity_id", help_text='users表自然人唯一标识符entity_id')
    account_id = CharField(max_length=50, verbose_name="account_id", null=True, help_text='account表唯一标识符')
    selected_email = CharField(max_length=255, verbose_name="selected_email", help_text='表示用户在preferences'
                                                                                        '中当前选中的的邮箱，如果是两个邮箱都接收信息，则要记两条记录。')
    email_login = BooleanField(verbose_name="email_login", default=False, help_text='邮箱登陆提醒')
    email_deposit = BooleanField(verbose_name="email_deposit", default=False, help_text='充币邮箱提醒')
    email_withdrawal = BooleanField(verbose_name="email_withdrawal", default=False, help_text='提币邮箱提醒')
    email_external_address_approved = BooleanField(verbose_name="email_external_address_approved", default=False,
                                                   help_text='邮箱同意外部地址')
    email_withdrawal_rejection = BooleanField(verbose_name="email_withdrawal_rejection", default=False,
                                              help_text='邮箱拒绝提币')
    display_currency = CharField(max_length=20, verbose_name="display_currency", default='USD',
                                 help_text='portal法币类型展示切换')
    email_weekly_market_updates = BooleanField(verbose_name="email_weekly_market_updates", default=False,
                                               help_text='邮件接收市场周报')
    email_monthly_holding_statements = BooleanField(verbose_name="email_monthly_holding_statements", default=False,
                                                    help_text='email_monthly_holding_statements')
    created_at = BigIntegerField(verbose_name='created_at', help_text='数据创建时间')
    last_updated = BigIntegerField(verbose_name='last_updated', help_text='数据最后修改时间')


class Balances(BaseModel):
    user_id = CharField(max_length=255, verbose_name='user_id', null=True)
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    quantity = CharField(max_length=255, verbose_name='quantity')
    type = CharField(max_length=255, verbose_name='type')
    status = CharField(max_length=255, verbose_name='status')
    created_at = BigIntegerField(verbose_name='created_at')
    last_updated = BigIntegerField(verbose_name='last_updated')
    datetime = DateTimeField(verbose_name='datetime')
    yield_id = CharField(max_length=255, verbose_name='yield_id', null=True)
    product_status = CharField(max_length=255, verbose_name='product_status')
    amount_usd = CharField(max_length=255, verbose_name='amount_usd', null=True)
    entity_id = CharField(max_length=50, verbose_name='entity_id', help_text='账户的entity_id', null=True)
    vault_id = CharField(max_length=50, verbose_name='vault_id', help_text='用户账户下的vault_id', null=True)
    account_id = CharField(max_length=50, verbose_name='account_id', help_text='账户的account_id', null=True)


class FiatTransactionsHistory(BaseModel):
    tx_id = CharField(max_length=255, verbose_name='tx_id')
    user_id = CharField(max_length=255, verbose_name='user_id', null=True)
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    admin_id = CharField(max_length=255, verbose_name='admin_id', null=True)
    amount = CharField(max_length=255, verbose_name='amount')
    amount_usd = CharField(max_length=255, verbose_name='amount_usd')
    operate = CharField(max_length=255, verbose_name='operate', null=True)
    name_reference = CharField(max_length=255, verbose_name='name_reference', null=True)
    datetime = DateTimeField(verbose_name='datetime')
    description = CharField(max_length=255, verbose_name='description', null=True)
    bank_account = CharField(max_length=255, verbose_name='bank_account', null=True)
    channel = CharField(max_length=255, verbose_name='channel', null=True)
    customer_name = CharField(max_length=255, verbose_name='customer_name', null=True)
    notified_customer = CharField(max_length=255, verbose_name='notified_customer', null=True)
    category = CharField(max_length=255, verbose_name='category')
    status = CharField(max_length=255, verbose_name='status')
    trade_id = CharField(max_length=255, verbose_name='trade_id', null=True)
    notes = CharField(max_length=255, verbose_name='notes', null=True)
    created_at = CharField(max_length=20, verbose_name='created_at')
    last_updated = CharField(max_length=20, verbose_name='last_updated')
    from_account_type = CharField(max_length=255, verbose_name='from_account_type', null=True)
    to_account_type = CharField(max_length=255, verbose_name='to_account_type', null=True)
    comment = CharField(max_length=255, verbose_name="comment", default="", help_text="用户note")
    entity_id = CharField(max_length=50, verbose_name='entity_id', help_text='账户对应的entity_id',null=True)
    email = CharField(max_length=255, verbose_name='email', help_text='操作用户登陆的email', null=True)
    vault_id = CharField(max_length=50, verbose_name='vault_id', help_text='登陆用户的账户下的vault_id', null=True)
    account_id = CharField(max_length=50, verbose_name='account_id', help_text='账户的account_id', null=True)


class UserBankInfo(BaseModel):
    # 数据库-字段
    user_id = CharField(max_length=255, verbose_name="user_id", help_text="用户id或组名", null=True)
    bank_id = CharField(max_length=255, verbose_name="bank_id", help_text="唯一id")
    nick_name = CharField(max_length=255, verbose_name="nick_name", help_text="签名")
    currency = CharField(max_length=16, verbose_name="currency", help_text="币种")
    intermediary_bank = CharField(max_length=255, verbose_name="intermediary_bank", help_text="bank信息")
    intermediary_swift = CharField(max_length=255, verbose_name="intermediary_swift", help_text="bank信息")
    beneficiary_bank = CharField(max_length=255, verbose_name="beneficiary_bank", help_text="bank信息")
    beneficiary_swift = CharField(max_length=255, verbose_name="beneficiary_swift", help_text="bank信息")
    final_beneficiary_bank = CharField(max_length=255, verbose_name="final_beneficiary_bank", help_text="bank信息")
    final_beneficiary_swift = CharField(max_length=255, verbose_name="final_beneficiary_swift", help_text="bank信息")
    final_beneficiary_bank_address = CharField(max_length=255, verbose_name="final_beneficiary_bank_address",
                                               help_text="bank信息")
    aba_bsb_routing_number = CharField(max_length=255, verbose_name="aba_bsb_routing_number", help_text="bank信息")
    iban_account_number = CharField(max_length=255, verbose_name="iban_account_number", help_text="bank信息")
    additional_reference = CharField(max_length=255, verbose_name="additional_reference", help_text="bank信息")
    file_info = TextField(verbose_name="file_info", help_text="文件列表（s3路径）")
    is_primary = BooleanField(verbose_name='is_primary', help_text='是否是主账户 t/f')
    status = CharField(max_length=50, verbose_name='status', help_text="状态 active/inactive")
    created_at = CharField(max_length=50, verbose_name="created_at", help_text="添加时间---时间字符串")
    updated_at = CharField(max_length=50, verbose_name="updated_at", help_text="更新时间---时间字符串")
    account_name = CharField(max_length=255, verbose_name="account_name", help_text="账户名", default='')
    account_address = CharField(max_length=255, verbose_name="account_address", help_text="账户地址", default='')
    counterparty = CharField(max_length=255, verbose_name='counterparty')
    account_id = CharField(max_length=50, verbose_name='account_id', help_text='用户账户的account_id', null=True)


class YieldsPending(BaseModel):
    id = BigIntegerField(verbose_name='id')
    user_id = CharField(max_length=255, verbose_name='user_id')
    yield_id = CharField(max_length=255, verbose_name='yield_id')
    asset_id = CharField(max_length=255, verbose_name='asset_id')
    amount = CharField(max_length=255, verbose_name='amount', help_text='目标账户转账之后的数量')
    apr = CharField(max_length=255, verbose_name='apr', null=True, help_text='收益率')
    term = CharField(max_length=255, verbose_name='term')
    type = CharField(max_length=255, verbose_name='type', help_text='账户类型')
    status = CharField(max_length=255, verbose_name='status')
    created_at = CharField(max_length=20, verbose_name='created_at')
    last_updated = CharField(max_length=20, verbose_name='last_updated')
    amount_change = CharField(max_length=255, verbose_name='amount_change', help_text='发起请求的数量')
    interest_usd = CharField(max_length=255, verbose_name='interest_usd', help_text='未结算的收益美金')
    interest_crypto = CharField(max_length=255, verbose_name='interest_crypto', help_text='未结算的收益')
    operate = CharField(max_length=255, verbose_name='operate')
    tx_id = CharField(max_length=255, verbose_name='tx_id')
    entity_id = CharField(max_length=50, verbose_name="entity_id", help_text="登陆用户的individual的entity_id")
    account_id = CharField(max_length=50, verbose_name="account_id", help_text="用户操作的账户account_id")
    email = CharField(max_length=255, verbose_name="email", help_text="用户的email")
    vault_id = CharField(max_length=50, verbose_name="vault_id", index=True, help_text="用户的vault_id")


class EmailLog(BaseModel):
    class Meta:
        database = db
        table_name = 'email_log'

    receiving_email = TextField(verbose_name='receiving_email', null=False)
    entity_id = CharField(max_length=50, verbose_name='entity_id', null=False)
    account_id = CharField(max_length=50, verbose_name='account_id', null=False)
    system = CharField(max_length=50, verbose_name='system', null=False, default="")
    model = CharField(max_length=50, verbose_name='model', null=False, default="")
    sub_model = CharField(max_length=50, verbose_name='sub_model', null=False, default="")
    operate = CharField(max_length=50, verbose_name='operate', null=False, default="")
    from_address = CharField(max_length=50, verbose_name='from_address', null=False, default="")
    cc_email = CharField(max_length=50, verbose_name='cc_email', null=False, default="")
    send_date = CharField(max_length=50, verbose_name='send_date', null=False)
    email_tempalte = CharField(max_length=50, verbose_name='email_tempalte', null=False, default="")
    email_tempalte_name = CharField(max_length=50, verbose_name='email_tempalte_name', null=False, default="")
    email_tempalte_id = CharField(max_length=50, verbose_name='email_tempalte_id', null=False, default="")
    content = TextField(verbose_name='content', null=False, default="")
    attachment_name = CharField(max_length=255, verbose_name='attachment_name', null=False, default="")
    trader_identifier = CharField(max_length=50, verbose_name='trader_identifier', null=False, default="")
    result = CharField(max_length=50, verbose_name='result', null=False, help_text="fail/success")
    status = CharField(max_length=50, verbose_name='status', null=False, help_text="active/inactive", default="active")
    account_name = CharField(max_length=255, verbose_name='account_name', null=False, help_text="日志记录时的account_name")
    entity_name = CharField(max_length=255, verbose_name='entity_name', null=False, help_text="日志记录时的entity_name")


class OtcFee(BaseModel):
    class Meta:
        database = db
        table_name = 'otc_fee'

    id = BigIntegerField(verbose_name='id')
    account_id = CharField(max_length=50, verbose_name="account_id", help_text="账户唯一 id")
    symbol_type = CharField(max_length=50, verbose_name='symbol_type', help_text='用于区分客户otc交易时不同类型的交易对'
                                                                                 'Majors: BTC/ETH as a base asset, fiat +USDT/USDC as quote;'
                                                                                 'Stablecoins:USDT/USDC to fiat:'
                                                                                 'Altcoins: Everything else.'
                                                                                 'All: 表示不分类')
    trade_entity = CharField(max_length=50, verbose_name='trade_entity', help_text='宫户选择的otc交易实体，zerocap/vesper')
    filter_amount = CharField(max_length=50, verbose_name='filter_amount', help_text='计算otc_fee的算费标准额度')
    markup_under = CharField(max_length=50, verbose_name='markup_under', help_text='表示账面交易额低于filter_amount的，markup费扣费数')
    fee_under = CharField(max_length=50, verbose_name='fee_under', help_text='表示账面交易额低于filter_amount的，markup费扣费数')
    markup_above = CharField(max_length=50, verbose_name='markup_above', help_text='表示账面交易额高于filter_amount的,markup费扣费数')
    fee_above = CharField(max_length=50, verbose_name='fee_above', help_text='表示账面交易额高于filter_amount的,otc费扣费数')
    fee_type = CharField(max_length=50, verbose_name='fee_type', help_text='表示收费类型是美separate或included')
    status = CharField(max_length=10, verbose_name='status', help_text='表示这条数据是否在前端展示active/inactive')
    trade_identifier = CharField(max_length=100, verbose_name='trade_identifier', help_text='交易员邮箱')
    created_at = BigIntegerField(verbose_name='created_at', help_text='创建时间')
    last_updated = BigIntegerField(verbose_name='last_updated', help_text='最后修改时间')
    above_markup_type = CharField(max_length=50, verbose_name='markup_type', help_text='表示markup单位类型')
    above_fee_unit = CharField(max_length=50, verbose_name='fee_unit', help_text='表示收费的单位')
    under_markup_type = CharField(max_length=50, verbose_name='markup_type', help_text='表示markup单位类型')
    under_fee_unit = CharField(max_length=50, verbose_name='fee_unit', help_text='表示收费的单位')
    notional_unit = CharField(max_length=50, verbose_name="notional_unit", help_text="USD/AUD/EUR/GBP")


class CrmNotes(BaseModel):
    class Meta:
        database = db
        table_name = 'crm_notes'

    id = BigIntegerField(verbose_name='id')
    note_id = CharField(max_length=50, verbose_name="note_id", help_text="note 数据唯一标识")
    account_id = CharField(max_length=50, verbose_name="account_id", help_text="账户唯一 id")
    trade_identifier = CharField(max_length=100, verbose_name='trade_identifier', help_text='交易员邮箱')
    status = CharField(max_length=10, verbose_name='status', help_text='数据状态')
    content = TextField(verbose_name='content', help_text='业务备注内容')
    created_at = BigIntegerField(verbose_name='created_at', help_text='创建时间')
    last_updated = BigIntegerField(verbose_name='last_update', help_text='最后修改时间')


class DmaConfig(BaseModel):
    class Meta:
        database = db
        table_name = 'dma_config'

    id = BigIntegerField(verbose_name='id')
    symbol = CharField(max_length=50, verbose_name="symbol", help_text="交易对")
    price_stream = CharField(max_length=50, verbose_name="price_stream")
    place_orders = CharField(max_length=50, verbose_name="place_orders")
    px_sig = CharField(max_length=50, verbose_name="px_sig")
    qty_sig = CharField(max_length=50, verbose_name="qty_sig")
    max_order = CharField(max_length=50, verbose_name="max_order")
    min_order = CharField(max_length=50, verbose_name="min_order")
    buy_spread = CharField(max_length=50, verbose_name="buy_spread")
    sell_spread = CharField(max_length=50, verbose_name="sell_spread")
    status = CharField(max_length=10, verbose_name='status', help_text='数据状态')
    created_at = BigIntegerField(verbose_name='created_at', help_text='创建时间')
    last_updated = BigIntegerField(verbose_name='last_updated', help_text='最后修改时间')
    add_date = DateTimeField(verbose_name='add_date')


class DmaLadderConfig(BaseModel):
    class Meta:
        database = db
        table_name = 'dma_ladder_config'

    id = BigIntegerField(verbose_name='id')
    symbol = CharField(max_length=50, verbose_name="symbol", help_text="交易对")
    quantity = CharField(max_length=50, verbose_name="quantity")
    spread = CharField(max_length=50, verbose_name="spread")
    status = CharField(max_length=10, verbose_name='status', help_text='数据状态')
    created_at = BigIntegerField(verbose_name='created_at', help_text='创建时间')
    last_updated = BigIntegerField(verbose_name='last_updated', help_text='最后修改时间')
    add_date = DateTimeField(verbose_name='add_date')


class MarketsConfig(BaseModel):
    class Meta:
        database = db
        table_name = 'markets_config'

    market_name = CharField(max_length=50, verbose_name="market_name", help_text="市场名称")
    account_name = CharField(max_length=50, verbose_name="account_name")
    category = CharField(max_length=255, verbose_name="category", help_text="市场类别")
    status = CharField(max_length=50, verbose_name='status', help_text='数据状态')
    created_at = BigIntegerField(verbose_name='created_at', help_text='创建时间')
    updated_at = BigIntegerField(verbose_name='created_at', help_text='最后修改时间')


def init_table():
    db.create_tables([InternalWallets])


if __name__ == "__main__":
    init_table()

    # order = {
    #     "order_alias": "1234567",
    #     "order_id": "1234567",
    #     "order_type": OrderTypeEnum.Limit,
    #     "status": OrderStatusEnum.Open,
    #     "base_asset": "BTC",
    #     "quote_asset": "USD",
    #     "side": SideEnum.Buy,
    #     "quantity": "1",
    #     "leaves_quantity":"2",
    #     "filled_quantity":"1",
    #     "notional": NotionalEnum.Base,
    #     "price": "16200",
    #     "avg_price": "16180",
    #     "user_id": "123456",
    #     "trader_identifier": "123456",
    #     "entity": EntityEnum.zerocap,
    #     "dealers": "b2c2",
    #     "fee": "200",
    #     "fee_type": FeeTypeEnum.Separate,
    #     "fee_total": "200",
    #     "fee_notional": FeeNotionalEnum.Base,
    #     "is_place": False
    # }
    #
    # order = Orders.create(**order)
    # print(order)
    # order = Orders.select().where(Orders.id==6)[0]
    # print(order.side)   # SideEnum.Sell
    # print(order.side.value) # sell
    # order.side = SideEnum.Sell
    # order.save()

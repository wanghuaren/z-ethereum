from db.models import Assets, Chains, UserBankInfo, TransactionsHistory
from config.config import OTCSupportedFiat


def check_assets(id):
    return Assets.select().where((Assets.id == id) & (Assets.status == 'active')).exists()


def check_asset_is_main_or_altion(asset_id):
    return Assets.select().where((Assets.id == asset_id) & (Assets.status == 'active') & (Assets.business_type.in_(['main', 'altcoin']))).exists()


def query_asset_id_by_id(id):
    response = Assets.select().where((Assets.id == id) & (Assets.status == 'active'))
    result = None
    for i in response:
        result = {
            "id": i.id,
            "business_type": i.business_type
        }

    return result


def insert_assets(asset_id, new_altcoin, business_type, ticker):
    default_value = lambda x, y: y if x == '' else x
    Assets.insert(
        id=asset_id.upper(),
        chain_id="1f1030bd-704c-4bef-8d67-4036af30a083",
        ticker=ticker.upper(),
        name=new_altcoin.get("name"),
        type="crypto",
        business_type=business_type,
        decimals=int(new_altcoin.get("decimals")),
        qty_prec=int(default_value(new_altcoin.get("qty_prec"), '4')),
        px_prec=int(default_value(new_altcoin.get("px_prec"), '4')),
        conf_blocks=0,
        min_withdraw=default_value(new_altcoin.get("px_prec"), '10'),
        max_withdraw=default_value(new_altcoin.get("px_prec"), '1000'),
        fee="",
        status="active",
    ).execute()


def query_asset_qty_prec_by_quote_asset_id(asset_id):
    response = Assets.select(Assets.qty_prec).where(Assets.id == asset_id).first()
    result = None
    if response:
        return response.qty_prec

    return result


def get_asset_source_url(asset_id):
    response = Chains.select(Chains.source_url).where(Chains.name == asset_id)
    source_url = ""
    for res in response:
        source_url = res.source_url
    return source_url


def get_bank_info_by_account(account_id):
    response = UserBankInfo.select(UserBankInfo.bank_id, UserBankInfo.account_name,
                                   UserBankInfo.iban_account_number).where(UserBankInfo.account_id == account_id,
                                   UserBankInfo.status == 'active')

    result = []
    for res in response:
        data = {
            "bank_id": res.bank_id,
            "account_name": res.account_name,
            "iban_account_number": res.iban_account_number
        }
        result.append(data)

    return result


def is_fiat_asset(asset_id, account_id):
    response = Assets.select(Assets.type).where((Assets.id == asset_id) & (Assets.status == 'active')).first()
    if response:
        if response.type.lower() == 'fiat' and asset_id in OTCSupportedFiat:
            # 是支持的 6 种法币，需要查询 bank 信息返回给前端
            message = 'True'
            bank_list = get_bank_info_by_account(account_id)
            return message, bank_list
        elif response.type.lower() == 'fiat':
            message = 'True'
        else:
            message = 'False'
    else:
        message = 'False'
    return message, ''


def get_asset_fb_id(asset_id):
    response = Assets.select(Assets.fb_id).where((Assets.id == asset_id) &
                                                 (Assets.status == 'active') &
                                                 (Assets.business_type.in_(['main', 'altcoin']))).first()
    fb_id = ""
    if response:
        fb_id = response.fb_id
    if not fb_id:
        fb_id = ''
    return fb_id


def get_transactionshistory_status(asset_id, account_id, vault_id):
    # 只获取ems payment与 portal 提币的状态
    response = TransactionsHistory.select(TransactionsHistory.status).where(
        (TransactionsHistory.asset_id == asset_id) &
        (TransactionsHistory.account_id == account_id) &
        (TransactionsHistory.vault_id == vault_id) &
        (((TransactionsHistory.type.in_(['payment_confirmation']) &
          (TransactionsHistory.status.not_in(['COMPLETED', 'REJECTED', 'DELETED', 'CANCELLED', 'COMPLETED_SUB'])))) |  # portal 可以再次发起的状态
         ((TransactionsHistory.from_account_type == 'custody') &
         (TransactionsHistory.to_account_type.in_(['external_deposit', 'external_withdrawal'])) &   # portal 可以再次发起的状态
         (TransactionsHistory.status.not_in(['COMPLETED', 'REJECTED', 'DELETED', 'CANCELLED', 'FAILED',
                                             'expired', 'timeout', 'rejected', 'deleted', 'COMPLETED_SUB']))))).first()
    status = ""
    if response:
        status = response.status
    return status

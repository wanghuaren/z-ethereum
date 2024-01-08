from db.models import Vaults, ExternalWalletPropTrading, Addresses
from utils.consts import StatusDeleted


def update_vault_crid(vault_id, customer_ref_id):
    Vaults.update(customer_ref_id=customer_ref_id).where(Vaults.vault_id == vault_id).execute()
    return customer_ref_id


def get_wallet_pool_by_user_id_and_asset_id(asset_id, vault_id, account_id, workspace, external_wallet_id=None):
    flt = [(ExternalWalletPropTrading.status != StatusDeleted)]
    if asset_id:
        flt.append(ExternalWalletPropTrading.asset_id == asset_id)
    if vault_id:
        flt.append(ExternalWalletPropTrading.vault_id == vault_id)
    if workspace:
        flt.append(ExternalWalletPropTrading.workspace == workspace)
    if account_id:
        flt.append(ExternalWalletPropTrading.account_id == account_id)
    if external_wallet_id:
        flt.append(ExternalWalletPropTrading.external_wallet_id == external_wallet_id)

    external_wallet_prop_trading = ExternalWalletPropTrading.select().where(*flt).order_by(
        ExternalWalletPropTrading.created_at.asc())
    result = []
    for i in external_wallet_prop_trading:
        result.append({
            'user_id': i.user_id,
            'asset_id': i.asset_id,
            'external_wallet_id': i.external_wallet_id,
            'address': i.address,
            'tag': i.tag,
            'customer_ref_id': i.customer_ref_id,
            'status': i.status,
            'name': i.name,
            'workspace': i.workspace,
            'vault_id': i.vault_id,
        })
    if result:
        return result


def create_wallet_pool(external_wallet_pool_dic):
    external_wallet_pool_lst = [external_wallet_pool_dic]
    ExternalWalletPropTrading.insert_many(external_wallet_pool_lst).execute()


def get_address(account_id, asset_id):
    address = Addresses.select().where(
        (Addresses.account_id == account_id)
        & (Addresses.asset_id == asset_id)
        & (Addresses.status == 'active')).first()

    if address:
        return {
            'user_id': address.user_id,
            'asset_id': address.asset_id,
            'address': address.address,
            'created_at': address.created_at,
            'last_updated': address.last_updated,
            'status': address.status,
            'add_date': address.add_date
        }


def create_address(address_dic):
    address_lst = [address_dic]
    Addresses.insert_many(address_lst).execute()


def query_vault_workspace(vault_id, account_id):
    response = Vaults.get_or_none((Vaults.vault_id == vault_id) & (Vaults.account_id == account_id) & (Vaults.status == 'active'))
    if response and response.workspace:
        return response.workspace
    return 'zerocap_portal'

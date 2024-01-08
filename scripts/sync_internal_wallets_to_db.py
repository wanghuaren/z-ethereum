import sys
sys.path.append('../')

from db.models import InternalWallets
from external_api.fireblocks.fireblocks_gateway import FireblocksGateway


def get_internal_wallets(self):
    """Gets an internal wallet from your tenant
    Args:
        wallet_id (str): The wallet id to query
    """


def create_internal_wallet(self, name, customer_ref_id=None, idempotency_key=None):
    """Creates a new internal wallet

    Args:
        name (str): A name for the new internal wallet
        customer_ref_id (str, optional): The ID for AML providers to associate the owner of funds with transactions
        idempotency_key (str, optional)
    """

def create_external_wallet_asset(self, wallet_id, asset_id, address, tag=None, idempotency_key=None):
    """Creates a new asset within an exiting external wallet

    Args:
        wallet_id (str): The wallet id
        asset_id (str): The symbol of the asset to add (e.g BTC, ETH)
        address (str): The wallet address
        tag (str, optional): (for ripple only) The ripple account tag
        idempotency_key (str, optional)
    """


def get_wallet_id_and_address(vault_id, address):
    # 根据已知的地址获取 wallet_id
    client = FireblocksGateway()
    fb_client = client.fireblock_client(vault_id=vault_id, workspace='Zerocap')
    res = fb_client.get_internal_wallets()
    for r in res:
        for a in r["assets"]:
            if a["address"] != address:
                continue
            return r
        

def create_new_internal_wallet(vault_id, source_address, destination_address):
    client = FireblocksGateway()
    fb_client = client.fireblock_client(vault_id=vault_id, workspace='Zerocap')
    return fb_client.create_internal_wallet(name=f"otc_internal_wallet:{source_address}->{destination_address}")
        

def write_internal_wallet(name, internal_wallet_id, vault_id, user_id, asset_id, address):
    # 写入数据库
    InternalWallets.insert(
        name=name,
        internal_wallet_id=internal_wallet_id,
        vault_id=vault_id,
        user_id=user_id,
        asset_id=asset_id,
        address=address,
        status="active",
        customer_ref_id="internalwallet",
        source_workspace="Zerocap",
        destination_workspace="Zerocap"
    )
    
        

def main():
    # uat
    vaults = [{"vault_id": "222", "destination_workspace": "zerocap_protal"}, 
              {"vault_id": "222", "destination_workspace": "zerocap_staking"}]
    # prod 
    # vaults = [{"vault_id": "3", "destination_workspace": "zerocap_protal"}, 
    #           {"vault_id": "3", "destination_workspace": "zerocap_staking"},
    #           {"vault_id": "4", "destination_workspace": "zerocap_protal"}, 
    #           {"vault_id": "4", "destination_workspace": "zerocap_staking"}]
    for vault in vaults:
        # create_internal_wallet(vault["vault_id"], "Zerocap", vault["destination_workspace"])
        wallets = get_wallet_id_and_address(vault["vault_id"], vault["address"])
        print(f"vault_id:{wallets}, \n wallets: {wallets}")
        

if __name__ == '__main__':
    main()

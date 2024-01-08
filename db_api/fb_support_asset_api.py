from db.models import FbSupportedAssets


def get_fb_supported_asset_by_id(coingecko_id):
    response = FbSupportedAssets.select(FbSupportedAssets.id).where(
        (FbSupportedAssets.coingecko_id == coingecko_id)& (~FbSupportedAssets.id.contains('TEST')))
    if response:
        for asset in response:
            return asset.id
    return None


def does_it_exist_from_fb(asset_id: str) -> bool:
    return FbSupportedAssets.select(FbSupportedAssets.id).where(FbSupportedAssets.id == asset_id).exists()

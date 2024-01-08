from db.models import Symbols, EMSSymbols, Assets
import uuid

from internal.rfq.data_helper import conn


def query_symbols_by_base_usd(base_asset_id):
    response = Symbols.select(Symbols.id, Symbols.base_asset_id, Symbols.platform, Symbols.source).\
        where((Symbols.base_asset_id == base_asset_id) & (Symbols.quote_asset_id == 'USD') & (Symbols.status == 'active'))

    result = {}
    for i in response:
        result = {
            "id": i.id,
            "base_asset_id": i.base_asset_id,
            "platform": i.platform,
            "source": eval(i.source)
        }
    return result


def insert_symbols(asset_id, new_altcoin, quote_asset_id='USD'):
    default_value = lambda x, y: y if x == '' else x
    Symbols.insert(
        id=str(uuid.uuid1()),
        base_asset_id=asset_id.upper(),
        quote_asset_id=quote_asset_id,
        ticker=new_altcoin.get("id").upper() + "/" + quote_asset_id,
        px_sig=int(default_value(new_altcoin.get("px_prec"), '4')),
        qty_sig=int(default_value(new_altcoin.get("qty_prec"), '4')),
        min_qty="0",
        max_qty="0",
        transaction_sizes="{}",
        source="{gck}",
        platform="ems",
        status="active",
        currency_sig=16
    ).execute()


def update_symbols(symbols_dic):
    id = symbols_dic['id']
    Symbols.update(symbols_dic).where((Symbols.id == id)).execute()


def query_symbols_by_base_quote_asset_id(base_asset_id, quote_asset_id, dealers):
    if dealers == "gck":
        response = Symbols.select(Symbols.ticker, Symbols.qty_sig, Symbols.px_sig). \
            where(Symbols.base_asset_id == base_asset_id, Symbols.quote_asset_id == quote_asset_id,
                  Symbols.status == 'active', Symbols.source == 'gck', Symbols.platform == 'ems')
    else:
        response = EMSSymbols.select(EMSSymbols.ticker, EMSSymbols.qty_sig, EMSSymbols.px_sig). \
            where((EMSSymbols.base_asset_id == base_asset_id) & (EMSSymbols.quote_asset_id == quote_asset_id) & (
                    EMSSymbols.status == 'active'))

    result = {}
    for i in response:
        qty_sig = min(result.get('qty_sig'), i.qty_sig) if result.get('qty_sig') else i.qty_sig
        px_sig = min(result.get('px_sig'), i.px_sig) if result.get('px_sig') else i.px_sig
        result = {
            "ticker": i.ticker,
            "qty_sig": qty_sig,
            "px_sig": px_sig,
        }
    return result


def get_asset_ticker_by_symbol_precision(symbol, source):
    base_asset_id = symbol.split("/")[0]
    quote_asset_id = symbol.split("/")[1]
    source = "','".join(source)
    sql = f"""SELECT 
                base_asset_id, 
                quote_asset_id, 
                "min"(qty_sig) as qty_sig, 
                "min"(px_sig) as px_sig 
            FROM 
                (SELECT 
                    ticker, CAST(source as VARCHAR), base_asset_id, quote_asset_id, qty_sig, px_sig 
                FROM 
                    ems_symbols 
                WHERE ticker = '{symbol}' and status = 'active' and qty_sig != '0'
                UNION 
                SELECT 
                    ticker, CAST(source as VARCHAR), base_asset_id, quote_asset_id, qty_sig, px_sig
                FROM symbols 
                WHERE base_asset_id = '{base_asset_id}' and quote_asset_id = '{quote_asset_id}' and status = 'active' and qty_sig != '0' and platform like '%%ems%%') as t1 
            WHERE (t1.ticker = '{symbol}' or (base_asset_id = '{base_asset_id}' and quote_asset_id = '{quote_asset_id}')) AND CAST(source as VARCHAR) in ('{source}') 
            GROUP BY ticker, base_asset_id, quote_asset_id;"""
    res_data = conn.execute(sql).fetchall()
    if res_data:
        for i in res_data:
            base_asset = i[0]
            quote_asset = i[1]
            qty_sig = i[2]
            px_sig = i[3]

            return int(qty_sig), int(px_sig), base_asset, quote_asset
    return 0, 0, base_asset_id, quote_asset_id


def get_asset_precision_by_asset_ticker(quote_asset):
    res = Assets.select(Assets.qty_prec, Assets.px_prec).where(Assets.ticker == quote_asset).first()
    if res:
        return res.qty_prec, res.px_prec


if __name__ == '__main__':
    # query_symbols_by_base_usd('LEO')
    print(get_asset_precision_by_asset_ticker("HTN"))

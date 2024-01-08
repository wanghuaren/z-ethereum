from db.models import Gckdata


def query_gckdata_by_id_list(id_list):
    response = Gckdata.select().where(Gckdata.id.in_(id_list))
    result = []
    if response:
        for each_response in response:
            result.append({
                "id": each_response.id,
                "ticker": each_response.symbol,
                "name": each_response.name,
                "type": 'crypto',
                "decimals": each_response.decimals,
                "qty_prec": each_response.qty_prec,
                "px_prec": each_response.px_prec,
                "min_withdraw": "10",
                "max_withdraw": "1000"
            })
    return result

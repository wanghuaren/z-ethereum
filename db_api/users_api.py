from db.models import Users, TraderConfig, Individuals


def query_users_user_id_by_email(email):
    res = Users.select(Users.user_id).where(Users.email == email).first()
    return res.user_id if res else None


def get_all_key_secret():
    """
    获取 trader_config 表中所有状态为 active 的加密中的 api_key 和 secret
    """

    response = TraderConfig.select(TraderConfig.email, TraderConfig.trader_identifier, TraderConfig.key, TraderConfig.secret).\
        where(TraderConfig.status == 'active')

    result = []
    for res in response:
        result.append({
            "email": res.email,
            "trader_identifier": res.trader_identifier,
            "api_key": res.key,
            "api_secret": res.secret
        })
    return result


def query_tenant_by_user_id(user_id):
    res = Users.select(Users.entity_id).where(Users.user_id == user_id).first()

    if not res:
        raise Exception("invalid user_id!")

    indi_res = Individuals.select(Individuals.tenant).where(Individuals.entity_id == res.entity_id).first()
    return indi_res.tenant if indi_res else None


from functools import reduce
from peewee import operator
from utils.logger import logger
from utils.zc_exception import ZCException
from utils.date_time_utils import get_template_time_format_from_timestamp
from db.models import EntityAccount, EntityRelation, Individuals, Companys, Trusts, Groups, AccountInfo, \
    IndividualAccountPreferences, Vaults, Users
from config.config import EmailLogConfig, OperateSettlement


def get_entity_name(account_id, is_history_data=False):
    """
    1.根据表中的 account id 查询 entity account. 获取到 entity_id;
    2.然后查 entity_relation，定位 parent_entity_id 和 parent_entity_type，
      然后到对应的 company、trust、group 中查name;
    3.如果 entity_relation 中没有，则从 individual中查name;
    """
    response = EntityAccount.select(EntityAccount.entity_id).where(EntityAccount.account_id == account_id,
                                                                   EntityAccount.status == 'active').first()
    if not response:
        logger.error("Invalid account id!")
        raise Exception("Invalid account id!")
    entity_id = response.entity_id

    if not is_history_data:
        response = EntityRelation.select(EntityRelation.entity_id, EntityRelation.parent_entity_id,
                                         EntityRelation.parent_entity_type). \
            where(EntityRelation.status == 'active', EntityRelation.parent_entity_id == entity_id).first()
    else:
        response = EntityRelation.select(EntityRelation.entity_id, EntityRelation.parent_entity_id,
                                         EntityRelation.parent_entity_type). \
            where(EntityRelation.parent_entity_id == entity_id).first()
    if not response:
        if not is_history_data:
            res = Individuals.select(Individuals.first_name, Individuals.last_name).where(
                Individuals.status=='active', Individuals.entity_id == entity_id).first()
        else:
            res = Individuals.select(Individuals.first_name, Individuals.last_name).where(
                Individuals.entity_id == entity_id).first()
        if not res:
            logger.error("Invalid account_id!")
            raise Exception("Invalid account_id!")
        first_name = res.first_name if res.first_name else ""
        last_name = res.last_name if res.last_name else ""
        return first_name + " " + last_name

    relation_entity_id = response.entity_id
    parent_entity_id = response.parent_entity_id
    parent_entity_type = response.parent_entity_type

    if parent_entity_type == "group":  # 如果是组账户, 还是使用 Individuals 表的 name
        res = Individuals.select(Individuals.first_name, Individuals.last_name).where(
            Individuals.entity_id == relation_entity_id, Individuals.status == 'active').first()
        first_name = res.first_name if res.first_name else ""
        last_name = res.last_name if res.last_name else ""
        return first_name + " " + last_name

    elif parent_entity_type == "company":
        res = Companys.select(Companys.company_name).where(
            Companys.entity_id == parent_entity_id, Companys.status == 'active').first()
        company_name = res.company_name
        return company_name

    elif parent_entity_type == "trust":
        res = Trusts.select(Trusts.trust_name).where(
            Trusts.entity_id == parent_entity_id, Trusts.status == 'active').first()
        trust_name = res.trust_name
        return trust_name

    else:
        logger.error("Invalid parent entity type!")
        raise Exception("Invalid parent entity type!")


def get_trader_name(account_id):
    """
    1.根据表中的 account id 查询 entity account 获取到 entity_id;
    2.然后到 individual 中查name;
    """
    response = EntityAccount.select(EntityAccount.entity_id).where(EntityAccount.account_id == account_id,
                                                                   EntityAccount.status == 'active').first()
    if not response:
        logger.error("Invalid account id!")
        raise ZCException("Invalid account id!")
    entity_id = response.entity_id

    res = Individuals.select(Individuals.first_name, Individuals.last_name).where(Individuals.entity_id == entity_id,
                                                                                  Individuals.status == 'active').first()
    first_name = res.first_name if res.first_name else ""
    last_name = res.last_name if res.last_name else ""
    return first_name + " " + last_name


def get_account_name(account_id):
    """
    1.根据 account_id 获取 account_info 中的 name;
    2.使用 account_name + account_id 后六位，组成 account_name 返回;
    """
    response = AccountInfo.select(AccountInfo.account_name).where(
        (AccountInfo.account_id == account_id) & (AccountInfo.status == "active")).first()
    if not response:
        logger.error(f"get_account_name: Invalid account id!account id {account_id}")
        raise ZCException("Invalid account id!")
    account_name = response.account_name
    return account_name


def send_fiat_or_altcoin_mail(request, operate_type, email_service):
    """
        notified_customer: 通知客户，默认为true
        account_id: 查询交易主体， 如果是zerocap_portal，才进行邮件发送
        amount: 数量
        asset id: 币种
        operate_type: "withdrawal", "deposit"
        asset_type: "fiat", "altcoin"
        email_service：email
    """
    account_id = request.account_id
    user_id = request.user_id
    amount = request.amount
    asset_id = request.asset_id
    trader_identifier = request.trader_identifier

    tenant = get_tenant_by_account_id(account_id)
    if tenant != "zerocap_portal":
        return

    mails = get_emails_by_fiat_or_altcoin(account_id, operate_type=operate_type)
    if not mails:
        return

    if operate_type == "deposit":
        operateinfo = "deposit"
        operateinfo_deal = "into"
    else:
        operateinfo = "withdrawal"
        operateinfo_deal = "from"

    account_name = get_account_name(account_id)
    logger.info(f"send_fiat_or_altcoin_mail: account_name {account_name}")
    data = {
        "title_operate": operateinfo.capitalize(),
        "operateinfo": operateinfo,
        "amountInfo": f"{amount} {asset_id}",
        "last_updated": get_template_time_format_from_timestamp(),
        "account_name": account_name,
        "operateinfo_deal": operateinfo_deal
    }

    logger.info(f"send_fiat_or_altcoin_mail: data={data}")
    user_res = Users.select(Users.entity_id).where(Users.user_id == user_id, Users.status == 'active').first()

    email_log = {
        "email_tempalte": "send_receipt",
        "account_name": account_name,
        "account_id": account_id,
        "entity_id": user_res.entity_id,
        "entity_name": get_entity_name(account_id),
        "trader_identifier": trader_identifier
    }
    email_log.update(EmailLogConfig["ems_transfer"])
    if request.side == "settlement":
        email_log["operate"] = OperateSettlement

    email_service.send_email(
        to_emails=mails,
        data=data,
        template='new_fiat_altcoin_transfer',
        tenant=tenant,
        email_log=email_log)
    logger.info(f"send_fiat_or_altcoin_mail: end")


def get_tenant_by_account_id(account_id):
    res_entity_id = EntityAccount.select(EntityAccount.entity_id).where(
        (EntityAccount.account_id == account_id) & (EntityAccount.status == 'active')).first()
    if not res_entity_id:
        logger.info(f"get_tenant_by_account_id: can't find entity_id of account {account_id}")
        raise Exception(f"can't find entity_id of account {account_id}")
    res = Individuals.select(Individuals.tenant).where(Individuals.entity_id == res_entity_id.entity_id).first()
    if not res:
        res_entity = EntityRelation.select(EntityRelation.entity_id).where(EntityRelation.parent_entity_id == res_entity_id.entity_id,
                                                              EntityRelation.status == 'active',
                                                              EntityRelation.entity_type == 'individual')
        print(res_entity)
        res_individual = Individuals.select(Individuals.tenant).where(Individuals.status == 'active',
                                                                      Individuals.entity_id.in_(res_entity)).first()
        if not res_individual:
            logger.info(f"get_tenant_by_account_id: can't find tenant of account {account_id}")
            raise Exception(f"can't find tenant of account {account_id}")
        return res_individual.tenant
    logger.info(f"get_tenant_by_account_id: res.tenant: {res.tenant}")
    return res.tenant


# 获取法币或者小币进行充币、取币操作信息发送的邮箱, operate: deposit, withdrawal
def get_emails_by_fiat_or_altcoin(account_id, operate_type):
    if not operate_type:
        return
    operates = []
    if operate_type == "deposit":
        operates.append(IndividualAccountPreferences.email_deposit == True)
    if operate_type == "withdrawal":
        operates.append(IndividualAccountPreferences.email_withdrawal == True)
    if account_id:
        operates.append(IndividualAccountPreferences.account_id == account_id)

    res = IndividualAccountPreferences.select(IndividualAccountPreferences.selected_email). \
        where(reduce(operator.and_, operates))
    # 查询邮件是否存在，打印日志
    email_list = []
    for i in res:
        email_list.append(i.selected_email)
    email_list = list(set(email_list))
    logger.info(f"get_emails_by_fiat_or_altcoin: email_list={email_list}")
    return email_list


def query_workspace_by_account_id_vault_id(account_id, vault_id):
    res = Vaults.select(Vaults.workspace).where((Vaults.account_id == account_id) &
                                                (Vaults.vault_id == vault_id) & (Vaults.status == 'active')).first()
    return res.workspace if res.workspace else None


def get_client_name(user_id):
    """
    根据 user_id 查询 Individuals 表中的 name
    """
    user_res = Users.select(Users.entity_id, Users.email).where(Users.user_id == user_id, Users.status == 'active').first()
    if not user_res:
        logger.error("Invalid user id!")
        raise Exception("Invalid user id!")
    user_email = user_res.email
    ind_res = Individuals.select(Individuals.first_name, Individuals.last_name).where(
        Individuals.entity_id == user_res.entity_id, Individuals.status == 'active').first()
    if not ind_res:
        logger.error("Invalid entity id!")
        raise Exception("Invalid entity id!")

    first_name = ind_res.first_name or ""
    last_name = ind_res.last_name or ""

    if first_name == "" and last_name == "":
        stitching_name = user_email
    else:
        stitching_name = first_name + " " + last_name
    return first_name, last_name, stitching_name, user_email


def get_email_by_user_id(user_id):
    res = Users.select(Users.email).where(Users.user_id == user_id, Users.status == 'active').first()
    if not res:
        logger.error("Invalid user id!")
        raise Exception("Invalid user id!")
    return res.email


def get_entity_id_by_user_id(user_id):
    res = Users.select(Users.entity_id).where(Users.user_id == user_id, Users.status == 'active').first()
    if not res:
        logger.error("Invalid user id!")
        raise Exception("Invalid user id!")
    return res.entity_id


if __name__ == '__main__':
    print(get_entity_name("0e7eture-6476-4466-8ab8-d65b8e210e3c"))
    print(get_trader_name("0e7efe49-6476-4466-8bb8-d65b8e210e3c"))

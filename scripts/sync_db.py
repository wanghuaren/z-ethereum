import sys
import os
import time
import traceback
from pathlib import Path
from peewee import JOIN
sys.path.append(str(Path(__file__).absolute().parent.parent))
from db.models import db, Users, Vaults, EntityAccount, Groups, EntityRelation, Approvers
from utils.logger import logger
from utils.redis_cli import RedisClient


class SyncDb:
    def __init__(self):
        self.redis_cli = RedisClient()
        self.is_uat_env_flag = self.is_uat_env()
        # sql 处理，添加字段account_id, otc_crm 胡顺已处理
        self.add_account_id_column_table_set = {
            'quotes', 'transactions', 'fills', 'orders', 'treasury', 'receipts', 'deposits', 'withdrawals',
            'deposituploads', 'withdrawaluploads'
        }

        # sql 处理，修改字段名称 user_id 为 trader_identifier, 取消 'trader_risk_config'
        self.rename_column_table_set = {
            'single_trade_limits', 'exposure_limits', 'tradergroupmembers', 'risk_alarm', 'risk_limits'
        }

        # 需要处理含有 trader_identifier的表, risk_limits 不改了
        self.handle_trader_identifier_table_set = {
            'quotes', 'transactions', 'fills', 'orders', 'treasury', 'deposits', 'withdrawals', 'single_trade_limits',
            'exposure_limits', 'tradergroupmembers', 'risk_alarm', 'risk', 'risk_limits'
        }

        # 需要处理 user_id的表
        self.handle_user_id_table_set = {
            'quotes', 'transactions', 'fills', 'treasury', 'receipts', 'orders'
        }

        # sql处理，添加字段 vault_id
        self.add_vault_id_column_table_set = {
            'quotes', 'transactions', 'fills', 'orders', 'treasury'
        }

        # sql处理， quotes表新增字段 add_date
        self.add_date_column_table_set = {'quotes'}

        # sql 处理删除原有的user_id, otc_crm 暂时不删除user_id字段
        self.delete_column_table_set = {
            'deposits', 'withdrawals', 'deposituploads', 'withdrawaluploads'
        }

        # 特殊的用户，特别处理
        self.special_users_list = ['williamjmoss@bostonglobal.com.au', 'bill.moss@bostonglobal.com.au',
                                   'ttp@bluewin.ch',
                                   'ttp+cryptomogroup@bluewin.ch', 'rlhale03@comcast.net', 'bhale@haleranchhunting.com',
                                   'emma@fshdglobal.org', 'maila.signar@bostonglobal.com.au']

    def peewee_exec_raw_sql(self, sql):
        """
        peewee 执行原生sql
        """
        with db.cursor() as cursor:
            cursor.execute(sql)
            time.sleep(0.001)

    def peewee_select_raw_sql(self, sql):
        """
        peewee 执行原生sql
        """
        with db.cursor() as cursor:
            cursor.execute(sql)
            rows = cursor.fetchall()
        return rows

    def db_commit(self):
        with db.cursor() as cursor:
            cursor.connection.commit()

    def db_rollback(self):
        with db.cursor() as cursor:
            cursor.connection.rollback()
            cursor.connection.commit()

    def sql_handle(self):
        """
        sql 处理字段函数
        :return:
        """
        try:
            with db.atomic():
                for each_table in self.add_account_id_column_table_set:
                    sql = f"""
                        select count (*) as num from information_schema.columns where table_name = '{each_table}' and column_name='account_id';
                    """
                    feach_row = self.peewee_select_raw_sql(sql)
                    if feach_row[0][0] == 0:
                        sql = f"""
                            ALTER TABLE "public"."{each_table}" ADD COLUMN "account_id" VARCHAR ( 50 );
                            COMMENT ON COLUMN "public"."{each_table}"."account_id" IS 'account 表唯一id(UUID4)';
                        """
                        logger.info(sql)
                        self.peewee_exec_raw_sql(sql)

                for each_table in self.rename_column_table_set:
                    sql = f"""
                       select count (*) as num from information_schema.columns where table_name = '{each_table}' and column_name='trader_identifier';
                    """
                    feach_row = self.peewee_select_raw_sql(sql)
                    if feach_row[0][0] == 0:
                        sql = f"""
                           alter table {each_table} rename column user_id to trader_identifier;
                        """
                        logger.info(sql)
                        self.peewee_exec_raw_sql(sql)

                for each_table in self.add_vault_id_column_table_set:
                    sql = f"""
                          select count (*) as num from information_schema.columns where table_name = '{each_table}' and column_name='vault_id';
                    """
                    feach_row = self.peewee_select_raw_sql(sql)
                    if feach_row[0][0] == 0:
                        sql = f"""
                            ALTER TABLE "public"."{each_table}" ADD COLUMN "vault_id" VARCHAR ( 50 );
                            COMMENT ON COLUMN "public"."{each_table}"."vault_id" IS 'vaults 表中的 vault_id';
                        """
                        logger.info(sql)
                        self.peewee_exec_raw_sql(sql)

                for each_table in self.add_date_column_table_set:
                    sql = f"""
                          select count (*) as num from information_schema.columns where table_name = '{each_table}' and column_name='add_date';
                    """
                    feach_row = self.peewee_select_raw_sql(sql)
                    if feach_row[0][0] == 0:
                        sql = f"""
                            alter table {each_table}
                            add add_date timestamp default current_timestamp;
                        """
                        logger.info(sql)
                        self.peewee_exec_raw_sql(sql)
        except Exception:
            logger.error(traceback.format_exc())
            logger.error("sql执行异常，数据进行回滚")
            raise Exception("sql执行异常，数据进行回滚")

    def delete_column_sql_handle(self):
        """
        sql 删除字段函数
        :return:
        """
        try:
            with db.atomic():
                for each_table in self.delete_column_table_set:
                    sql = f"""
                        ALTER TABLE {each_table} 
                        DROP COLUMN user_id;
                    """
                    logger.info(sql)
                    self.peewee_exec_raw_sql(sql)

                sql = """
                    ALTER TABLE quotes 
                    DROP COLUMN rfq_alias;
                """
                logger.info(sql)
                self.peewee_exec_raw_sql(sql)

        except Exception:
            logger.error(traceback.format_exc())
            logger.error("sql删除操作异常，数据进行回滚")
            raise Exception("sql删除操作异常，数据进行回滚")

    def get_user_email_account_id(self, valut_id_result):
        """
        获取 个人 email 和 account_id 的关系字典
        """
        user_result = []
        sql = f"""
            SELECT a.user_id, a.email, a.entity_id, c.account_id from users a 
            INNER JOIN entity_relation b on a.entity_id = b.entity_id 
            INNER JOIN entity_account c on b.parent_entity_id = c.entity_id
            where b.status = 'active' and a.status = 'active' 
            and c.status = 'active';
        """
        response = self.peewee_select_raw_sql(sql)
        for i in response:
            res_vault_id_list = [j['vault_id'] for j in valut_id_result if
                                 j['account_id'] == i[3]]
            res_vault_id = res_vault_id_list[0] if res_vault_id_list else ""
            user_result.append({
                "user_id": i[0],
                "email": i[1],
                "entity_id": i[2],
                "account_id": i[3],
                "vault_id": res_vault_id,
            })

        sql = """
            SELECT a.user_id, a.email, a.entity_id, b.account_id from users a 
            INNER JOIN entity_account b on a.entity_id= b.entity_id
            where a.user_type = 0 and a.status = 'active' and b.status = 'active'
            and a.entity_id not in (
            SELECT DISTINCT a.entity_id from users a 
            INNER JOIN entity_relation b on a.entity_id = b.entity_id 
            INNER JOIN entity_account c on b.parent_entity_id = c.entity_id
            where b.status = 'active' and a.status = 'active' 
            and c.status = 'active'
            ) and b.account_id not in (SELECT account_id from vaults where user_id = 'hemapriyea33@gmail.com'
            );
        """
        response = self.peewee_select_raw_sql(sql)
        for i in response:
            res_vault_id_list = [j['vault_id'] for j in valut_id_result if
                                 j['account_id'] == i[3]]
            res_vault_id = res_vault_id_list[0] if res_vault_id_list else ""
            user_result.append({
                "user_id": i[0],
                "email": i[1],
                "entity_id": i[2],
                "account_id": i[3],
                "vault_id": res_vault_id,
            })
        return user_result

    def get_special_user_email_account_id(self, valut_id_result, user_email_result):
        response = Users.select(Users.user_id, Users.email, Users.entity_id).where(Users.email.in_(self.special_users_list))
        result = []
        for i in response:
            if i.email not in ['emma@fshdglobal.org', 'maila.signar@bostonglobal.com.au']:
                res_vault_id_list = [[j['vault_id'], j['account_id']] for j in valut_id_result if
                                     j['user_id'] == i.email]

                if not res_vault_id_list:
                    logger.info(f"获取特殊用户的valut_id异常，特殊用户是: {i.email}")
                    raise Exception("获取特殊用户的valut_id异常")

                result.append({
                    "user_id": i.user_id,
                    "email": i.email,
                    "entity_id": i.entity_id,
                    "account_id": res_vault_id_list[0][1],
                    "vault_id": res_vault_id_list[0][0]
                })
        spe_user_result = [i for i in user_email_result if i['email'] in ['emma@fshdglobal.org', 'maila.signar@bostonglobal.com.au']]
        result.extend(spe_user_result)
        return result

    def get_group_email_account_id_dict(self, valut_id_result):
        """
        获取 组用户 email 和 account_id 的关系字典
        :return:
        """
        response = Groups.select(Groups.group_name, Groups.entity_id, EntityAccount.account_id).\
            join(EntityAccount, on=(Groups.entity_id == EntityAccount.entity_id))
        result = []
        for i in response:
            res_vault_id_list = [j['vault_id'] for j in valut_id_result if j['account_id'] == i.entityaccount.account_id]
            res_vault_id = res_vault_id_list[0] if res_vault_id_list else ""
            result.append({
                "group_name": i.group_name,
                "entity_id": i.entity_id,
                "account_id": i.entityaccount.account_id,
                "vault_id": res_vault_id,
            })
        return result

    def get_account_id_vault_id_dict(self):
        """
        获取到 account_id和vault_id的关系字典
        :return:
        """
        response = Vaults.select(Vaults.account_id, Vaults.vault_id, Vaults.user_id)
        result = []
        for i in response:
            result.append({
                "user_id": i.user_id,
                "account_id": i.account_id,
                "vault_id": i.vault_id,
            })
        return result

    def handle_column_manage(self, user_email_result, group_email_account_id_dict, table_set, column_name, special_user_email_result):
        """
        处理 vault_id 和 account_id 处理
        :param user_email_result:
        :param group_email_account_id_dict:
        :param table_set:
        :param column_name:
        :return:
        """
        for each_table in table_set:
            sql = f"""
                select distinct user_id from {each_table};
            """
            user_id_result = self.peewee_select_raw_sql(sql)
            for each_user_id in user_id_result:
                user_id = each_user_id[0]

                # fills user_id 允许为 '';
                if user_id == '' and each_table.lower() == 'fills':
                    continue

                if user_id == '' or user_id is None:
                    logger.error(f"{each_table}表中数据存在异常，有Null值或者空值")
                    if self.is_uat_env_flag:
                        continue
                    else:
                        raise Exception("表中数据存在异常，有Null值或者空值")

                # 查询此数据 用户属于数据组还是个人
                group_result = [i for i in group_email_account_id_dict if i['group_name'] == user_id]
                if user_id in self.special_users_list:
                    special_user_result = [i for i in special_user_email_result if i['email'] == user_id]
                    if special_user_result:
                        column_name_val = special_user_result[0][column_name]
                        if column_name_val:
                            sql = f"update {each_table} set {column_name} = '{column_name_val}' where user_id = '{user_id}';"
                            logger.info(sql)
                            self.peewee_exec_raw_sql(sql)
                        else:
                            logger.error(f"{each_table}表中{user_id} 特殊个人用户数据存在异常，没有对应的{column_name}值")
                            if self.is_uat_env_flag:
                                continue
                            else:
                                raise Exception("没有对应的特殊用户vault_id值")
                    else:
                        logger.error(f"{each_table}表中{user_id}个人用户数据存在异常，没有对应的users 数据")
                        if self.is_uat_env_flag:
                            continue
                        else:
                            raise Exception("没有对应的用户users 数据")

                elif group_result:
                    column_name_val = group_result[0][column_name]
                    if column_name_val:
                        sql = f"update {each_table} set {column_name} = '{column_name_val}' where user_id = '{user_id}';"
                        logger.info(sql)
                        self.peewee_exec_raw_sql(sql)
                    else:
                        logger.error(f"{each_table}表中{user_id} 组用户数据存在异常，没有对应的{column_name}值")
                        if self.is_uat_env_flag:
                            continue
                        else:
                            raise Exception("没有对应的组用户vault_id值")
                else:
                    user_result = [i for i in user_email_result if i['email'] == user_id]
                    if user_result:
                        column_name_val = user_result[0][column_name]
                        if column_name_val:
                            sql = f"update {each_table} set {column_name} = '{column_name_val}' where user_id = '{user_id}';"
                            logger.info(sql)
                            self.peewee_exec_raw_sql(sql)
                        else:
                            logger.error(f"{each_table}表中{user_id} 个人用户数据存在异常，没有对应的{column_name}值")
                            if self.is_uat_env_flag:
                                continue
                            else:
                                raise Exception("没有对应的用户vault_id值")
                    else:
                        logger.error(f"{each_table}表中{user_id}个人用户数据存在异常，没有对应的users 数据")
                        if self.is_uat_env_flag:
                            continue
                        else:
                            raise Exception("没有对应的用户users 数据")

    def handle_trader_identifier(self, user_email_result, group_email_account_id_dict, table_set, column_name, special_user_email_result):
        """
        处理 user_id 和 trader_identifier
        :param user_email_result:
        :param table_set:
        :param column_name:
        :return:
        """
        for each_table in table_set:
            sql = f"""
                select distinct {column_name} from {each_table};
            """
            result = self.peewee_select_raw_sql(sql)
            for each_result in result:
                column_name_result = each_result[0]
                # fills user_id 允许为 '';
                if column_name_result == '' and each_table.lower() == 'fills' and column_name == 'user_id':
                    continue

                # risk 为空，暂时不处理，直接为空
                if column_name_result == '' and each_table == 'risk':
                    continue

                if column_name == 'trader_identifier' and each_table.lower() in ('exposure_limits', 'single_trade_limits') \
                        and column_name_result == 'Viva Capital':
                    continue

                if column_name == 'trader_identifier' and each_table.lower() == 'risk_limits' and column_name_result == 'zerocap_risk@zerocap.com':
                    continue

                if column_name_result == '' or column_name_result is None:
                    logger.error(f"{each_table}表中{column_name}数据存在异常，有Null值或者空值")
                    if self.is_uat_env_flag:
                        continue
                    else:
                        raise Exception("表中数据存在异常，有Null值或者空值")

                # 根据组用户，获取组用户的entity_id，在 entity_relation 中查询组下的所有用户
                group_result = [i for i in group_email_account_id_dict if i['group_name'] == column_name_result]

                if column_name_result in self.special_users_list:
                    special_user_result = [i for i in special_user_email_result if i['email'] == column_name_result]
                    if special_user_result:
                        column_name_val = special_user_result[0]['user_id']
                        sql = f"update {each_table} set {column_name} = '{column_name_val}' where {column_name} = '{column_name_result}';"
                        logger.info(sql)
                        self.peewee_exec_raw_sql(sql)
                    else:
                        logger.error(f"{each_table}表中{column_name}数据特殊用户{column_name_result}存在异常，没有对应的{column_name}值")
                        if self.is_uat_env_flag:
                            continue
                        else:
                            raise Exception(f"没有对应的特殊用户{column_name}值")
                elif group_result and column_name == 'user_id':
                    # # 根据组用户，获取组用户的entity_id，在 entity_relation 中查询组下的所有用户
                    # group_result = [i for i in group_email_account_id_dict if i['group_name'] == column_name_result]
                    if not group_result:
                        logger.error(f"{each_table}表中{column_name}数据{column_name_result}存在异常，没有对应的{column_name}值")
                        if self.is_uat_env_flag:
                            continue
                        else:
                            raise Exception(f"没有对应的组用户{column_name}值")

                    group_entity_id = group_result[0]['entity_id']
                    group_user_entity_id = self.query_group_data_by_group_entity_id(group_entity_id)

                    # 获取直接查询 users表收据，而不是 user_email_result， user_email_result数据不全;
                    group_user_result = self.query_users_by_entity_id(group_user_entity_id)
                    if not group_user_result:
                        logger.error(f"{each_table}表中{column_name}数据{column_name_result}存在异常，没有对应的{column_name}值")
                        if self.is_uat_env_flag:
                            continue
                        else:
                            raise Exception(f"没有对应的组用户{column_name}值")

                    email_list = [i['email'] for i in group_user_result]
                    res_email = self.query_approvers_by_user_email(email_list)
                    if not res_email:
                        # 查询客户经理数据，如果存在使用客户经理数据刷新 user_id;
                        account_manager_info = self.get_account_manager_info()
                        if column_name_result in account_manager_info.keys():
                            res_email = account_manager_info[column_name_result]
                        else:
                            if self.is_uat_env_flag:
                                continue
                            else:
                                logger.error(f"email在组中没有数据, email_list: {email_list} group_entity_id: {group_entity_id}")
                                raise Exception(f"email在组中没有数据")

                    res_user_result = [i for i in group_user_result if i['email'] == res_email]
                    user_id = res_user_result[0]['user_id']
                    if user_id:
                        sql = f"update {each_table} set {column_name} = '{user_id}' where {column_name} = '{column_name_result}';"
                        logger.info(sql)
                        self.peewee_exec_raw_sql(sql)
                    else:
                        if self.is_uat_env_flag:
                            continue
                        else:
                            logger.error(f"users email {res_email} 没有对应的user_id")
                            raise Exception(f"users email没有对应的user_id")
                else:
                    user_result = [i for i in user_email_result if i['email'] == column_name_result]
                    if user_result:
                        column_name_val = user_result[0]['user_id']
                        sql = f"update {each_table} set {column_name} = '{column_name_val}' where {column_name} = '{column_name_result}';"
                        logger.info(sql)
                        self.peewee_exec_raw_sql(sql)
                    else:
                        logger.error(f"{each_table}表中{column_name}数据{column_name_result}存在异常，没有对应的{column_name}值")
                        if self.is_uat_env_flag:
                            continue
                        else:
                            raise Exception(f"没有对应的用户{column_name}值")

    def query_users_by_entity_id(self, entity_id_list):
        res = Users.select(Users.email, Users.user_id).where(Users.entity_id.in_(entity_id_list))
        result = []
        for i in res:
            result.append({
                "email": i.email,
                "user_id": i.user_id,
            })
        return result

    def query_approvers_by_user_email(self, email_list):
        res = Approvers.select(Approvers.user_id).\
            where((Approvers.user_id.in_(email_list))).\
            order_by(Approvers.status, Approvers.approve_role_id.desc()).first()
        result = None
        if res:
            result = res.user_id
        return result

    def query_group_data_by_group_entity_id(self, parent_entity_id):
        res = EntityRelation.select(EntityRelation.entity_id).where((EntityRelation.parent_entity_id == parent_entity_id) & (EntityRelation.entity_type == 'individual'))
        result = [i.entity_id for i in res if i is not None]
        return result

    def data_handle(self):
        try:
            with db.atomic():
                # 同时处理 account_id 和 valut_id
                # 目前已知 存在valut_id 一定有 account_id，循环 account_id 的集合，判断元素是否在valut_Id 中;
                # 为避免在多个表中进行无效查询，直接查询users表，确定email-entity_id - account_id(entity_account)
                valut_id_result = self.get_account_id_vault_id_dict()
                # 个人用户 email 和 accout_id 字典;
                user_email_result = self.get_user_email_account_id(valut_id_result)
                # 组用户 email 和 account_id 字典
                group_email_account_id_dict = self.get_group_email_account_id_dict(valut_id_result)
                # 特殊用户处理
                special_user_email_result = self.get_special_user_email_account_id(valut_id_result, user_email_result)
                # vault_id处理
                self.handle_column_manage(user_email_result, group_email_account_id_dict, self.add_vault_id_column_table_set, 'vault_id', special_user_email_result)

                # account_id处理
                self.handle_column_manage(user_email_result, group_email_account_id_dict, self.add_account_id_column_table_set, 'account_id', special_user_email_result)

                # trader_identifier 处理
                self.handle_trader_identifier(user_email_result, group_email_account_id_dict, self.handle_trader_identifier_table_set, 'trader_identifier', special_user_email_result)

                # user_id 处理
                self.handle_trader_identifier(user_email_result, group_email_account_id_dict, self.handle_user_id_table_set, 'user_id', special_user_email_result)

                # redis处理
                self.redis_handle(user_email_result)
        except Exception:
            logger.error(traceback.format_exc())
            logger.error("数据处理异常，数据进行回滚")
            raise Exception("数据处理异常，数据进行回滚")

    def get_account_manager_info(self):
        return {
            'bill.moss@bostonglobal.com.au': 'williamjmoss@bostonglobal.com.au',
            'williamjmoss@bostonglobal.com.au': 'bill.moss@bostonglobal.com.au',
            'bhale@haleranchhunting.com': 'rlhale03@comcast.net',
            'rlhale03@comcast.net': 'bhale@haleranchhunting.com'
        }

    def redis_handle(self, user_email_result):
        """
        a. 通过新 users 表，定位 trader_identifier 和 emial 的关系；
        b. 复制一份 redis 中和交易员相关的 key，如 ems_positions_joys，复制出一份 ems_positions_123，并给予老 redis 过期时间48小时；
        :return:
        """
        all_keys = self.redis_cli.redis_client.keys("ems_positions_*")
        logger.info(f'所有的交易用户为 {all_keys}')
        for key in all_keys:
            # 字节类型需要编译为str
            if isinstance(key, bytes):
                key = key.decode()

            # 获取到json的值
            internal_pos = self.redis_cli.json_get(key)
            trader_identifier = key.replace("ems_positions_", "")
            user_result = [i for i in user_email_result if i['email'] == trader_identifier]
            if user_result:
                user_id = user_result[0]['user_id']
                # 设置老的redis key有效时间为48小时
                self.redis_cli.redis_client.expire(key, 48 * 3600)
                new_key = f"ems_positions_{user_id}"
                logger.info(f'new_key: {new_key}, internal_pos: {internal_pos}')
                self.redis_cli.json_set(new_key, internal_pos)
            else:
                logger.error(f"user表中没有redis对应的users数据.trader_identifier:{trader_identifier}, key:{key}")

        # 删除所有和wintermute相关的key数据
        all_keys = self.redis_cli.redis_client.keys("*wintermute*")
        for key in all_keys:
            # 字节类型需要编译为str
            if isinstance(key, bytes):
                key = key.decode()
            self.redis_cli.redis_client.delete(key)

    def data_handle_before(self):
        try:
            with db.atomic():
                # 处理 user_id 为 Beat Haefliger 的数据
                table_list = ['quotes', 'transactions', 'fills', 'receipts']
                for table in table_list:
                    sql = f"""
                        update {table} set user_id = '55beat4jan@protonmail.com' where user_id = 'Beat Haefliger';
                    """
                    logger.info(sql)
                    self.peewee_exec_raw_sql(sql)

                    sql = f"""
                        delete from {table} where user_id in (
                            'user1@foo.com',
                            'gkrishnaa@gmail.com',
                            'test@test.com',
                            'testtest@test.com',
                            'leo+test@zerocap.com',
                            'test_20220721_1@test.com'
                        );
                    """
                    logger.info(sql)
                    self.peewee_exec_raw_sql(sql)

                # 处理 交易员为 maomao@zerocap.com 的数据
                table_list = ['fills', 'risk']
                for table in table_list:
                    sql = f"""
                        update {table} set trader_identifier = 'maomao+auth0test@zerocap.io' where trader_identifier = 'maomao@zerocap.com';
                    """
                    logger.info(sql)
                    self.peewee_exec_raw_sql(sql)

                sql = """
                    delete from risk where trader_identifier = '0';
                """
                logger.info(sql)
                self.peewee_exec_raw_sql(sql)

                sql = """
                    delete from fills where trader_identifier = 'Zerocap Prime';
                """
                logger.info(sql)
                self.peewee_exec_raw_sql(sql)

                sql = """
                    update deposits a
                    set trader_identifier = b.trader_identifier
                    from transactions b 
                    where a.txn_alias = b.txn_alias and a.trader_identifier is null or a.trader_identifier = '';
                """
                logger.info(sql)
                self.peewee_exec_raw_sql(sql)

                sql = """
                    update withdrawals a
                    set trader_identifier = b.trader_identifier
                    from transactions b 
                    where a.txn_alias = b.txn_alias and a.trader_identifier is null or a.trader_identifier = '';
                """
                logger.info(sql)
                self.peewee_exec_raw_sql(sql)

                sql = """
                    DELETE from risk where trader_identifier = 'Zerocap Prime';
                """
                logger.info(sql)
                self.peewee_exec_raw_sql(sql)

                sql = """
                    DELETE from risk_limits where trader_identifier = 'shuainan.zhang@eigen.capital';
                """
                logger.info(sql)
                self.peewee_exec_raw_sql(sql)

                sql = """
                    DELETE from treasury where status = 'deleted';
                """
                logger.info(sql)
                self.peewee_exec_raw_sql(sql)

        except Exception:
            logger.error(traceback.format_exc())
            logger.error("数据处理异常，数据进行回滚")
            raise Exception("数据处理异常，数据进行回滚")

    def main(self):
        try:
            logger.info("数据处理脚本开始")
            logger.info("开始字段处理")
            # 字段修改为一个事务控制
            self.sql_handle()

            logger.info("开始异常数据处理")
            # 数据处理前，处理部分异常数据
            self.data_handle_before()

            # 数据处理
            logger.info("开始数据处理")
            self.data_handle()

            # 冗余字段删除
            self.delete_column_sql_handle()
            logger.info("数据处理脚本结束")

        except Exception as e:
            logger.error("脚本处理异常，请重新运行!")
            logger.error(f"异常报错处理，{e}")
            # slack 消息发送

    def is_uat_env(self):
        """
        判断是否是uat数据库
        :return:
        """
        return 'uat' in os.environ['FIREBLOCKS_DB_NAME']


if __name__ == '__main__':
    sync_db = SyncDb()
    sync_db.main()
    # sql = f"""
    #     select count (*) as num from information_schema.columns where table_name = 'quotes' and column_name='account_id'
    # """
    # rows = sync_db.peewee_select_raw_sql(sql)
    # print(rows)

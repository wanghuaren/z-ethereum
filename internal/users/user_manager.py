"""
user manager相关的业务逻辑
"""
import time
import sys
import pathlib

from internal.users.data_helper import update_risk_limits, get_user_info_by_user, get_trader_list, \
    get_risk_limits_by_user
from utils.zc_exception import ZCException

sys.path.append(str(pathlib.Path(__file__).parent.parent.parent))

from utils.calc import Calc
from config.config import config
from utils.consts import ResponseStatusSuccessful, CompanyEmail

TraderManagerEmail = config.get('TRADE_MANAGER_EMAIL')
CompanyManagerEmail = config.get('COMPANY_MANAGER_EMAIL')


def inster_or_update_risk_limit(request):

    # 交易员trader_identifier是否存在
    trader_identifier = request.trader_identifier
    if not trader_identifier:
        raise ZCException("The parameter user_id cannot be empty")
    
    # trader_identifier是公司、或者交易员的，其对应的role不同
    if trader_identifier == CompanyEmail:
        role = "firm"
        manager_email = ','.join(CompanyManagerEmail)
        user_info = True
    else:
        role = "trader"
        manager_email = TraderManagerEmail[0]
        user_info = get_user_info_by_user(trader_identifier)
    if not user_info:
        raise ZCException("user_id does not exist")
    # 记录pnl报警间隔参数限制,必须大于零，传入单位/小时
    if Calc(request.alert_interval).value <= 0:
        raise ZCException("alert_interval must be greater than zero")
    
    alert_interval = request.alert_interval   

    # 记录止损限额参数
    try:
        stop_loss_limit = request.stop_loss_limit
        Calc(stop_loss_limit)
        if 'e' in stop_loss_limit or 'E' in stop_loss_limit:
            raise ZCException("stop_loss_limit cannot be a scientific count")
    except Exception:
        raise ZCException("stop_loss_limit must be a number")

    note = request.note
    trader_risk = {
        "trader_identifier": trader_identifier,
        "role": role,
        "alert_interval": alert_interval,
        "stop_loss_limit": stop_loss_limit,
        "manager_email": manager_email,
        "status": "normal",
        "note": note,
        "created_at": int(time.mktime(time.localtime(time.time())))
    }
    # 更新或者插入trader_risk
    update_risk_limits(trader_risk)
    return dict(status=ResponseStatusSuccessful)


def trader_list(request):
    firm = {}
    # 获取公司级别的止损限额与报警间隔
    risk_limit = get_risk_limits_by_user(CompanyEmail)
    if risk_limit:
        firm = {
            'stop_loss_limit': risk_limit.stop_loss_limit,
            'alert_interval': risk_limit.alert_interval
        }

    # 获取交易员级别的止损限额与报警间隔
    trader_list = get_trader_list()
    return dict(status=ResponseStatusSuccessful, trader_list=trader_list, firm=firm)


if __name__ == '__main__':
    from utils.dict_utils import ObjDict

    request = ObjDict({
        "trader_identifier": "joys.karen@foxmail.com",
        "alert_interval": "30",
        "stop_loss_limit": "-2000",
        # "manager_email ": "william@zerocap.com",
        # "status": "normal",
        "note": "test_123"
    })
    print(request, "///")
    start = time.time()
    print(inster_or_update_risk_limit(request))
    # import json
    # print(json.dumps(trader_list(request)))
    print(time.time() - start)

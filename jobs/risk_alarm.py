import copy
from datetime import datetime, timezone
from decimal import Decimal
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).absolute().parent.parent))

from utils.calc import Calc
from config.config import config
from db.base_models import redis_cli
from internal.risk.data_helper import get_user, save_risk_alarm, get_risk_limits_alarm
from internal.users.data_helper import update_risk_limits
from utils.consts import CompanyEmail
from utils.email_service import EmailService
from utils.slack_utils import send_slack
from utils.logger import logger
from jobs.save_risk_to_redis import get_pnl

TraderManagerEmail = config.get('TRADE_MANAGER_EMAIL')
CompanyManagerEmail = config.get('COMPANY_MANAGER_EMAIL')


def send_slack_and_email(risk_limits_copy, user_email, user_id, pnl_data_dic, manager_email={}, html_manage_content=''):
    email_service = EmailService()
    html_content = """
        <div style="width: 970px;margin: 0 auto;">
            <div style="text-align: center;border-bottom: 1px solid;padding-bottom: 15px;">
                <img src="https://img.defi.wiki/logo/zerocap-secondary-logo-rgb.png" alt="" style="width: 235px;height: 40px;">
            </div>
            <div style="padding: 24px;">
                <p>Dear %s</p>
                <p style="line-height: 25px;margin-top: 20px">
                    %s
                </p>
                <table style="width:100%%;border-collapse:separate; border-spacing:0 20px;margin-top: 15px;">
                    <tr>
                        <td>Loss Amount</td>
                        <td>Daily Stop Loss Limit</td>
                        <td>Trader/Firm</td>
                        <td>Date</td>
                    </tr>
                    <tr>
                        <td>%s</td>
                        <td>%s</td>
                        <td>Name:%s,Email:%s</td>
                        <td>%s</td>
                    </tr>
                    %s
                </table>
                <p style="margin-top: 35px;">This Email is automatically sent by the EMS system, please do not reply.</p>
            </div>
        </div>
        """
    html_body = """
                    <tr>
                        <td>%s</td>
                        <td>%s</td>
                        <td>Name:%s,Email:%s</td>
                        <td>%s</td>
                    </tr>"""
    utc_now = int(datetime.now(timezone.utc).timestamp())

    alert_interval = risk_limits_copy[user_id][0]
    stop_loss_limit = risk_limits_copy[user_id][1]
    recent_time = risk_limits_copy[user_id][2]
    email_name = risk_limits_copy[user_id][3]

    # 获取最近报警的时间
    set_alarm = int(recent_time) + int(alert_interval) * 3600

    # 当前用户的 pnl 超过 risk_limts 表中的pnl时，在Risk_Alarm表新增一条报警信息
    slack_name = "trader"
    if user_id == CompanyEmail:
        slack_name = 'company'
        email_name = 'Zerocap'
    # pnl = str(Calc(pnl_data_dic[user_id]))
    pnl = pnl_data_dic.get(user_id, None)

    if not pnl:
        return None, None

    if Decimal(str(pnl)) < Decimal(stop_loss_limit.replace(',', '')) and set_alarm < utc_now:
        # 写入报警信息
        save_risk_alarm({
            "trader_identifier": user_id,
            "pnl": pnl,
            "status": "normal",
            "note": "",
            "created_at": utc_now,
            "update_at": utc_now
        })
        # 公司级别 发送 slack 消息
        if user_email == CompanyEmail:
            send_slack(channel='SLACK_RISK_NOTIFICATIONS',
                       subject=f"{slack_name} risk alarm",
                       content=f"Loss Amount：{str(pnl, 'UTF-8')}"+"\n"
                               f"Daily Stop Loss Limit：{stop_loss_limit}"+"\n"
                               f"Trader/Firm：Name:{email_name},Email:{user_email}"+"\n"
                               f"Date：{str(datetime.now(timezone.utc)).split('.')[0]}")

        # 给交易员发送邮件
        if user_email != CompanyEmail:
            trader_email_text = "Your current PNL exceeds the daily stop loss limit  in EMS, please check if there are any trade capture error and report risk management strategy to your manager as soon as possible. As follows:"
            # 给交易员本人发送邮件
            trader_email_data = {
                'subject': 'risk alarm',
                'html_content': html_content % (email_name, trader_email_text, str(pnl, 'UTF-8'), stop_loss_limit, email_name, user_email,
                                                str(datetime.utcnow()).split(".")[0], html_manage_content)
            }
            email_service.send_eamil_no_template(user_email, trader_email_data)

            # 交易员的slack消息
            slack_content = f"Loss Amount：{str(pnl, 'UTF-8')}"+"\n"\
                            f"Daily Stop Loss Limit：{stop_loss_limit}"+"\n"\
                            f"Trader/Firm：Name:{email_name},Email:{user_email}"+"\n"\
                            f"Date：{str(datetime.now(timezone.utc)).split('.')[0]}"
            return html_body % (str(pnl, 'UTF-8'), stop_loss_limit, email_name, user_email, str(datetime.utcnow()).split(".")[0]), slack_content

        # 给公司管理或者基金经理发送邮件
        company_email_text = "Now there are some traders or companies whose PNL exceeds the daily stop loss limit  in EMS, please check if there are any trade capture error and report risk management strategy to your manager as soon as possible. As follows:"
        for email in manager_email:
            email_data = {
                'subject': 'risk alarm',
                'html_content': html_content % (manager_email[email], company_email_text, str(pnl, 'UTF-8'), stop_loss_limit, 'Zerocap', user_email,
                                                str(datetime.utcnow()).split(".")[0], html_manage_content)
            }
            email_service.send_eamil_no_template(email, email_data)
    return None, None


def reset_default_values(risk_limits, user_id):

    # 根据user_id,选择新增数据
    current_time = int(datetime.now(timezone.utc).timestamp())
    data = {"trader_identifier": '',
            "role": "trader",
            "alert_interval": '1',
            "stop_loss_limit": '-100000',
            "manager_email": TraderManagerEmail[0],
            "status": "normal",
            "note": '',
            "created_at": current_time}
    data_firm = {"trader_identifier": '',
                 "role": "firm",
                 "alert_interval": '1',
                 "stop_loss_limit": '-2000000',
                 "manager_email": ','.join(CompanyManagerEmail),
                 "status": "normal",
                 "note": '',
                 "created_at": current_time}
    if user_id == CompanyEmail:
        data = data_firm

    # 用户的限制值不是数字，重新设置下默认值
    try:
        stop_loss_limit = risk_limits[user_id][1]
        Calc(stop_loss_limit)
        if 'e' in stop_loss_limit or 'E' in stop_loss_limit:
            raise
    except Exception:
        data["trader_identifier"] = user_id
        data["alert_interval"] = risk_limits[user_id][0]
        update_risk_limits(data)
        result = [data['alert_interval'], data['stop_loss_limit'], risk_limits[user_id][2],  risk_limits[user_id][3]]
        return result
    return risk_limits[user_id]


def run_risk_alarm_to_pg():
    html_head = """
        <div style="width: 970px;margin: 0 auto;">
            <div style="text-align: center;border-bottom: 1px solid;padding-bottom: 15px;">
                <img src="https://img.defi.wiki/logo/zerocap-secondary-logo-rgb.png" alt="" style="width: 235px;height: 40px;">
            </div>
            <div style="padding: 24px;">
                <p>Dear %s</p>
                <p style="line-height: 25px;margin-top: 20px">
                    Now there are some traders or companies whose PNL exceeds the daily stop loss limit  in EMS, please check if there are any trade capture error and report risk management strategy to your manager as soon as possible. As follows:
                </p>
                <table style="width:100%%;border-collapse:separate; border-spacing:0 20px;margin-top: 15px;">
                    <tr>
                        <td>Loss Amount</td>
                        <td>Daily Stop Loss Limit</td>
                        <td>Trader/Firm</td>
                        <td>Date</td>
                    </tr>"""
    html_tail = """
                </table>
                <p style="margin-top: 35px;">This Email is automatically sent by the EMS system, please do not reply.</p>
            </div>
        </div>
        """
    html_body = ''
    slack_content = ''

    users = get_user()
    if not users:
        logger.info("no user data")
        return
    
    risk_limits = get_risk_limits_alarm()
    risk_limits_copy = copy.deepcopy(risk_limits)
    pnl_data_dic = get_pnl()
    for user in users.objects():
        # 先判断Risk_Limits表是否有数据，无数据，新增一条默认数据
        if user.user_id not in risk_limits:
            update_risk_limits({
                "trader_identifier": user.user_id,
                "role": "trader",
                "alert_interval": '1',
                "stop_loss_limit": '-100000',
                "manager_email": TraderManagerEmail[0],
                "status": "normal",
                "note": '',
                "created_at": int(datetime.now(timezone.utc).timestamp())})
            risk_limits_copy[user.user_id] = ['1', '-100000', '0', f"{user.first_name} {user.last_name}"]

        # 用户的限制值不是数字，重新设置下默认值
        risk_limits_copy[user.user_id] = reset_default_values(risk_limits_copy, user.user_id)
        # 给pnl超限的每个交易员发邮件
        email_text, slack_text = send_slack_and_email(risk_limits_copy, user.email, user.user_id, pnl_data_dic)
        if email_text:
            html_body = html_body + email_text
            slack_content = slack_content + slack_text + "\n\n"

    # 给交易员的经理，发送一个汇总的邮件
    if html_body:
        html_content = html_head + html_body + html_tail
        email_data = {
                'subject': 'risk alarm',
                'html_content': html_content % TraderManagerEmail[1]
            }
        email_service = EmailService()
        email_service.send_eamil_no_template(TraderManagerEmail[0], email_data)

        # 发送 slack 消息
        send_slack(channel='SLACK_RISK_NOTIFICATIONS',
                   subject=f"trader risk alarm",
                   content=slack_content.rstrip('\n'))

    # 公司的限制值不是数字，重新设置下默认值
    risk_limits_copy[CompanyEmail] = reset_default_values(risk_limits, CompanyEmail)

    # 公司总pnl的报警
    send_slack_and_email(risk_limits_copy, CompanyEmail, CompanyEmail, CompanyManagerEmail, html_body)


if __name__ == '__main__':
    run_risk_alarm_to_pg()

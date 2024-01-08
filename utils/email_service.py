import base64
import os
import sys

sys.path.append('../')
import time
import traceback
import json

from datetime import datetime
from sendgrid import SendGridAPIClient, Personalization
from sendgrid.helpers.mail import Email
from sendgrid.helpers.mail import Mail
from sendgrid.helpers.mail import Attachment
from config.config import config, config_all
from utils.slack_utils import send_slack
from utils.log_utils import LogDecorator
from utils.logger import logger
from db.models import EmailLog


class EmailService(object):
    """
    send email through sendgrid service
    """

    def __init__(self):
        self.sg = SendGridAPIClient(api_key=config['SG_API_KEY'])
        self.from_email = Email(
            email="portal@zerocap.com", name="Zerocap")
        self.cooldown = dict()

    def email_guard(self, to_emails, template, tx_id=None):
        now_timestamp = time.time()
        if not tx_id:
            tx_id = template
        # concat tuple key
        if isinstance(to_emails, list):
            passed_emails = []
            for email_address in to_emails:
                timestamp = self.cooldown.get((email_address, template, tx_id))
                if timestamp:
                    if int(now_timestamp) - int(timestamp) >= config['EMAIL_GUARD_TIME']:
                        self.cooldown[(email_address, template, tx_id)] = now_timestamp
                        passed_emails.append(email_address)
                else:
                    self.cooldown[(email_address, template, tx_id)] = now_timestamp
                    passed_emails.append(email_address)
            return passed_emails
        else:
            timestamp = self.cooldown.get((to_emails, template, tx_id))
            if timestamp:
                if int(now_timestamp) - int(timestamp) < config['EMAIL_GUARD_TIME']:
                    return None

            self.cooldown[(to_emails, template, tx_id)] = now_timestamp
            return to_emails

    @LogDecorator()
    def send_email(self, to_emails, data, template, email_log, tx_id=None, tenant=None):
        send_success = True
        now_date = datetime.now()
        template_id = config_all[tenant]['SG_TEMPLATE_MAPPING'][template]['id'] if tenant else config['SG_TEMPLATE_MAPPING'][template]['id']
        to_emails = self.email_guard(to_emails, template, tx_id)
        data['date'] = now_date.strftime("%B %d, %Y").replace(" 0", " ")
        try:
            if to_emails:
                message = Mail(
                    from_email=self.from_email
                )
                if isinstance(to_emails, list):
                    for to_email in to_emails:
                        personalization = Personalization()
                        personalization.add_to(Email(to_email))
                        personalization.dynamic_template_data = data
                        message.add_personalization(personalization)
                else:
                    personalization = Personalization()
                    personalization.add_to(Email(to_emails))
                    personalization.dynamic_template_data = data
                    message.add_personalization(personalization)

                
                message.dynamic_template_data = data
                message.template_id = template_id
                response = self.sg.send(message)
                code, body, headers = response.status_code, response.body, response.headers
                if code != 202:
                    print(code, body, headers)
                    send_slack(
                        channel='SLACK_API_OPS',
                        subject=f"Email failed - code {code}",
                        content="\n".join("{!r}: {!r},".format(k, v) for k, v in \
                                        {'emails': to_emails,
                                        'data': data,
                                        'template': template,
                                        'code': code,
                                        'body': body}.items())
                    )
        except Exception as e:
            traceback.print_tb(e.__traceback__, limit=20)
            send_success = False

        if send_success and email_log and to_emails:
            if isinstance(data, dict):
                if "date" in data:
                    del data["date"]
                content = json.dumps(data)
            else:
                content = ""

            email_log.update({
                "result": "success" if send_success else "fail",
                "status": "active",
                "send_date": now_date.strftime("%Y-%m-%d %H:%M:%S"),
                "email_tempalte_name": template,
                "email_tempalte_id": template_id,
                "receiving_email": ",".join(to_emails),
                "content": content,
                "attachment_name": "",
                "cc_email": "",
            })
            logger.info(f"record email usage logs: {email_log}")
            EmailLog.create(**email_log)


    @LogDecorator()
    def send_eamil_no_template(self, to_emails, data):
        try:
            message = Mail(
                from_email=self.from_email,
                subject=data['subject'],
                html_content=data['html_content'],
            )
            if isinstance(to_emails, list):
                for to_email in to_emails:
                    personalization = Personalization()
                    personalization.add_to(Email(to_email))
                    personalization.dynamic_template_data = data
                    message.add_personalization(personalization)
            else:
                personalization = Personalization()
                personalization.add_to(Email(to_emails))
                personalization.dynamic_template_data = data
                message.add_personalization(personalization)

            response = self.sg.send(message)
            code, body, headers = response.status_code, response.body, response.headers
            if code != 202:
                print(code, body, headers)
                send_slack(
                    channel='SLACK_API_OPS',
                    subject=f"Send risk alarm email failed",
                    content="\n".join("{!r}: {!r},".format(k, v) for k, v in \
                                      {'emails': to_emails,
                                       'code': code,
                                       'body': body}.items())
                )
        except Exception as e:
            traceback.print_tb(e.__traceback__, limit=20)


# portfolio_request send email
def send_portfolio_request(email_service, to_emails):
    email_service.send_email(
        to_emails=to_emails,
        data={
            'Operate': 'Deposit',
            'operate': 'deposit',
            'amountInfo': "1.1 BTC",
            'destination': "mu17sudG7iWMmReFGiphJNDCp5ikYpD4CP",
            'requestTimestamp': datetime.utcnow().strftime("%d %B, %Y %H:%M:%S") + " (UTC)"},
        template='portfolio_request')


# portfolio_approved send email
def send_portfolio_approved(email_service, to_emails):
    email_service.send_email(
        to_emails=to_emails,
        data={
            'Operate': 'Withdrawal',
            'operate': 'withdrawal',
            'status': 'Completed',
            'amountInfo': "$75,123",
            'destination': "Bank detail888.",
            'requestTimestamp': datetime.utcnow().strftime("%d %B, %Y %H:%M:%S") + " (UTC)"},
        template='portfolio_approved')


# portfolio_rejection send email
def send_portfolio_rejection(email_service, to_emails):
    email_service.send_email(
        to_emails=to_emails,
        data={
            'Operate': 'Deposit',
            'operate': 'deposit',
            'status': 'Rejected',
            'amountInfo': "2.1BTC",
            'destination': "mu17sudG7iWMmReFGiphJNDCp5ikYpD4CP",
            'requestTimestamp': datetime.utcnow().strftime("%d %B, %Y %H:%M:%S") + " (UTC)"},
        template='portfolio_rejection')


if __name__ == '__main__':
    email_service = EmailService()
    # email_service.send_email(
    #     to_emails='omarwesterberg@gmail.com',
    #     data={
    #         'amountInfo': "amount",
    #         'destination': "address",
    #         'confirmUrl': config['URL'] + "withdrawal/{token}",
    #         'rejectUrl': config['URL'] + "withdrawal/{token}/reject",
    #         'requestTimestamp': datetime.utcnow().strftime("%d %B, %Y %H:%M:%S") + " (UTC)"},
    #     template='withdrawal_confirmation')

    # email_service.send_eamil_no_template(
    #     to_emails=['shuainan.zhang@eigen.capital', 'minfu.xiao@eigen.capital', '15294627382@163.com'],
    #     data={
    #         'subject': 'structured product expiration notification',
    #         'html_content': "<p>Please note that the following structured products will expire on April 28, 2022<p>:<p2>Yield Entry Notes-22Mar2022-12May2022<p2><p2>Yield Exit Notes-22Mar2022-12May2022<p2>"
    #     })


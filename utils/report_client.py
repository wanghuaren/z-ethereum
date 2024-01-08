import os
from datetime import datetime, timedelta

import requests


class ReportClient:

    def __init__(self, is_need_success=True):
        self.expire_second = timedelta(hours=6)
        self.token = ""
        self.user = os.environ['MONITOR_USER']
        self.password = os.environ['MONITOR_PASSWORD']
        self.expire_time = datetime.now()
        self.host = os.environ['MONITOR_REPORT_HOST']
        self.endpoint = f"{self.host}/v1"
        self.is_need_report = os.environ.get('IS_NEED_REPORT', "") == "true"
        self.headers = {
            'Content-Type': 'application/json',
            'Authorization': ""
        }
        self.is_need_success = is_need_success

    def login(self):
        res = requests.post(
            url=f"{self.endpoint}/auth/login",
            json={'user': self.user, 'password': self.password}
        ).json().get('result').get('access_token')
        return res

    def get_token(self):
        if not self.token or datetime.now() > self.expire_time:
            self.token = self.login()
            self.expire_time = datetime.now() + self.expire_second
        return self.token

    def post(self, path, data):
        self.headers["Authorization"] = f"Bearer {self.get_token()}"
        response = requests.post(
            url=f"{self.endpoint}{path}", json=data, headers=self.headers)
        if response.status_code != 200:
            raise Exception(response.text)
        return response

    def get(self, path):
        self.headers["Authorization"] = f"Bearer {self.get_token()}"
        response = requests.get(
            url=f"{self.endpoint}{path}", headers=self.headers)
        if response.status_code != 200:
            raise Exception(response.text)
        return response

    def report_for_monitor(self, name, status, info, channel):
        """
        channel 0为 表示service服务
        1为 标识为api接口
        2为 标识task脚本
        3为 标识为test用例
        """
        if not self.is_need_report or (status == 0 and not self.is_need_success):
            return
        data = {os.environ.get('FIREBLOCKS_ENV', 'development'): [{
            'name': name,
            'status': status,
            'info': info,
        }]}
        self.post(f'/report/record/{channel}', data)

    def report_for_test_monitor(self, data):
        """
        data = {
            "prod-api": [
                {"name": "name1", "status": "passed/failed/error", "info": f"开始时间\n 结束时间\n错误信息error"},
                {"name": "name2", "status": "passed/failed/error", "info": f"开始时间\n 结束时间\n错误信息error"}
                ....
            ],
            "prod-ui": [
                {"name": "name1", "status": "passed/failed/error", "info": f"开始时间\n 结束时间\n错误信息error"},
                {"name": "name2", "status": "passed/failed/error", "info": f"开始时间\n 结束时间\n错误信息error"}
                ....
            ],
            ....
        }
        """
        self.post('/report/record/3', data)


report_client = ReportClient()

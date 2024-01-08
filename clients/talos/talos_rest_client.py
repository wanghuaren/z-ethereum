import json
import aiohttp
import traceback
import requests
from requests.adapters import HTTPAdapter

from clients.talos.talos_base_client import TalosBaseClient
from utils.logger import logger

# 配置重连次数
req = requests.Session()
req.mount('http://', HTTPAdapter(max_retries=5))
req.mount('https://', HTTPAdapter(max_retries=5))


class TalosRestClient(TalosBaseClient):
    """
    talos rest client
    """

    def __init__(self, entity, trader_identifier=''):
        super().__init__(entity=entity, trader_identifier=trader_identifier)
        self.is_request_ok = 200
        self.endpoint = f"https://{self.host}"

    def get(self, path, query=None, is_json_response=True):
        try:
            url = f"https://{self.host}{path}"
            if query:
                url += f'?{query}'
            headers = self.build_headers(path, query)
            response = req.get(url=url, headers=headers)
            if response.status_code != self.is_request_ok:
                logger.error(response.text)
                # raise Exception(response.text)
                return response
            return response.json() if is_json_response else response.text
        except Exception as e:
            logger.exception(traceback.format_exc())
            raise Exception(e) from e

    def post(self, path, query=None, body=None, utc_datetime=None, is_json_response=True):
        try:
            url = self.endpoint + path
            if query:
                url += f'?{query}'
            body = body or {}
            # build_headers必须传入json格式
            headers = self.build_headers(path, query, json.dumps(body) if body else "{}", method='POST',
                                         utc_datetime=utc_datetime)
            # body传入参数为字典格式
            response = req.post(url=url, headers=headers, json=body)
            if response.status_code != self.is_request_ok:
                logger.error(response.text)
                # raise Exception(response.text)
                return response
            return response.json() if is_json_response else response.text
        except Exception as e:
            logger.exception(traceback.format_exc())
            raise Exception(e) from e
    
    def patch(self, path, query=None, body=None, utc_datetime=None, is_json_response=True):
        try:
            url = self.endpoint + path
            if query:
                url += f'?{query}'
            body = body or {}
            headers = self.build_headers(path, query, json.dumps(body) if body else "{}", method='PATCH',
                                         utc_datetime=utc_datetime)
            response = requests.patch(url=url, headers=headers, json=body)
            if response.status_code != self.is_request_ok:
                print(response.text, response.status_code, "////")
                logger.error(response.text)
                raise Exception(response.text)
            return response.json() if is_json_response else response.text
        except Exception as e:
            logger.exception(traceback.format_exc())
            raise Exception(e) from e

    def delete(self, path, query=None, is_json_response=True):
        try:
            url = self.endpoint + path
            if query:
                url += f'?{query}'
            headers = self.build_headers(path, query, method='DELETE')
            response = req.delete(url=url, headers=headers)
            if response.status_code != self.is_request_ok:
                logger.error(response.text)
                raise Exception(response.text)
            return response.json() if is_json_response else response.text
        except Exception as e:
            logger.exception(traceback.format_exc())
            raise Exception(traceback.format_exc()) from e

    async def async_post(self, path, query=None, body=None, utc_datetime=None, is_json_response=True):
        try:
            url = f"https://{self.host}{path}"
            if query:
                url += f'?{query}'
            body = body or {}
            # build_headers必须传入json格式
            headers = self.build_headers(path, query, json.dumps(body) if body else "{}", method='POST',
                                         utc_datetime=utc_datetime)

            async with aiohttp.request(method='POST', url=url, headers=headers, json=body) as response:
                if response.status != self.is_request_ok:
                    logger.error(response.text())
                    # raise Exception(response.text)
                    return response
                rep_data = json.loads(await response.text())
                return rep_data
        except Exception as e:
            logger.exception(traceback.format_exc())
            raise Exception(e) from e

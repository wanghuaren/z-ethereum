import json

import aiohttp
from fireblocks_sdk import FireblocksSDK, FireblocksApiException
from requests import Session


class FireblocksSDKFix(FireblocksSDK):

    def __init__(self, private_key, api_key):
        FireblocksSDK.__init__(self, private_key=private_key, api_key=api_key)
        self.session = Session()

    def _get_request(self, path):
        token = self.token_provider.sign_jwt(path)
        headers = {
            "X-API-Key": self.api_key,
            "Authorization": f"Bearer {token}"
        }

        response = self.session.get(self.base_url + path, headers=headers)
        if response.status_code >= 300:
            # print(response)
            raise FireblocksApiException("Got an error from fireblocks server: " + response.text)
        else:
            return response.json()

    def _delete_request(self, path):
        token = self.token_provider.sign_jwt(path)
        headers = {
            "X-API-Key": self.api_key,
            "Authorization": f"Bearer {token}"
        }

        response = self.session.delete(self.base_url + path, headers=headers)
        if response.status_code >= 300:
            raise FireblocksApiException("Got an error from fireblocks server: " + response.text)
        else:
            return response.json()

    def _post_request(self, path, body={}, idempotency_key=None):
        token = self.token_provider.sign_jwt(path, body)
        headers = {
            "X-API-Key": self.api_key,
            "Authorization": f"Bearer {token}"
        }
        response = self.session.post(self.base_url + path, headers=headers, json=body)
        if response.status_code >= 300:
            raise FireblocksApiException("Got an error from fireblocks server: " + response.text)
        else:
            return response.json()

    def _put_request(self, path, body={}):
        token = self.token_provider.sign_jwt(path, body)
        headers = {
            "X-API-Key": self.api_key,
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }

        response = self.session.put(self.base_url + path, headers=headers, data=json.dumps(body))
        if response.status_code >= 300:
            raise FireblocksApiException("Got an error from fireblocks server: " + response.text)
        else:
            return response.json()

    async def _get_request_aysnc(self, path):
        token = self.token_provider.sign_jwt(path)
        headers = {
            "X-API-Key": self.api_key,
            "Authorization": f"Bearer {token}"
        }

        async with aiohttp.request(method='GET', url=self.base_url + path, headers=headers) as response:
            if response.status >= 300:
                raise FireblocksApiException("Got an error from fireblocks server: " + await response.text())
            else:
                result = await response.json()
                return result

    async def _post_request_async(self, path, body={}, idempotency_key=None):
        token = self.token_provider.sign_jwt(path, body)
        headers = {
            "X-API-Key": self.api_key,
            "Authorization": f"Bearer {token}"
        }

        async with aiohttp.request(method='POST', url=self.base_url + path, headers=headers, json=body) as response:
            if response.status >= 300:
                raise FireblocksApiException("Got an error from fireblocks server: " + await response.text())
            else:
                result = await response.json()
                return result

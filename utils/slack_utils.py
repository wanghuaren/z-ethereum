import requests

from config.config import config
from utils.logger import logger


def send_slack(channel=None, subject=None, content=None, icon_url=None, username=None):
    try:
        subject = subject or ''
        content = content or ''
        icon_url = icon_url or ''
        username = username or ''
        channel = config.get('CONFIG_SLACK').get(channel) or config.get('CONFIG_SLACK').get('SLACK_API_OPS')
        url = 'https://hooks.slack.com/services' + channel
        text = '```{}\n\n{}```'.format(
            subject, content) if subject else content
        params = {"text": text}
        if icon_url:
            params['icon_url'] = icon_url
            params['as_user'] = False
        if username:
            params['username'] = username
        response = requests.post(url, json=params, timeout=5)
        return response
    except Exception as e:
        logger.error(e)

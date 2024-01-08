import json
import time
from traceback import format_exc
import requests
from lxml import etree

import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))
from utils.logger import logger
from utils.slack_utils import send_slack
from db_api.gckdata_api import query_gckdata_by_id_list
from db_api.fb_support_asset_api import get_fb_supported_asset_by_id
from db_api.asset_api import check_assets, insert_assets, query_asset_id_by_id
from db_api.symbols_api import insert_symbols, query_symbols_by_base_usd, update_symbols
from db.base_models import db


class Coingecko:
    def __init__(self, support_asset_num=200):
        self.coingecko_url = "https://www.coingecko.com/?page="
        self.api_host = "https://api.coingecko.com/api/v3/"
        self.support_asset_num = support_asset_num
        self.page = support_asset_num // 100 + 1
        self.api_headers = {
            "accept": "application/json"
        }
        self.headers = {
            "content-type": "application/json",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36",
        }
        self.logger = logger

    def run(self):
        """
        脚本入口主方法
        :return:
        """
        try:
            self.logger.info("脚本开始运行")

            # 获取排名前两百的币种信息数据
            self.logger.info("获取币种列表")
            coin_list = self.get_coin_list()
            print("coin_list", coin_list)
            if len(coin_list) < self.support_asset_num:
                self.logger.error("抓取币种数低于要求的币种数，抓取不完整，请检查数据是否爬取完整!")
                self.logger.error(f"币种列表为{coin_list}")
                raise Exception("抓取币种数低于要求的币种数，抓取不完整，请检查数据是否爬取完整!")

            # 调用coin_dict接口，获取coin字典信息，把币种列表数据更换为id数据
            # 查询不到key，直接使用name进行后续处理
            self.logger.info("获取coin_dict")
            coin_dict = self.get_coin_dict()
            coin_id_list = list(map(lambda x: coin_dict.get(x, None), coin_list))
            if None in coin_id_list:
                self.logger.error("部分数据不匹配，存在对应不到的数字币的id数据，请手动处理")
                self.logger.error(f"币种列表为{coin_id_list}")
                raise Exception("部分数据不匹配，存在对应不到的数字币的id数据，请手动处理")

            # 查询gckdata，将数据补充完整，做一个字典列表
            self.logger.info("查询gckdata，补充数据")
            result = query_gckdata_by_id_list(coin_id_list)
            if len(result) > len(coin_id_list):
                self.logger.error("gckdata数据存在重复，请检查币种数据")
                self.logger.error(f"币种列表为{coin_id_list}")
                raise Exception("数据存在重复，请检查币种数据")
            elif len(result) < len(coin_id_list):
                self.logger.error("gckdata数据无法与id完全匹配，请检查数据")
                self.logger.error(f"币种列表为{coin_id_list}")
                raise Exception("gckdata数据无法与id完全匹配，请检查币种数据")

            # 查询assets和symbols，做有则更新，无则插入的操作
            self.logger.info("数据处理")
            # 此处做事务控制
            with db.atomic():
                for each_data in result:
                    self.insert_new_altcoin(each_data)

            self.logger.info("脚本结束")

        except:
            self.logger.error(format_exc())
            self.logger.error("脚本运行异常")
            # 脚本报错预警
            send_slack(channel='SLACK_API_OPS',
                       subject="Coingecko scrapy failed",
                       content='traceback.format_exc():\n%s' % format_exc())

    def get_coin_list(self):
        """
        获取coingecko排名前两百币种信息
        :return:
        """
        coin_list = []
        for each_page in range(1, self.page + 1):
            coingecko_page_url = self.coingecko_url + str(each_page)
            response = requests.get(coingecko_page_url, headers=self.headers)
            if response.status_code == 200:
                text = response.text
                each_coin_list = self.parse_html_text(text)
                if each_coin_list:
                    coin_list += each_coin_list
                time.sleep(0.5)
            else:
                self.logger.info("页面数据响应异常，未获取到正常页面，请检查!")
                break

        coin_list = coin_list[:self.support_asset_num]
        return coin_list

    def get_coin_dict(self):
        """
        获取coin字典关系，id, name, url 页面为name, zerocap数据为id, 做下处理
        :return:
        """
        coin_dict = {}
        coin_list_host = self.api_host + "coins/list"
        response = requests.get(coin_list_host)
        coin_dict_list = json.loads(response.text)
        for each_coin in coin_dict_list:
            coin_dict[each_coin['name']] = each_coin['id']
        return coin_dict

    def get_markets(self):
        """
        api接口服务器获取币种的markets市场
        :return:
        """
        markets_url = self.api_host + 'coins/markets'
        parameters = {
            'vs_currency': 'usd',
            'ids': 'BTC'
        }
        response = requests.get(markets_url, params=parameters, timeout=5)
        print(response)

    def ping_service_test(self):
        """
        检查测试服务器状态
        :return:
        """
        ping_url = self.api_host + 'ping'
        response = requests.get(ping_url)
        print(response)

    def parse_html_text(self, html_text):
        """
        爬取页面解析，获取币种数据
        :param html_text:
        :return:
        """
        self.logger.info("页面币种数据解析")
        html_etree = etree.HTML(html_text)
        element_text_list = html_etree.xpath(
            "//span[@class='lg:tw-flex font-bold tw-items-center tw-justify-between']//text()")
        coin_list = list(map(lambda x: x.strip().replace('\n', ''), element_text_list))
        return coin_list

    def insert_new_altcoin(self, new_altcoin):
        """
        数据处理添加assets和symbols
        :param new_altcoin:
        :return:
        """
        try:
            fb_supported_asset_id = get_fb_supported_asset_by_id(new_altcoin['id'])
            # asset_id = new_altcoin["ticker"]
            asset_id = fb_supported_asset_id if fb_supported_asset_id else new_altcoin["ticker"]
            # 只有fb支持的币种且在assets表中，可以跳过插入操作，其他的都不行
            # gckdata [id， symbol ] or [symbol in ticker]
            if not fb_supported_asset_id or not check_assets(fb_supported_asset_id.upper()):
                # 检查币种是否在assets表中，无则插入, 有则不处理
                result = query_asset_id_by_id(asset_id.upper())
                if not result:
                    # business_type = 'altcoin' if fb_supported_asset_id else 'off-fb'
                    business_type = 'symbols'
                    ticker = new_altcoin.get("ticker")
                    insert_assets(asset_id, new_altcoin, business_type, ticker)
            else:
                asset_id = fb_supported_asset_id.upper()
        except:
            self.logger.error(f"asset表数据插入失败，  币种是 {new_altcoin['id']}")
            self.logger.error(f"具体报错信息为{format_exc()}")
            raise Exception("asset表数据插入失败")

        try:
            # 检查币种是否在symbols表中，无则插入, 有则查看 platform 是否存在ems, 有则不处理，无则更新
            result = query_symbols_by_base_usd(asset_id.upper())
            if asset_id.upper() in ["BNB_BSC"]:
                return
            if not result:
                insert_symbols(asset_id, new_altcoin)
            elif result and 'ems' not in result['platform']:
                platform = "ems," + result['platform']
                source = ','.join(result['source'])
                if 'gck' in result['source'].lower():
                    source = "{" + source +"}"
                else:
                    source = "{gck," + source + "}"

                symbols_dic = {
                    'platform': platform,
                    'id': result['id'],
                    'source': source
                }
                update_symbols(symbols_dic)

        except Exception:
            self.logger.error(f"symbols表数据插入或更新失败,u 币种是 {asset_id}")
            self.logger.error(f"具体报错信息为{format_exc()}")
            raise Exception("symbols表数据插入或更新失败")


if __name__ == '__main__':
    coingecko = Coingecko()
    coingecko.run()
    # coingecko.get_coin_dict()

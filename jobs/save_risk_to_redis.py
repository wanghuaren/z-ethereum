import time
import json
import traceback
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))
from datetime import datetime, timezone, timedelta

from db.base_models import redis_cli
from internal.risk.data_helper import get_risk_pos, get_user
from utils.logger import logger
from utils.slack_utils import send_slack
from utils.calc import Calc


def get_pnl(source="redis"):
    utc_now = datetime.now(timezone.utc)
    # 澳洲下午四点就是utc时间上午6点
    if utc_now.hour > 6:
        start_str = utc_now.strftime("%Y-%m-%d 6:00:00")
    else:
        last_day_utc = utc_now + timedelta(days=-1)
        start_str = last_day_utc.strftime("%Y-%m-%d 6:00:00")

    time_array = time.strptime(start_str, "%Y-%m-%d %H:%M:%S")
    start_timestamp = int(time.mktime(time_array) * 1000)
    end_timestamp = int(utc_now.timestamp() * 1000)
    if source == "alarm":   # risk alarm 截止时间向前推 5分钟，防治业务录入了 txns，但是还没有来的及录入 fills;
        end_timestamp = end_timestamp - 60 * 5 * 1000

    *_, pnl_df = get_risk_pos(start_timestamp, end_timestamp)
    if pnl_df is None:
        logger.info("no pnl data")
        pnl_data_dic = {}
    else:
        pnl_data_dic = json.loads(pnl_df.to_json())
        logger.info(f"pnl data: {pnl_data_dic}")
    
    return pnl_data_dic


def run_save_risk_to_redis():
    try:
        utc_now = datetime.now(timezone.utc)
        pnl_data_dic = get_pnl()
        for trader_identifier in pnl_data_dic:
            # 每五分钟执行一次 在0，5，10，15...分钟时执行 如果是澳洲下午四点则同时更新昨天的记录
            # 澳洲下午四点将pnl写入yesterday,同时将today置为空
            pnl = str(Calc(pnl_data_dic[trader_identifier]))
            if utc_now.hour == 6 and utc_now.minute == 0:
                redis_cli.set(f"pnl_{trader_identifier}_yesterday", pnl, 24 * 3600)
                redis_cli.set(f"pnl_{trader_identifier}_today", "", 24 * 3600)
            else:
                redis_cli.set(f"pnl_{trader_identifier}_today", pnl, 24 * 3600)

        # 没有 pnl 的，但是 redis 中却有 today 记录的，需要删除 today 的 key
        all_trader = get_user()
        have_pnl_trader = pnl_data_dic.keys()
        for trader in all_trader:
            if trader.user_id in have_pnl_trader:
                continue
            redis_cli.delete(f"pnl_{trader.user_id}_today")

    except Exception:
        logger.exception(traceback.format_exc())
        send_slack(channel='SLACK_API_OPS',
                   subject="save_risk_to_redis failed",
                   content='traceback.format_exc():\n%s' % traceback.format_exc())
        raise Exception(traceback.format_exc())


if __name__ == "__main__":
    run_save_risk_to_redis()


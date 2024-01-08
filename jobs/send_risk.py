import traceback
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))
from internal.risk.data_helper import get_close_pnl_by_dates
from datetime import datetime, timezone, timedelta

from utils.calc import Calc
from utils.logger import logger
from utils.slack_utils import send_slack


def calcute_diff_pnls(pnl_dic):
    pnl_diff_list = []
    for day_delta in [1, 7, 30]:
        pnl_day_delta = pnl_dic[f"day_delta_{day_delta}"]["pnl"]
        pnl_diff_str = f"{Calc.get_thousandth_num(Calc.get_num_by_prec(str(Calc(pnl_dic['day_delta_0']['pnl']) - Calc(pnl_day_delta)), 2))} USD"\
            if pnl_day_delta else ""
        pnl_diff_list.append(pnl_diff_str)
    return pnl_diff_list


def run_send_risk():
    try:
        utc_now = datetime.now(timezone.utc)
        utc_today_6 = datetime(utc_now.year, utc_now.month, utc_now.day, 6, tzinfo=timezone.utc)
        pnl_dic = {f"day_delta_{day}": {"time": (utc_today_6 + timedelta(days=-1 * day)).strftime("%Y-%m-%d %H")} for day
                   in [0, 1, 7, 30]}
        dates = [pnl_dic[i]["time"] for i in pnl_dic]
        # 获取 今天 昨天 三天前 七天前 三十天前的pnl数据
        pnls = get_close_pnl_by_dates(dates)
        if not pnls or not [pnl["pnl"] for pnl in pnls if pnl["last_updated"] == pnl_dic["day_delta_0"]["time"]]:
            logger.info("send risk: no pnl data")
            return

        for key in pnl_dic:
            pnl_exposure_value_usd = [{"pnl": pnl["pnl"], "exposure_value_usd":pnl["exposure_value_usd"]} for pnl in pnls if pnl["last_updated"] == pnl_dic[key]["time"]]
            pnl_dic[key]["pnl"] = pnl_exposure_value_usd[0]["pnl"] if pnl_exposure_value_usd else None
            pnl_dic[key]["exposure_value_usd"] = pnl_exposure_value_usd[0]["exposure_value_usd"] if pnl_exposure_value_usd else None

        pnl_diff_list = calcute_diff_pnls(pnl_dic)
        content = f"net equity: {Calc.get_thousandth_num(Calc.get_num_by_prec(pnl_dic['day_delta_0']['exposure_value_usd'], 2))} USD\n\
                 1 day: {pnl_diff_list[0]}\n\
                 7 day: {pnl_diff_list[1]}\n\
                30 day: {pnl_diff_list[2]}"

        send_slack(channel="SLACK_RISK_NOTIFICATIONS",
                   subject="Zerocap PNL Summary:",
                   content=content.replace("            ", ""))
    except Exception:
        logger.exception(traceback.format_exc())
        send_slack(channel='SLACK_API_OPS',
                   subject="send_risk failed",
                   content='traceback.format_exc():\n%s' % traceback.format_exc())
        raise Exception(traceback.format_exc())


if __name__ == "__main__":
    run_send_risk()

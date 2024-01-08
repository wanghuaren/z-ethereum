import traceback
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).absolute().parent.parent))

from internal.risk.data_helper import get_risk_pos, save_risk, get_oldest_txn_time, check_txn_time_interval
from datetime import datetime, timezone, timedelta
from db.base_models import db
from utils.logger import logger
from utils.slack_utils import send_slack


def run_save_risk_to_pg():
    try:
        with db.atomic():
            utc_now = datetime.now(timezone.utc)
            now_timestamp = int(utc_now.timestamp() * 1000)

            # 澳洲下午四点就是utc时间上午6点
            # 如果是澳洲下午四点后 risk表中的date取当天
            if utc_now.hour > 6:
                risk_date = utc_now.strftime("%Y-%m-%d")
            # 如果是澳洲下午四点前 risk表中的date取昨天
            else:
                last_day_utc = utc_now + timedelta(days=-1)
                risk_date = last_day_utc.strftime("%Y-%m-%d")

            start_timestamp = get_oldest_txn_time()
            end_timestamp = now_timestamp
            trader_df, sum_df, pnl_df = get_risk_pos(start_timestamp, end_timestamp, entity='zerocap')

            if trader_df is None:
                logger.info("no risk data")
                return

            risk_dic_lst = []
            for trader_identifier in trader_df["trader_identifier"]:
                if trader_identifier in [risk["trader_identifier"] for risk in risk_dic_lst]:
                    continue

                single_trader_df = trader_df[trader_df.trader_identifier == trader_identifier]

                # 交易员单个币种的数据
                risk_dic_lst.extend([{"created_at": utc_now,
                                      "last_updated": now_timestamp,
                                      "trader_identifier": trader_identifier,
                                      "asset_id": asset_row["asset_id"],
                                      "exposure_quantity": str(asset_row["exposure_quantity"]),
                                      "exposure_value_usd": str(asset_row["exposure_quantity_usd"]),
                                      "trading_volume": str(asset_row["trading_volume"]),
                                      "trading_volume_usd": str(asset_row["trading_volume_usd"]),
                                      "pnl": "",
                                      "risk_type": "trader",
                                      "entity": "zerocap",
                                      "date": risk_date
                                      } for _, asset_row in
                                     single_trader_df.iterrows()])

                # 交易员汇总数据
                risk_dic_lst.append({
                    "created_at": utc_now,
                    "last_updated": now_timestamp,
                    "trader_identifier": trader_identifier,
                    "asset_id": "",
                    "exposure_quantity": "",
                    "exposure_value_usd": str(single_trader_df["exposure_quantity_usd"].sum()),
                    "trading_volume": "",
                    "trading_volume_usd": str(single_trader_df["trading_volume_usd"].sum()),
                    "pnl": pnl_df[trader_identifier],
                    "risk_type": "total_trader",
                    "entity": "zerocap",
                    "date": risk_date
                })

            # 公司数据
            risk_dic_lst.extend([{"created_at": utc_now,
                                  "last_updated": now_timestamp,
                                  "trader_identifier": "",
                                  "asset_id": sum_df_index,
                                  "exposure_quantity": str(sum_df_row["exposure_quantity"]),
                                  "exposure_value_usd": str(sum_df_row["exposure_quantity_usd"]),
                                  "trading_volume": str(sum_df_row["trading_volume"]),
                                  "trading_volume_usd": str(sum_df_row["trading_volume_usd"]),
                                  "pnl": "",
                                  "risk_type": "company",
                                  "entity": "zerocap",
                                  "date": risk_date
                                  } for sum_df_index, sum_df_row in
                                 sum_df.iterrows()])

            # 公司汇总数据
            risk_dic_lst.append({"created_at": utc_now,
                                 "last_updated": now_timestamp,
                                 "trader_identifier": "",
                                 "asset_id": "",
                                 "exposure_quantity": "",
                                 "exposure_value_usd": str(sum_df["exposure_quantity_usd"].sum()),
                                 "trading_volume": "",
                                 "trading_volume_usd": str(sum_df["trading_volume_usd"].sum()),
                                 "pnl": pnl_df["total"],
                                 "risk_type": "total_company",
                                 "entity": "zerocap",
                                 "date": risk_date
                                 })
            save_risk(risk_dic_lst)

    except Exception:
        logger.exception(traceback.format_exc())
        send_slack(channel='SLACK_API_OPS',
                   subject="save_risk_to_pg failed",
                   content='traceback.format_exc():\n%s' % traceback.format_exc())
        raise Exception(traceback.format_exc())


if __name__ == "__main__":
    run_save_risk_to_pg()

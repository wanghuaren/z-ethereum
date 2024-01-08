import traceback
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))
from internal.risk.data_helper import get_risk_pos, save_risk, get_oldest_txn_time
from datetime import datetime, timezone, timedelta
from db.base_models import db
from utils.logger import logger


def run_create_risk_data():
    try:
        with db.atomic():
            # 开始时间都为transactions表里最早的时间
            start_timestamp = get_oldest_txn_time()
            start_datetime = datetime.utcfromtimestamp(start_timestamp/1000)
            utc_now = datetime.now(timezone.utc)
            # 如果当前已经过了utc6点则第一个结束时间为第二天utc6点开始， 否则从当天utc6点开始
            first_end_date = (start_datetime+timedelta(days=1)).date() if start_datetime.hour >= 6 else start_datetime.date()
            end_date = utc_now.date() + timedelta(days=1)
            days_diff = (end_date-first_end_date).days

            for day in range(days_diff):
                end_date = first_end_date + timedelta(days=day)
                # 当天utc 5:59:59 用来作为取数据的结束时间
                end_utc_befor_6 = datetime(end_date.year, end_date.month, end_date.day, 5, 59, 59, tzinfo=timezone.utc)
                # 当天utc 6:00:00 用来作为risk表里的last_updated字段
                end_utc_6 = datetime(end_date.year, end_date.month, end_date.day, 6, tzinfo=timezone.utc)
                end_timestamp = int(end_utc_befor_6.timestamp()*1000)
                last_updated = int(end_utc_6.timestamp()*1000)
                risk_date = (end_utc_6 + timedelta(days=-1)).strftime("%Y-%m-%d")
                trader_df, sum_df, pnl_df = get_risk_pos(start_timestamp, end_timestamp, entity='zerocap', cal_date=end_utc_6.date())

                if trader_df is None:
                    logger.info(f"{risk_date} no risk data")
                    continue

                risk_dic_lst = []
                for trader_identifier in trader_df["trader_identifier"]:
                    if trader_identifier in [risk["trader_identifier"] for risk in risk_dic_lst]:
                        continue

                    single_trader_df = trader_df[trader_df.trader_identifier == trader_identifier]

                    # 交易员单个币种的数据
                    risk_dic_lst.extend([{"created_at": end_utc_6,
                                          "last_updated": last_updated,
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
                                          } for asset_index, asset_row in
                                         single_trader_df.iterrows()])

                    # 交易员汇总数据
                    risk_dic_lst.append({
                        "created_at": end_utc_6,
                        "last_updated": last_updated,
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
                risk_dic_lst.extend([{"created_at": end_utc_6,
                                      "last_updated": last_updated,
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
                risk_dic_lst.append({"created_at": end_utc_6,
                                     "last_updated": last_updated,
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

                # 插入的数据按照trader_identifier,asset_id,risk_type,entity,date去重
                risk_list = []
                insert_data = []
                for risk_data in risk_dic_lst:
                    if (risk_data['trader_identifier'], risk_data['asset_id'], risk_data['risk_type'], risk_data['entity'], risk_data['date']) not in risk_list:
                        insert_data.append(risk_data)
                        risk_list.append((risk_data['trader_identifier'], risk_data['asset_id'], risk_data['risk_type'],
                            risk_data['entity'], risk_data['date']))
                save_risk(insert_data)

    except Exception:
        logger.exception(traceback.format_exc())
        raise Exception(traceback.format_exc())


if __name__ == "__main__":
    run_create_risk_data()

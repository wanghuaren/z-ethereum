from peewee import DateTimeField, CharField, BigIntegerField
from peewee import DateField
from peewee import DoubleField
from peewee import Model
from peewee import TextField
from datetime import datetime
from config.config import config
from utils.base_db import RetryPostgresqlDatabase

db = RetryPostgresqlDatabase.get_db_instance(
    database=config['CONFIG_POSTGRES'].get('HQ_DATABASE', 'zerocap_hq'),
    host=config['CONFIG_POSTGRES'].get('HOST', 'zerocap-uat.ciua0qip669w.ap-southeast-1.rds.amazonaws.com'),
    port=config['CONFIG_POSTGRES'].get('PORT', '5432'),
    user=config['CONFIG_POSTGRES'].get('USER', 'zerocap_uat'),
    password=config['CONFIG_POSTGRES'].get('PASSWORD', 'np3qYpUNvTx4A110UN21c3u'),
    autorollback=True
)

class NoAddDateModel(Model):
    class Meta:
        database = db


class BaseModel(Model):
    add_date = DateTimeField(
        default=datetime.utcnow(),
        verbose_name="record_time")

    class Meta:
        database = db


class UsdtAud1m(NoAddDateModel):
    class Meta:
        database = db
        table_name = 'usdtaud_1m'

    id = BigIntegerField(verbose_name='id')
    symbols = CharField(max_length=50, verbose_name='symbols', help_text='交易对')
    open_price = CharField(max_length=50, verbose_name='open_price', help_text='开盘价')
    close_price = CharField(max_length=50, verbose_name='close_price', help_text='收盘价')
    high_price = CharField(max_length=50, verbose_name='high_price', help_text='最高价')
    low_price = CharField(max_length=50, verbose_name='low_price', help_text='最低价')
    vol = CharField(max_length=50, verbose_name='vol', help_text='成交量')
    time = BigIntegerField(verbose_name='time', help_text='写入的时间戳, 每分钟一次')
    created_date = DateField(verbose_name='created_date', help_text='创建日期')
    created_at = BigIntegerField(verbose_name='created_at')


def init_table():
    db.create_tables([UsdtAud1m])


if __name__ == "__main__":
    init_table()

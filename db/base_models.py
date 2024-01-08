from datetime import datetime
from traitlets import Any
from enum import Enum

from peewee import Model, CharField, DateTimeField

from utils.redis_cli import RedisClient
from utils.retry_db import retry_db

db = retry_db
redis_cli = RedisClient()

class BaseModelNoAddDate(Model):
    class Meta:
        database = db


class BaseModel(BaseModelNoAddDate):
    add_date = DateTimeField(
        default=datetime.utcnow(),
        verbose_name="record_time")


class CustomizeEnum(Enum):

    def __init__(self, *args):
        super().__init__()

    @classmethod
    def get_const_value(cls, value):
        """
            获取枚举常量值，如 OrderStatusEnum.Open 的值为 Open
        """
        for key, val in cls.__members__.items():
            if val.value == value:
                return key
        return None

    @classmethod
    def get_const_obj(cls, value):
        """
            获取枚举对象，如 OrderStatusEnum.Open
        """
        for _, val in cls.__members__.items():
            if val.value == value:
                return val
        return None


class EnumField(CharField):
    """
    This class enable an Enum like field for Peewee
    """

    def __init__(self, enum: type[CustomizeEnum], *args: Any, **kwargs: Any) -> None:
        super().__init__(*args, **kwargs)
        self.enum = enum

    def db_value(self, value: Any) -> Any:
        return value.value

    def python_value(self, value: Any) -> Any:
        return self.enum(value)

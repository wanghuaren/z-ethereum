from datetime import datetime
import time
from functools import wraps

from utils.logger import logger


def timestamp_to_time(timestamp_input):
    if len(str(timestamp_input)) > 11:
        timestamp_input = timestamp_input / 1000
    time_array = time.localtime(timestamp_input)
    return time.strftime("%Y-%m-%d %H:%M:%S", time_array)


def timestamp_to_date_time(timestamp_input):
    if len(str(timestamp_input)) > 11:
        timestamp_input = timestamp_input / 1000
    time_array = time.localtime(timestamp_input)
    return time.strftime("%Y-%m-%d", time_array)


def iso8601(timestamp=None):
    try:
        if timestamp.isdigit():
            timestamp = int(timestamp)
    except:
        pass
    if isinstance(timestamp, str):
        if len(timestamp) == 15:
            timestamp = int(timestamp.split('.')[0])
        else:
            return timestamp
    if timestamp is None or not isinstance(timestamp, int) or int(timestamp) < 0:
        return None
    try:
        utc = datetime.utcfromtimestamp(timestamp // 1000)
        return utc.strftime('%Y-%m-%d %H:%M:%S%f')[:-6]
    except (TypeError, OverflowError, OSError):
        return None


def get_utc_datetime():
    return datetime.utcnow()


def get_time_consuming(f):
    
    def inner(*arg,**kwarg):
        s_time = time.time()
        res = f(*arg,**kwarg)
        e_time = time.time()
        print('耗时：{}秒'.format(e_time - s_time))
        return res
    return inner


def timer(func):
    @wraps(func)
    def wrap(*args, **kwargs):
        begin_time = time.perf_counter()
        result = func(*args, **kwargs)
        end_time = time.perf_counter()
        logger.info({
            "type": "timer",
            "func": func.__name__,
            "args": [args, kwargs],
            "cost_time": "%2.4f sec" % (end_time - begin_time)
        })
        return result

    return wrap


def get_current_timestamp_str(timestamp=None):
    return iso8601(timestamp if timestamp else get_current_timestamp())


def get_template_time_format_from_timestamp(stamp=0):
    if not stamp:
        stamp = time.time()
    time_date = datetime.fromtimestamp(int(stamp))
    return time_date.strftime("%B %d, %Y %H:%M:%S").replace(" 0", " ")


def get_current_timestamp():
    return int(time.time() * 1000)


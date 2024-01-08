import functools
import logging
import threading
from config.config import config
from utils.path_utils import PathConst
from utils.logger import logger


class LoggerManager(object):
    _instance = None
    _instance_lock = threading.Lock()

    def __new__(cls, *args, **kwargs):
        with LoggerManager._instance_lock:
            if cls._instance is None:
                cls._instance = super().__new__(cls, *args, **kwargs)

        return cls._instance

    def __init__(self):
        if 'logger' not in self.__dict__:
            log_formatter = logging.Formatter(
                '%(asctime)s - %(name)s - %(levelname)s - %(message)s')

            # file handler
            file_name = f"{str(PathConst.LOG_DIR.joinpath('otc.log'))}"
            file_handler = logging.handlers.RotatingFileHandler(
                file_name, mode='a', maxBytes=20 * 1024 * 1024,
                encoding='utf8', delay=0)
            file_handler.setFormatter(log_formatter)

            # stream handler
            stream_handler = logging.StreamHandler()
            stream_handler.setFormatter(log_formatter)

            logger_to_set = logging.getLogger()
            if config.get('CONFIG_SYSTEM').get('DEBUG'):
                logger_to_set.setLevel(logging.DEBUG)
            else:
                logger_to_set.setLevel(logging.INFO)
            logger_to_set.addHandler(file_handler)
            logger_to_set.addHandler(stream_handler)
            self.logger = logger_to_set

    def get_logger(self):
        return self.logger


class LogDecorator(object):
    def __init__(self):
        self.logger = logger

    def __call__(self, fn):
        @functools.wraps(fn)
        def decorated(*args, **kwargs):
            try:
                self.logger.info(f"{fn.__name__}.input: {args} {kwargs}")
                result = fn(*args, **kwargs)
                self.logger.info(f"{fn.__name__}.output: {result}")
                return result
            except Exception as ex:
                self.logger.exception(f"{fn.__name__}.Exception: {str(ex)}")
                raise ex

        return decorated

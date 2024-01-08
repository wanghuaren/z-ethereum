import time
import json
import redis
import traceback
from rejson import Client, Path
from config.config import config


class RedisClient:
    def __init__(self, db=config['CONFIG_REDIS']['DB'], host=config['CONFIG_REDIS']['HOST'], port=config['CONFIG_REDIS']['PORT']):
        # startup_nodes = [{ "host": config['CONFIG_REDIS']['host'], "port": str(config['CONFIG_REDIS']['port']) }]
        pool = redis.ConnectionPool(
            host=host,
            port=port,
            db=db)
        self.redis_client = redis.Redis(connection_pool=pool)
        self.rejson_client = Client(host=host, port=port, db=db, decode_responses=True)

    def set(self, key, value, ex=None):
        self.redis_client.set(key, value)
        if ex:
            self.redis_client.expire(key, ex)

    def set_1min(self, key, value):
        if isinstance(value, dict):
            value['redistime'] = time.time()
        self.set(key, value, ex=60 * 10)

    def get(self, key):
        try:
            return self.redis_client.get(key)
        except:
            return None
        
    def delete(self, key):
        self.redis_client.delete(key)
    
    def jsonmget(self, path: str, keys: list):
        """
        path 值在 json 中的路径
        keys 是要匹配的 key 列表
        """
        try:
            return self.rejson_client.jsonmget(path, *keys)
        except:
            traceback.print_exc()
            return None

    def exists(self, key):
        result = self.redis_client.get(key)
        if result:
            return True
        else:
            return False

    def lrange(self, name, start=0, end=-1):
        byte_res = self.redis_client.lrange(name, start, end)
        result = [json.loads(i) for i in byte_res]
        return result

    def lgetmax(self, name, hkey=None):
        key = self.redis_client.llen(name)
        # print(key)
        if (key > 0):
            for i in range(key - 1, -1, -1):
                item = json.loads(self.redis_client.lindex(name, i))
                if (hkey is None):
                    return item
                if (item[0] <= hkey):
                    return item
            return None
        else:
            return None

    def json_get(self, key):
        try:
            return self.rejson_client.jsonget(key)
        except:
            return None

    def json_set(self, key, value, ex=None):
        self.rejson_client.jsonset(key, Path.rootPath(), value)
        if ex:
            self.rejson_client.expire(key, ex)

    def scan_get_keys(self, pattern, count, key_lst, offset=0):
        result = self.redis_client.scan(offset, pattern, count)
        key_lst.extend(result[1])
        if result[0] != 0:
            self.scan_get_keys(pattern, count, key_lst, result[0])
        return key_lst

    def get_keys(self, pattern, count):
        return self.scan_get_keys(pattern, count, [])

    def publish_messages(self, channel, messages):
        return self.redis_client.publish(channel, messages)

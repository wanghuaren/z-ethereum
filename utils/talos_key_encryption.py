# 非对称加密
import base64
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_OAEP
from Crypto import Random

from config.config import config

public_key = config['TALOS_TRADE_KEYS'][0]['public_key']
private_key = config['TALOS_TRADE_KEYS'][0]['private_key']


class TalosKeyEncryption(object):

    def __init__(self):
        """
        初始化,获取public_key、private_key的值
        """
        if public_key and private_key:
            self.public_key = public_key.replace(r"\n", "\n")
            self.private_key = private_key.replace(r"\n", "\n")
        else:
            self.generate_key()

    def generate_key(self):
        """
        重新生成私钥与公钥,然后进行备份
        :return:
        """
        rsa = RSA.generate(2048, Random.new().read)
        private_pem = rsa.exportKey()
        public_pem = rsa.publickey().exportKey()
        self.public_key = public_pem.decode()
        self.private_key = private_pem.decode()
        json_key = {
            "public_key": self.public_key,
            "private_key": self.private_key
        }
        return json_key

    # 公钥加密
    def rsa_encode(self, message):
        """
        使用公钥对输入参数进行加密
        :param public_key:
        :return:
        """
        rsakey = RSA.importKey(self.public_key)  # 导入读取到的公钥
        cipher = PKCS1_OAEP.new(rsakey)  # 生成对象
        # 通过生成的对象加密message明文，注意，在python3中加密的数据必须是bytes类型的数据，不能是str类型的数据
        cipher_text = base64.b64encode(
            cipher.encrypt(message.encode(encoding="utf-8")))
        # 公钥每次加密的结果不一样跟对数据的padding（填充）有关
        return cipher_text.decode()

    # 私钥解密
    def rsa_decode(self, cipher_text):
        """
        使用私钥对输入参数进行加密
        :param cipher_text:
        :return:
        """
        rsakey = RSA.importKey(self.private_key)  # 导入读取到的私钥
        cipher = PKCS1_OAEP.new(rsakey)  # 生成对象
        # 将密文解密成明文，返回的是一个bytes类型数据，需要自己转换成str
        text = cipher.decrypt(base64.b64decode(cipher_text))
        return text.decode()


if __name__ == '__main__':
    talos = TalosKeyEncryption()
    talos.generate_key()
    print(talos.private_key)
    print(talos.public_key)

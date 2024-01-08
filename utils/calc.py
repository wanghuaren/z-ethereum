from ast import Return
import decimal
from decimal import Decimal
from functools import wraps

from utils.logger import logger

context = decimal.getcontext()
context.prec = 36
context.rounding = decimal.ROUND_HALF_UP
decimal.setcontext(context)


class CalcDecorator(object):

    def __init__(self):
        pass

    def __call__(self,func):
        @wraps(func)
        def decorated(*args, **kwargs):
            try:
                (obj, obj2) = ('', '')
                if(len(args) == 1):
                    (obj, ) = args
                if(len(args) == 2):
                    (obj, obj2) = args
                #print(type(obj), type(obj2))
                prec = context.prec
                rounding = context.rounding
                if(func.__name__ != '__truediv__'):
                    place = obj.numeric_places(obj2, func.__name__)
                    context.prec  = place

                if(func.__name__ == 'numeric'):
                    if(obj2 is False):
                        context.rounding = decimal.ROUND_DOWN
                #print(func.__name__, context.prec)
                result = func(*args, **kwargs)
                context.prec = prec
                context.rounding = rounding

                return result
            except Exception as e:
                logger.exception(str(e))

        return decorated


class Calc():

    calc_place = None
    def __init__(self, value, place = None):
        self.value = Decimal(str(value).replace(",", ""))
        self.calc_place = place
        pass

    def evalue(self, value):
        e_value = str(value).lower()
        if('e-' in e_value):
            v1 = e_value
            item = int(v1[v1.find('e-')+2 : len(v1)]) + int(len(v1[0:v1.find('e-')-(len(v1.split('.')[0]) if '.' in v1 else 0)-1]))
            e_value = f"%.{item}f"%(float(v1))

        if('e+' in e_value):
            v1 = e_value
            item = int(v1[v1.find('e+')+2 : len(v1)]) + (len(v1.split('.')[0]) if ('.' in v1) else 1)
            e_value = f"%{item}f"%(float(v1))
        return e_value

    def places(self, value):

        if type(value) == int:
            return [len(str(value)), 0]

        e_value = self.evalue(value)

        if('.' not in str(e_value)):
            return [len(str(e_value)), 0]

        values = str(e_value).split('.')
        slen = len(str(values[0]))
        ilen = len(values[1])
        if(ilen <=8):
            return [slen, ilen]

        lvalue = values[1][0:(ilen-1)]

        if(lvalue.endswith('00000') and (ilen+slen) > 15):
            ilen = len(lvalue.rstrip('0'))
            ilen = ilen if(ilen)>0 else 1
            return [slen, ilen]

        if(lvalue.endswith('99999') and (ilen+slen) > 15):
            ilen = len(lvalue.rstrip('9'))
            ilen = ilen if(ilen)>0 else 1
            return [slen,  ilen]

        return [slen,  ilen]

    def numeric_places(self, value, fname = None):
        if(isinstance(value, Calc)):
            if(self.calc_place is not None) or (value.calc_place is not None):
                return self.calc_place if(value.calc_place is None) else (value.calc_place if(self.calc_place is None) else max(self.calc_place, value.calc_place))
            if(fname == '__mul__'):
                return sum(self.places(self.value))+sum(self.places(value.value))
            else:
                return max(self.places(self.value)[0],  self.places(value.value)[0]) + max(self.places(self.value)[1],  self.places(value.value)[1])
        else:
            if(self.calc_place is not None):
                return self.calc_place

            if(fname == '__mul__'):
                return sum(self.places(self.value))+sum(self.places(value))
            else:
                return max(self.places(self.value)[0],  self.places(value)[0]) + max(self.places(self.value)[1],  self.places(value)[1])

    @CalcDecorator()
    def __str__(self):
        return self.evalue(self.value)  #f"%.{self.places(self.value)}f"%(float(self.value))

    @CalcDecorator()
    def numeric(self, up = True):
        values = str(self.value).split('.')
        #print(values)
        if(len(values)<=1):
            return float(values[0])
        else:
            if(context.rounding == decimal.ROUND_HALF_UP):
                return float(f"%.{context.prec}f"%(float(self.evalue(self.value))))
            else:
                ilen = len(values[1])
                ilen = min(ilen, context.prec)
                ilen0 = max(len(values[0]), 1)
                ilen = min(20-ilen0-1, ilen)
                exvalue = ""
                ex = ","
                if('e' in values[1]):
                    ex = "e"
                    exvalue = 'e'+values[1].split('e')[1]
                if('E' in values[1]):
                    ex = "E"
                    exvalue = 'E'+values[1].split('E')[1]

                value = f"{values[0]}.{values[1][0:ilen]}"
                value = value.split(ex)[0]
                value = value + f"{exvalue}"
                value = value.replace('ee', 'e')
                value = value.replace('EE', 'E')
                return float(f"{value}")
        #return float(self.value.quantize(Decimal(f"1.{'0'*context.prec}"), decimal.getcontext().rounding))
        #return float(f"%.{context.prec}f"%(float(self.evalue(self.value))))

    @ staticmethod
    def get_num_by_prec(f_str, prec):
        '''
            f_str:传入的数字
            prec:精度
        '''
        # 如果是科学计数法转为一般显示
        f_str = str(Calc(f_str).evalue(f_str))
        a, _, c = f_str.partition('.')
        c = (c + "0" * prec)[:prec]  # 如论传入的函数有几位小数，在字符串后面都添加n为小数0
        value = ".".join([a, c])
        if float(value) == 0:
            return "0"
        value = value.rstrip('0').rstrip('.')
        return value
    
    @staticmethod
    def get_thousandth_num(number_str):
        '''
            将数字转为千分位显示
            number_str:传入的数字 string类型
        '''
        # 将数字转为字符串
        if not isinstance(number_str, str):
            number_str = str(number_str)
        # 如果是科学计数法转为一般显示
        number_str = str(Calc(number_str).evalue(number_str))
        # 拆分成整数部分和小数部分
        number_str_list = number_str.split('.')
        integer_part = number_str_list[0]
        decimal_part = None if len(number_str_list) == 1 else number_str_list[1]
        new_integer_part = ''
        reversed_integer_part = integer_part[::-1]  # 将字符串左右反转
        for i, c in enumerate(reversed_integer_part):  # 遍历字符，每隔3个字符加逗号
            if i > 0 and i % 3 == 0 and c != "-":
                new_integer_part = new_integer_part + ',' + c
            else:
                new_integer_part += c
        new_integer_part = new_integer_part[::-1]  # 将字符串左右反转
        if decimal_part:
            return new_integer_part + '.' + decimal_part
        return new_integer_part

    #加
    @CalcDecorator()
    def __add__(self, other):

        if(isinstance(other, Calc)):
            #print(context.prec,self.value , other.value)
            value = self.value + other.value
        else:
            #print(context.prec,self.value , other)
            value = self.value +  Decimal(str(other))
        '''
        if(isinstance(other, Calc)):
            value = (self.value*place*10 + other.value*place*10)/(place*10)
        else:
            value = (self.value*place*10 +  other*place*10)/(place*10)
        '''
        return value

    #减
    @CalcDecorator()
    def __sub__(self, other):

        if(isinstance(other, Calc)):
            #print(context.prec,self.value , other.value)
            value = self.value - other.value
        else:
            #print(context.prec,self.value , other)
            value = self.value - Decimal(str(other))

        return value

    #乘
    @CalcDecorator()
    def __mul__(self, other):

        if(isinstance(other, Calc)):
            #print(context.prec,self.value , other.value)
            value = (self.value * other.value)
        else:
            #print(context.prec, self.value , other)
            value = (self.value * Decimal(str(other)))

        return value
    #除
    @CalcDecorator()
    def __truediv__(self, other):

        if(isinstance(other, Calc)):
            #print(context.prec,self.value , other.value)
            value = (self.value / other.value)
        else:
            #print(context.prec,self.value * other)
            value = (self.value / Decimal(str(other)))

        return value

    #模
    @CalcDecorator()
    def __mod__(self, other):

        if(isinstance(other, Calc)):
            #print(context.prec,self.value , other.value)
            value = self.value % other.value
        else:
            #print(context.prec,self.value * other)
            value = self.value % Decimal(str(other))
        return value

    @staticmethod
    def is_num(value):
        s = value.split('.')
        if len(s) == 2:
            if s[0].isdigit() and s[1].isdigit():
                return True
            else:
                return False
        elif len(s) == 1:
            if s[0].isdigit():
                return True
        return False


def first_uniq_char(s: str) -> int:
    # 查找字符串中第一个不为 "0" 的字符索引
    for idx, s in enumerate(s):
        if not s == "0":
            return idx
    return 0

    

def retain_significant_digits(num, valid=6):
    convert_num = str(Calc(num))  # 转换格式，处理科学计数法
    split_num = convert_num.split(".")  # 整数 + 小数
    # 获取小数部分
    decimal_part = split_num[1] if len(split_num) > 1 else ''
    # 如果小数部分为 0 开头:
    if decimal_part.startswith("0"):
        # 拿到第一个不为 "0" 的字符索引
        zero_index = first_uniq_char(decimal_part)
        return Calc.get_num_by_prec(convert_num, zero_index + valid)
        # # 对不为 0 的部分进行 valid 位有效数字截取，如果最后一位是 0 的话去除掉
        # effective = decimal_part[zero_index:][:valid].rstrip('0')
        # # 把整数部分、小数部分组合，返回
        # return f"{split_num[0]}.{'0' * zero_index}{effective}".rstrip('.')
    # 不为 0 的，直接截取 valid 位有效位数返回
    # return f"{split_num[0]}.{decimal_part[:valid].rstrip('0')}".rstrip('.')
    return Calc.get_num_by_prec(convert_num, valid)

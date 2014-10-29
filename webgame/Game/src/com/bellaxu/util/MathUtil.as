package com.bellaxu.util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 常用数学方法
	 * @author BellaXu
	 */
	public class MathUtil
    {
		/**
		 * 取浮点数符号，正数返回1，负数返回-1
		 */
		public static function getSymbol(val:Number):int
		{
			if(val < 0)
				return -1;
			return 1;
		}
		
		/**
		 * 比较两个数，返回较小数
		 */
        public static function getMin(val1:Number, val2:Number) : Number
        {
            if(val1 >= val2)
                return val2;
            return val1;
        }

		/**
		 * 返回min～max之间的随机数
		 */
        public static function getRandomNum(min:Number, max:Number) : Number
        {
            return Number((Math.random() * (max - min) + min).toFixed(1));
        }

		/**
		 * 返回min～max之间的随机数
		 */
        public static function getRandomInt(min:int, max:int) : int
        {
            return int(Math.floor(Math.random() * (max - min + 1)) + min);
        }

		/**
		 * 取数组中的随机项
		 */
        public static function getRandomEle(ary:Array) : *
        {
            return ary[getRandomInt(ary.length - 1, 0)];
        }

		/**
		 * 取n1-n2的绝对值
		 */
        public static function getSub(n1:Number, n2:Number) : Number
        {
            return Math.abs(n1 - n2);
        }

		/**
		 * 取pt1与pt2的距离
		 */
        public static function getDistance(pt1:Point, pt2:Point) : Number
        {
            var disx:Number = pt2.x - pt1.x;
            var disy:Number = pt2.y - pt1.y;
            return Math.sqrt(disx * disx + disy * disy);
        }

		/**
		 * 取x的绝对值
		 */
        public static function abs(x:Number) : Number
        {
            return (x ^ (x >> 31)) - (x >> 31);
        }

        /**
         * 格式化整数为格式“100,000,000”
         */
        public static function getIntString(val:int) : String
        {
            var s:String = val.toString();
            var n:Array = [];
            var c:int = 1;

            for(var i:int = s.length - 1; i >= 0; i--)
            {
                if(c++ > 3)
                {
                    n[n.length] = ',';
                    c = 2;
                }
                n[n.length] = s.charAt(i);
            }

            return n.reverse().join("");
        }

        /**
         * 检查指定点是否在两点内(包含)
         */
        public static function inRange(x:Number, x1:Number, x2:Number) : Boolean
        {
            if((x >= x1 && x <= x2) || (x <= x1 && x >= x2))
            {
                return true;
            }
            return false;
        }

        /**
         * 检查指定点是否靠近两点
         */
        public static function inRangeFixed(x:Number, x1:Number, x2:Number, delta:uint) : Boolean
        {
            if(abs(x - x1) <= delta || abs(x - x2) <= delta)
            {
                return true;
            }
            return false;
        }

        /**
         * 检查指定点是否在矩阵内
         */
        public static function checkPointInRect(pt:Point, rect:Rectangle) : Boolean
        {
            if(pt.x > rect.x && pt.x < rect.x + rect.width && pt.y > rect.y && pt.y < rect.y + rect.height)
            {
                return true;
            }
            return false;
        }

        /**
         * 检查两个数符号是否相同
         */
        public static function checkSymbol(x1:Number, x2:Number) : Boolean
        {
            if((x1 == 0 && x2 == 0) || (x1 > 0 && x2 > 0) || (x1 < 0 && x2 < 0))
                return true;
            return false;
        }

		/**
		 * 取value的位数
		 */
        public static function getIntLength(value:int) : int
        {
            if(value <= 0)
                return 0;
            var c:int = 10;
            var k:int = 1000000000;
            while(int(value / k) <= 0)
            {
                c--;
                k /= 10;
            }
            return c;
        }

        /**
         * 将数字变成格式“X亿”或“X万”或“X”
         */
        public static function renderNumber(num:int) : String
        {
            var str:String = num.toString();
            if(num >= 100000)
            {
                str = int(num / 10000) + "万";
            }
            else if(num >= 1000000000)
            {
                str = int(num / 100000000) + "亿";
            }
            return str;
        }
		
		/**
		 * 获得百分比
		 */
		public static function getRate(value:Number, maxValue:Number):String
		{
			return int(value / maxValue * 100 * 100) / 100  + "%"
		}
		
		public static function toFixed(sv:Number, radius:int = 4):Number
		{
			var svf4Str:String = sv.toFixed(radius);
			if(svf4Str.indexOf('.') < 0)
				return Number(svf4Str);
			var tmpStr:String = svf4Str + "";
			var pos:int = svf4Str.length;
			while(pos--)
			{
				if(svf4Str.charAt(pos) == '.')
				{
					tmpStr = svf4Str.substr(0, pos);
					break;
				}
				if(svf4Str.charAt(pos) != '0')
				{
					break;
				}
				tmpStr = svf4Str.substr(0, pos);
			}
			return Number(tmpStr);
		}
    }
}
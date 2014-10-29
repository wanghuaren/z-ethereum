package common.utils.bit {
	/**
	 * fux 位操作工具
	 */
	public class BitUtil {
		
		
		/**
		 * 高16位，低16位
		 * 
		 * 例:
		 * 8 
		 * 0000 0000 0000 0000 , 0000 0000 0000 1000
		 * 高位                                                                                                                          低位
		 * 
		 * code:
		 * 
		 * n = n << (32 - end);
			n = n >>> (32 - end + start - 1);
			return n;
		 * 
		 * 
		 * 取单位，则起始位和结束位相同
		 * 
		 */ 
		public static function getOneToOne(n:int,start:int,end:int):int
		{				
			if(start > end)
			{
				throw new Error("start pos correct?");
			}
			
			return (n << (32 - end))>>> (32 - end + start - 1);
		}
		

		/**
		 * 将一个 int值 (target) 写入到另外一个 int 值 (src) 中 , 开始位置从低位算起,最低位置从 1  开始。
		 * @param target
		 * @param src
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */		
		public static function setIntToInt(target:int,src:int,start:int,end:int):int
		{
			target = getOneToOne(target,1,(end - start + 1));
			
			src = src | (target << (start-1));
			
			return src;
		}
		
		/**
		 * numberToConvert:Number
		 * 参数类型现改为int
		 */
		public static function convertToBinary(numberToConvert : int) : String {
			var result : String = "";
			for (var i : int = 0; i < 32; i++) {
				// Extract least significant bit using bitwise AND
				var lsb : Number = numberToConvert & 1;
				// Add this bit to the result
				result = (lsb ? "1" : "0") + result;
				// Shift numberToConvert right by one bit, to see next bit
				numberToConvert >>= 1;
			}
			return result;
		}
		
		public static function convertToBinaryArr(numberToConvert : int) : Array {
			var result : Array = [];
			for (var i : int = 0; i < 32; i++) {
				// Extract least significant bit using bitwise AND
				var lsb : Number = numberToConvert & 1;
				// Add this bit to the result
				result[i] = lsb ? 1 : 0;
				// Shift numberToConvert right by one bit, to see next bit
				numberToConvert >>= 1;
			}
			return result;
		}
		
		/**
		* 取单位
		* @param pos  把int转成二进制，从右往左第几位
		*/ 
		public static function getBitByPos(n:int,pos:int):int
		{				
			return (n << (32-pos))>>> 31;
		}
		
		/**
		 *	取整数的1或0个数
		 *  2012-01-11 andy 
		 *  @param n 
		 */
		public static function getCount(n:int,start:int=1,end:int=32):int{
			var ret:int=0;
			for(var k:int=(start-1);k<end;k++){
				if(n&Math.pow(2,k))ret++;
			}
			return ret;
		}
	}
}
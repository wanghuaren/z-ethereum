package common.utils
{
	import flash.utils.ByteArray;

	public class RandomCharacter
	{
		public function RandomCharacter()
		{	
		}
		
		public static function getCharacter():String{
			var byteArr:ByteArray = new ByteArray();
			var _str1:String,_str2:String,_str3:String,_str4:String;
			
			_str1 = String.fromCharCode(randomRange(explain("B-C")));
			if (_str1 == "F")
			{
				_str2 = String.fromCharCode(randomRange(explain("0-7")));
			}
			else
			{
				_str2 = String.fromCharCode(randomRange(explain("0-9,A-F")));
			}
			_str3 = String.fromCharCode(randomRange(explain("A-F")));
			switch (_str3)
			{
				case "A" :
					_str4 = String.fromCharCode(randomRange(explain("1-9,A-F")));
					break;
				case "F" :
					_str4 = String.fromCharCode(randomRange(explain("0-9,A-E")));
					break;
				default :
					_str4 = String.fromCharCode(randomRange(explain("0-9,A-F")));
					break;
			}
			
			
			var _str:String = "0x" + _str1 + _str2 + _str3 + _str4;
			byteArr.writeShort(parseInt(_str,16));
			byteArr.position = 0;
			return byteArr.readMultiByte(2,"gb2312");
		}
		
		
		//获取一个随机的范围整数值
		private static function integer(value:Number):int
		{
			return Math.floor(number(value));
		}
		
		
		//获取一个随机的范围Number值
		private static function number(value:Number):Number
		{
			return Math.random() * value;
		}
		
		private static function randomRange(restrictList:Array):Number
		{
			var list:Array = new Array  ;
			var length:int = restrictList.length;
			if (length % 2 != 0 || length == 0)
			{
				throw new Error("param error！can not get range！");
			}//将所有可能出现的随机数存入数组，然后进行随机
			for (var i:int = 0; i < length / 2; i ++)
			{
				var begin:int = restrictList[i * 2];
				var end:int = restrictList[i * 2 + 1];
				if (begin > end)
				{
					var value:Number = begin;
					begin = end;
					end = value;
				}
				for (begin; begin < end; begin ++)
				{
					list.push(begin);
				}
			}
			var result:Number = list[integer(list.length)];
			list = null;
			return result;
		}
		
		private static function explain(restrict:String,isCodeAt:Boolean = true):Array
		{
			var result:Array = new Array  ;
			var restrictList:Array = restrict.split(",");
			var length:uint = restrictList.length;
			for (var i:int = 0; i < length; i ++)
			{
				var list:Array = restrictList[i].split("-");
				if (list.length == 2)
				{
					var begin:String = list[0];
					var end:String = list[1];
					if (isCodeAt)
					{
						begin = begin.charCodeAt().toString();
						end = end.charCodeAt().toString();
					}
					//此处如果不加1，将不会随机ar[1]所表示字符，因此需要加上1，随机范围才是对的
					result.push(Number(begin),Number(end) + 1);
				}
				else if (list.length == 1)
				{
					var value:String = list[0];
					if (isCodeAt)
					{
						value = value.charCodeAt().toString();
					}//如果范围是1-2，那么整型随机必定是1，因此拿出第一个参数后，把范围定在参数+1，则就是让该参数参加随机
					result.push(Number(value),Number(value) + 1);
				}
				list = null;
			}
			restrictList = null;
			return result;
		}
	}
}
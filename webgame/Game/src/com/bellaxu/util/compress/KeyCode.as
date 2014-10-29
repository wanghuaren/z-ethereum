package com.bellaxu.util.compress
{
	public class KeyCode 
	{
		//fux 预编译计算优化
		public static const key1:Array = ["A","B","C","D","E","F","G","H","I","J"];
		public static const key2:Array = ["K","L","M","N","O","P","Q","R","S","T"];
		
		//解析地图数据
		public static function getCode(newstr:String, e:Boolean):String 
		{
			for (var s:* in key1) 
			{
				if (e) 
				{
					newstr = newstr.split(s + ",").join(key1[s]);
					newstr = newstr.split(s + "|").join(key2[s]);
				} 
				else 
				{
					newstr = newstr.split(key1[s]).join(s + ",");
					newstr = newstr.split(key2[s]).join(s + "|");
				}
			}
			return newstr;
		}
	}
}
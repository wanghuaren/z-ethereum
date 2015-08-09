package com.bommie.load
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * Dat工具类
	 * @author Bommie
	 */
	internal class ResDat
	{
		private static var datDic:Dictionary = new Dictionary();
		
		public static function saveDatByBytes(url:String, bytes:ByteArray):void
		{
			if(datDic[url])
				return;
			var dic:Dictionary = new Dictionary();
			bytes.uncompress();
			bytes.position = 0;
			while (bytes.bytesAvailable > 0)
			{
				dic[bytes.readUTF()] = bytes.readUTF();
			}
			datDic[url] = dic;
		}
		
		public static function getDatByPath(url:String):Dictionary
		{
			return datDic[url];
		}
	}
}
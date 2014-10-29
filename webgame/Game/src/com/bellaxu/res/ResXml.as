package com.bellaxu.res
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * xml资源
	 * @author BellaXu
	 */
	internal class ResXml
	{
		private static var xmlDic:Dictionary = new Dictionary();
		private static var libXmlDic:Dictionary = new Dictionary();
		
		public static function saveXMLByBytes(url:String, bytes:ByteArray):void
		{
			if(xmlDic[url])
				return;
			bytes.position = 0;
			xmlDic[url] = new XML(bytes.readUTFBytes(bytes.bytesAvailable));
		}
		
		public static function saveTxtXml(url:String, txt:String):void
		{
			xmlDic[url] = new XML(txt);
		}
		
		public static function saveLibXml(lib:String, url:String, xml:XML):void
		{
			libXmlDic[lib + "-" + url] = xml;
		}
		
		public static function getXMLByPath(url:String, lib:String = null):XML
		{
			if(lib)
				return libXmlDic[lib + "-" + url];
			return xmlDic[url];
		}
	}
}
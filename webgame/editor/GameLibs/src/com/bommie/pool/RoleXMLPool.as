package com.bommie.pool
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * xml资源
	 **/
	public final class RoleXMLPool
	{
		private static var _instance:RoleXMLPool;

		public static function get instance():RoleXMLPool
		{
			if (_instance == null)
				_instance=new RoleXMLPool();
			return _instance;
		}
		private var xmlDic:Dictionary=new Dictionary();
		private var libXmlDic:Dictionary=new Dictionary();

		public function saveXMLByBytes(url:String, bytes:ByteArray):void
		{
			if (xmlDic[url])
				return;
			bytes.position=0;
			xmlDic[url]=new XML(bytes.readUTFBytes(bytes.bytesAvailable));
		}

		public function saveTxtXml(url:String, txt:String):void
		{
			xmlDic[url]=new XML(txt);
		}

		public function saveLibXml(lib:String, url:String, xml:XML):void
		{
			libXmlDic[lib + "-" + url]=xml;
		}

		public function getXMLByPath(url:String, lib:String=null):XML
		{
			if (lib)
				return libXmlDic[lib + "-" + url];
			return xmlDic[url];
		}
	}
}

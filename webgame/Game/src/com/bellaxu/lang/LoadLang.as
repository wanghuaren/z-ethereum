package com.bellaxu.lang
{
	import flash.system.System;
	import flash.utils.Dictionary;

	/**
	 * 加载语言
	 * @author BellaXu
	 */
	public class LoadLang
	{
		private static var _langDic:Dictionary = new Dictionary();
		
		public static function init(xml:XML):void
		{
			var scriptList:XMLList=xml.script;
			for each (var sc:XML in scriptList)
			{
				var variList:XMLList = sc.vari;
				var n:String;
				var t:String;
				for each (var c:XML in variList)
				{
					n = c.@n;
					t = c.text();
					_langDic[n] = t;
				}
			}
			System.disposeXML(xml);
		}
		
		public static function get(key:String):String
		{
			return _langDic[key];
		}
	}
}
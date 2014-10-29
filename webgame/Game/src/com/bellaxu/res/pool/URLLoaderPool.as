package com.bellaxu.res.pool
{
	import flash.net.URLLoader;

	public class URLLoaderPool
	{
		private static var _list:Vector.<URLLoader> = new Vector.<URLLoader>();
		
		public static function init():void
		{
			if (_list.length > 0) return;
			for(var i:int = 0;i < 20;i++)
			{
				_list.push(new URLLoader());
			}
		}
		
		public static function pop():URLLoader
		{
			if(_list.length < 1)
			{
				return new URLLoader();
			}
			return _list.pop();
		}
		
		public static function recycle(l:URLLoader):void
		{
			_list.unshift(l);
		}
	}
}
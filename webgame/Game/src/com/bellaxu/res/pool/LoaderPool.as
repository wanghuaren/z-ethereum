package com.bellaxu.res.pool
{
	import flash.display.Loader;

	public class LoaderPool
	{
		private static var _list:Vector.<Loader> = new Vector.<Loader>();
		
		public static function init():void
		{
			if (_list.length > 0) return;
			for(var i:int = 0;i < 20;i++)
			{
				_list.push(new Loader());
			}
		}
		
		public static function pop():Loader
		{
			if(_list.length < 1)
			{
//				for(var i:int = 0;i < 200;i++)
//				{
//					_list.push(new Loader());
//				}
				return new Loader();
			}
			return _list.pop();
		}
		
		public static function recycle(l:Loader):void
		{
			_list.unshift(l);
		}
	}
}
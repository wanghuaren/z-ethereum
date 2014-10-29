package com.bellaxu.res.pool
{
	import com.bellaxu.struct.BitmapInfo;
	import com.bellaxu.struct.IBitmapInfo;

	/**
	 * bitmapInfo池
	 * @author BellaXu
	 */
	public class BitmapInfoPool
	{
		private static var _list:Vector.<IBitmapInfo> = new Vector.<IBitmapInfo>();
		
		public static function init():void
		{
			for(var i:int = 0;i < 1000;i++)
			{
				_list.push(new BitmapInfo());
			}
		}
		
		public static function pop():BitmapInfo
		{
			if(_list.length < 1)
			{
				for(var i:int = 0;i < 200;i++)
				{
					_list.push(new BitmapInfo());
				}
			}
			return _list.pop();
		}
		
		public static function recycle(info:IBitmapInfo):void
		{
			_list.unshift(info);
		}
	}
}
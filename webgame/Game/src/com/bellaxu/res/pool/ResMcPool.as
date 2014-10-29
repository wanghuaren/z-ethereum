package com.bellaxu.res.pool
{
	import com.bellaxu.res.ResMc;

	/**
	 * mc池
	 * @author BellaXu
	 */
	public class ResMcPool
	{
		private static var _list:Vector.<ResMc> = new Vector.<ResMc>();
		
		public static function init():void
		{
			for(var i:int = 0;i < 100;i++)
			{
				_list.push(new ResMc());
			}
		}
		
		public static function pop():ResMc
		{
			if(_list.length < 1)
			{
//				for(var i:int = 0;i < 200;i++)
//				{
//					_list.push(new ResMc());
//				}
				return new ResMc();
			}
			return _list.pop();
		}
		
		public static function recycle(rm:ResMc):void
		{
			_list.unshift(rm);
		}
	}
}
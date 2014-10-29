package com.bellaxu.map
{
	/**
	 * 地图块池
	 * @author BellaXu
	 */
	public class MapBlockPool
	{
		private static var _list:Vector.<MapBlock> = new Vector.<MapBlock>();
		
		public static function init():void
		{
			for(var i:int = 0;i < 20;i++)
			{
				_list.push(new MapBlock());
			}
		}
		
		public static function pop():MapBlock
		{
			if(_list.length < 1)
			{
//				for(var i:int = 0;i < 100;i++)
//				{
//					_list.push(new MapBlock());
//				}
				return new MapBlock();
			}
			return _list.pop();
		}
		
		public static function recycle(mb:MapBlock):void
		{
			_list.unshift(mb);
		}
	}
}
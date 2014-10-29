package com.bellaxu.mgr
{
	import flash.utils.getTimer;

	public class TimeMgr
	{
		static public var passedSecond :Number = 0;
		static public var cacheTime :int = 0;
		static public var passedTime :int = 0;
		public function TimeMgr()
		{
		}
		
		static public function update() :void
		{
			var curTick :int = getTimer();
			passedTime = curTick - cacheTime;
			passedSecond = passedTime/1000;
			cacheTime = curTick;			
		}
		
	}
}
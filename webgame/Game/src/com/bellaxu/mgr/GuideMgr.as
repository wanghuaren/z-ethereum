package com.bellaxu.mgr
{
	public class GuideMgr
	{
		private static var _instance:GuideMgr;
		
		public function GuideMgr()
		{
			
		}
		
		public static function getInstance():GuideMgr
		{
			if(!_instance)
				_instance = new GuideMgr();
			return _instance;
		}
		
		public var needHorseGuide:Boolean = false;
		public var needHorseStrongGuide:int = 0;
		public var needShengongluGuide:Boolean = false;
		public var needShengongluGuide2:Boolean = false;
	}
}
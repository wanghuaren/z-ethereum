package ui.view.view4.qq
{
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	/**
	 *@author WangHuaren
	 *2014-6-11_下午1:56:53
	 **/
	public class QQAD extends UIWindow
	{
		public function  QQAD()
		{
			super(getLink(WindowName.win_fan_li_ri));
		}
		private static var _instance:QQAD=null;
		
		public static function get instance():QQAD
		{
			if (_instance == null)
			{
				_instance=new QQAD();
			}
			return _instance;
		}
		
		override protected function init():void
		{
			super.init();
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			winClose();
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}
		
		override public function winClose():void
		{
			super.winClose();
		}
	}
}

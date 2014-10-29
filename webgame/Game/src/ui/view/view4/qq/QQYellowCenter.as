package ui.view.view4.qq
{
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *@author WangHuaren
	 *2014-4-15_下午5:56:38
	 **/
	public class QQYellowCenter extends UIWindow
	{
		public function QQYellowCenter()
		{
			super(getLink(WindowName.win_huang_zuan_zhuan_fu));
		}
		private static var _instance:QQYellowCenter=null;

		public static function get instance():QQYellowCenter
		{
			if (_instance == null)
			{
				_instance=new QQYellowCenter();
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
			switch (target.name)
			{
				case "btnXFHZ":
					QQYellowCenterPay.instance.open();
					break;
			}
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

package ui.view.view4.qq
{
	import common.utils.AsToJs;

	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *@author WangHuaren
	 *2014-4-15_下午5:56:50
	 **/
	public class QQYellowCenterPay extends UIWindow
	{
		public function QQYellowCenterPay()
		{
			super(getLink(WindowName.win_huang_zuan_zhong_zhi));
		}
		private static var _instance:QQYellowCenterPay=null;

		public static function get instance():QQYellowCenterPay
		{
			if (_instance == null)
			{
				_instance=new QQYellowCenterPay();
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
			if (target.name.indexOf("btn") == 0)
			{
				var m_num:int=int(target.name.replace("btn", ""));
				if (m_num > 0)
					AsToJs.callJS_centerPay("openvip", m_num > 100 ? int(m_num / 100) : m_num, m_num > 100 ? 1 : 0);
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

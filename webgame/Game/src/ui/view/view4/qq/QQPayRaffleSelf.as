package ui.view.view4.qq
{
	import common.config.PubData;
	
	import common.managers.Lang;
	import common.utils.AsToJs;
	
	import flash.net.URLRequest;
	
	import flashx.textLayout.elements.BreakElement;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketWCSubtractGold;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.vip.ChongZhi;

	/**
	 *@author WangHuaren
	 *2014-5-30_下午3:59:25
	 **/
	public class QQPayRaffleSelf extends UIWindow
	{
		public function QQPayRaffleSelf()
		{
			super(getLink(WindowName.win_chao_zhi_fan_li));
		}
		private static var _instance:QQPayRaffleSelf;

		public static function get instance():QQPayRaffleSelf
		{
			if (_instance == null)
			{
				_instance=new QQPayRaffleSelf();
			}
			return _instance;
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var targetName:String=target.name;
			switch (targetName)
			{
				case "btnPay":
					ChongZhi.getInstance().open();
					break;
			}
		}
	}
}

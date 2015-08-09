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

	/**
	 *@author WangHuaren
	 *2014-5-30_下午3:59:25
	 **/
	public class QQPayRaffle extends UIWindow
	{
		public function QQPayRaffle()
		{
			super(getLink(WindowName.win_chong_zhi_fan_li_ri));
		}
		private static var _instance:QQPayRaffle=null;

		public static function get instance():QQPayRaffle
		{
			if (_instance == null)
			{
				_instance=new QQPayRaffle();
			}
			return _instance;
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			flash.net.navigateToURL(new URLRequest(Lang.getLabel("QQ_Raffle_free_url")), "_blank");
			winClose();
		}
	}
}

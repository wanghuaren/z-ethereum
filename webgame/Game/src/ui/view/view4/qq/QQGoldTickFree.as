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
	public class QQGoldTickFree extends UIWindow
	{
		public function QQGoldTickFree()
		{
			super(getLink(WindowName.win_jin_quan_da_fang_song));
		}
		private static var _instance:QQGoldTickFree=null;

		public static function get instance():QQGoldTickFree
		{
			if (_instance == null)
			{
				_instance=new QQGoldTickFree();
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

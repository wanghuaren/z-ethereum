package ui.view
{
	import common.config.xmlres.GameData;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import netc.DataKey;

	import nets.packets.PacketCSGetTenMinutesInfo;
	import nets.packets.PacketCSGetTenMinutesPrize;
	import nets.packets.PacketCSJoinTenMinutes;
	import nets.packets.PacketSCGetTenMinutesInfo;
	import nets.packets.PacketSCGetTenMinutesPrize;

	import ui.frame.ItemManager;
	import ui.frame.UIControl;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	import ui.view.view6.Alert;

	public class WinShiFen extends UIWindow
	{
		private static var _instance:WinShiFen;

		public static function instance():WinShiFen
		{
			if (_instance == null)
				_instance=new WinShiFen();
			return _instance;
		}

		public function WinShiFen()
		{
			super(getLink(WindowName.win_shi_fen_you_li));
			DataKey.instance.register(PacketSCGetTenMinutesPrize.id, getPrize);
		}

		public function getPrize(p:PacketSCGetTenMinutesPrize):void
		{
			showResult(p);
		}
		public static var pData:PacketSCGetTenMinutesInfo;

		override protected function init():void
		{
			super.init();

			var m_dropList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(60102256) as Vector.<Pub_DropResModel>;
			for (var j:int=0; j < 5; j++)
			{
				ItemManager.instance().setToolTip(mc["item" + (j + 1)], m_dropList[j].drop_item_id, 0, 1, m_dropList[j].drop_num);
			}
			showInfo();
		}

		private function showInfo():void
		{
			if (pData.times <= 0)
			{
				mc["btn"].gotoAndStop(1);
			}
			else
			{
				mc["btn"].gotoAndStop(2);
			}
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var m_name:String=target.name;
			switch (m_name)
			{
				case "btn1":
				{
					DataKey.instance.send(new PacketCSJoinTenMinutes());
					navigateToURL(new URLRequest(Lang.getLabel("QQ_ShiFen_url")), "_blank");
					break;
				}
				case "btn2":
				{
					DataKey.instance.send(new PacketCSGetTenMinutesPrize());
					break;
				}
			}
		}
	}
}

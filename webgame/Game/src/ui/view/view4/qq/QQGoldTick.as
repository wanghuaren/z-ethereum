package ui.view.view4.qq
{
	import common.config.PubData;
	import common.config.xmlres.lib.TablesLib;
	import common.utils.AsToJs;
	
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
	public class QQGoldTick extends UIWindow
	{
		public function QQGoldTick()
		{
			super(getLink(WindowName.win_dui_huan_jin_quan, "qq_yellow"));
		}
		private static var _instance:QQGoldTick=null;

		public static function get instance():QQGoldTick
		{
			if (_instance == null)
			{
				_instance=new QQGoldTick();
			}
			return _instance;
		}
		private var resID:Array=[TablesLib.YUAN_BAO_TOOL_ID, 11800065, 10200155, 11800251];

		override protected function init():void
		{
			super.init();
			DataKey.instance.register(PacketWCSubtractGold.id, paymentCallback);
			fillData();
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			if (target.name == "btnDuiHuan")
			{
				switch (target.parent.name)
				{
					case "item_1":
						AsToJs.callJS("payment", 100);
						break;
					case "item_2":
						AsToJs.callJS("payment", resID[1]);
						break;
					case "item_3":
						AsToJs.callJS("payment", resID[2]);
						break;
					case "item_4":
						AsToJs.callJS("payment", resID[3]);
						break;
				}
			}
		}

		public function paymentCallback(p:PacketWCSubtractGold):void
		{
			PubData.goldTick=PubData.goldTick - p.gold;
			PubData.goldTick=PubData.goldTick > 0 ? PubData.goldTick : 0;
			mc["text_JinQuan"].text=PubData.goldTick + "";
		}

		public function fillData():void
		{
			mc["text_JinQuan"].text=PubData.goldTick + "";
			var m_data:StructBagCell2;
			for (var i:int=0; i < resID.length; i++)
			{
				m_data=new StructBagCell2();
				m_data.itemid=resID[i];
				Data.beiBao.fillCahceData(m_data);
				ItemManager.instance().setToolTipByData(mc["item_" + (i + 1)], m_data, 1);
				mc["item_" + (i + 1)]["txt_name"].text=m_data.itemname;
				mc["item_" + (i + 1)].mouseChildren=true;
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

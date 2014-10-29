package ui.view.pay
{
	import common.config.PubData;
	import common.config.xmlres.GameData;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSGetFirstPayPrize;
	import nets.packets.PacketSCGetFirstPayPrize;
	
	import ui.base.vip.ChongZhi;
	import ui.base.vip.Vip;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowModelClose;
	import ui.frame.WindowName;

	/**
	 *@author WangHuaren
	 *2014-4-29_下午1:28:26
	 **/
	public class WinFirstPay extends UIWindow
	{
		public function WinFirstPay()
		{
			super(getLink(WindowName.win_shou_chong_li_bao));
		}
		private static var _instance:WinFirstPay=null;

		public static function get instance():WinFirstPay
		{
			if (_instance == null)
			{
				_instance=new WinFirstPay();
			}
			return _instance;
		}

		public function getFirstPayBack(p:PacketSCGetFirstPayPrize):void
		{
			Lang.showResult(p);
		}

		override protected function init():void
		{
			super.init();
			
			DataKey.instance.register(PacketSCGetFirstPayPrize.id, getFirstPayBack);
			fillContent(mc);
		}
		/**
		 * 职业:1,3,4,6 对应的掉落ID编号
		 * */
		private var metierRes:Array=[];
		/**
		 * 四把武器对应的编号
		 * */
		private var wapon:Array=[11301326, 11301126, 11301726,11301526 ];
		/**
		 * 熊猫图标对应的编号
		 * */
		private var panda:int=13001003;

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "btn_now_pay":
					if (WindowModelClose.isOpen(WindowModelClose.IS_PAY))
						ChongZhi.getInstance().open();
					else
						Vip.getInstance().pay();
					break;
				case "btnLingQu":
					DataKey.instance.send(m_getFirstPayPrize);
					break;
			}
		}
		private var m_getFirstPayPrize:PacketCSGetFirstPayPrize=new PacketCSGetFirstPayPrize();

		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
		}

		public function fillContent(mc:DisplayObject):void
		{
			metierRes[1]=60102376;
			metierRes[3]=60102377;
			metierRes[4]=60102378;
			metierRes[6]=60102379;
			var m_dropList:Vector.<Pub_DropResModel>=GameData.getDropXml().getResPath2(metierRes[PubData.metier]) as Vector.<Pub_DropResModel>;
			if (m_dropList != null)
			{
				for (var i:int=0; i < 6; i++)
				{
					if(mc["pitem" + i]==null)continue;
					if (m_dropList.length > i)
					{
						mc["pitem" + i].visible=true;
						ItemManager.instance().setToolTip(mc["pitem" + i], m_dropList[i].drop_item_id, 0, 1,m_dropList[i].drop_num);
					}
					else
					{
						mc["pitem" + i].visible=false;
					}
				}
			}
		}

		override public function winClose():void
		{
			super.winClose();
		}
	}
}

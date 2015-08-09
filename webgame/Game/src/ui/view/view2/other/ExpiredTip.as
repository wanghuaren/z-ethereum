package ui.view.view2.other
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.base.vip.Vip;
	import ui.base.vip.VipZuoJi;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;


	/**
	 * 过期物品提示
	 * @author andy
	 * @date   2012-08-08
	 */
	public final class ExpiredTip extends UIWindow
	{
		private var itemId:int=0;

		private static var _instance:ExpiredTip;

		public static function getInstance():ExpiredTip
		{
			if (_instance == null)
				_instance=new ExpiredTip();
			return _instance;
		}

		public function ExpiredTip()
		{
			super(getLink(WindowName.win_expired_tip));
		}

		public function setData(v:int):void
		{
			itemId=v;
			super.open();
		}

		override protected function init():void
		{
			super.init();
			switch (itemId)
			{
				case 10606001:
				case 10607001:
				case 10607002:
				case 10607003:
					//混沌天宝兽
					(mc as MovieClip).gotoAndStop(1);
					break;
				case 10608001:
				case 10608002:
				case 10608003:
					//雷火云纹豹
					(mc as MovieClip).gotoAndStop(2);
					break;
				case 1:
					//vip过期
					(mc as MovieClip).gotoAndStop(3);
					break;
				case 12200001:
					//2012-12-21 翅膀过期
					(mc as MovieClip).gotoAndStop(4);
					break;
				case 12000001:
				case 11311110:
				case 11311111:	
				case 13001004:	
					//2014-10-29 礼包过期
					(mc as MovieClip).gotoAndStop(5);
					var tool:Pub_ToolsResModel=XmlManager.localres.ToolsXml.getResPath(itemId) as Pub_ToolsResModel;
					if(tool!=null&&mc["txt_msg"]!=null)
						mc["txt_msg"].htmlText="你的"+tool.tool_name+"已过期！";
					break;
				default:
					(mc as MovieClip).gotoAndStop(1);
					break;
			}
		}


		override public function mcHandler(target:Object):void
		{
			switch (target.name)
			{
				case "btnVip3":
					if (Data.myKing.Vip < 3)
						Vip.getInstance().vipUp(3);
					else
						Lang.showMsg(Lang.getClientMsg("10028_expiredtip", [Data.myKing.Vip]));
					break;
				case "btnReadVip3":
//					Vip.getInstance().setData(3);
					ZhiZunVIPMain.getInstance().open(true);
					break;
				case "btnBuyLeopard":
					//前往商店购买雷火云纹豹
//					NpcShop.instance().setshopId(NpcShop.ZUO_QI_SHOP_BUY_ID);
//					break;
				case "btnBuyRide":
					if(StringUtils.diJiTian() <= 7)
					{
						VipZuoJi.getInstance().open();
					}else{
						VipZuoJi.getInstance().open();
						
					}
					super.winClose();
					break;
				case "btnChiBang":
					//拥有翅膀
					var tool:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(12200002) as Pub_ToolsResModel;
					if(tool!=null)
						alert.ShowMsg(Lang.getLabel("10148_expiredtip",[tool.tool_coin3,tool.tool_name]),4,null,buyChiBang);
					break;
				default:
					break;
			}

		}

		/******通讯********/
		/**
		 *	拥有翅膀 
		 */
		public function buyChiBang():void{
//			var bag:StructBagCell2=new StructBagCell2();
//			bag.itemid=12200002;
//			Data.beiBao.fillCahceData(bag);
//			
//			NpcBuy.instance().setType(4,bag,true,NpcShop.PUB_SHOP_BUY_ID);
		}
	}
}





package ui.base.vip
{
	import flash.net.*;
	
	import netc.packets2.PacketSCItemBuyDiscount2;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	
	public class VipZuoJi extends UIWindow 
	{
		private static var _instance:VipZuoJi;
		public var selData:int=0;
		public const AutoRefreshSecond:int=30;
		private var curAutoRefresh:int=0;
		
		/**
		 * 2 - 原价  , 3- 打折
		 *
		 *   道具表(tools)
		 tool_coin3	tool_discount_coin3
		 元宝价格		限时元宝价格
		 */
		//public static const SORT:int = 3;
		public static function getInstance():VipZuoJi
		{
			if (_instance == null)
				_instance=new VipZuoJi();
			return _instance;
		}
		
		public function VipZuoJi()
		{
//			super(getLink(WindowName.win_vip_zuoji));
		}
		
		override protected function init():void
		{
			super.init();
		}
		
		private function SCItemBuyDiscount(p:PacketSCItemBuyDiscount2):void
		{
			if (super.showResult(p))
			{
				mc["mcYongYou"].visible=false;
				selData=0;
			}
			else
			{
			}
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			//reset			
			super.mcHandler(target);
			var target_name:String=target.name;
			var target_parent_name:String;
			switch (target_name)
			{
				case "btnVipTo3":
					//selData = _list[0].horse1;
					//popYongYou();
					break;
				case "btnVipTo5":
					//selData = _list[0].horse2;
					//popYongYou();
					break;
				case "btnVipTo7":
					//selData = _list[0].horse3;
					//popYongYou();
					break;
				case "btnVipToLook3":
					//ZuoQiLook.getInstance().setData(_list[0].horse1);
					break;
				case "btnVipToLook5":
					//ZuoQiLook.getInstance().setData(_list[0].horse2);
					break;
				case "btnVipToLook7":
					//ZuoQiLook.getInstance().setData(_list[0].horse3);
					break;
				case "btnGoShoping":
					//点击【前往商店】按钮，弹开坐骑商店(商店ID：70100013)
					//NpcShop.instance().setshopId(NpcShop.ZUO_QI_SHOP_BUY_ID);
					break;
				case "btnSubmit":
					//					if(selData > 0)
					//					{					
					//						//2 - 原价  , 3- 打折
					//						if(2 == _list[0].sort)
					//						{
					//							var itemBuy2:PacketCSItemBuy = new PacketCSItemBuy();
					//							itemBuy2.itemid = selData;
					//							itemBuy2.num=1;
					//							uiSend(itemBuy2);
					//						}
					//						
					//						if(3 == _list[0].sort)
					//						{							
					//							var itemBuy3:PacketCSItemBuyDiscount = new PacketCSItemBuyDiscount();
					//							itemBuy3.itemid = selData;
					//							itemBuy3.num=1;
					//							uiSend(itemBuy3);
					//						
					//						}
					//						
					//					}
					break;
				case "btnCancel":
					//mc["mcYongYou"].visible = false;
					//selData = 0;
					break;
			}
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			selData=0;
			super.windowClose();
		}
		
	}
}
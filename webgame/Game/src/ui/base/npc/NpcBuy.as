package ui.base.npc
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_Shop_NormalResModel;
	import common.config.xmlres.server.Pub_Shop_PageResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.res.ResCtrl;
	
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;

	/**
	 *	npc商店购买【售出】
	 *  andy 2012-01-29 
	 */
	public class NpcBuy extends UIWindow
	{
		/**
		 *	type 1.购买 2.出售 3.兑换 4.使用元宝购买 5.使用帮贡购买
		 */
		private var bag:StructBagCell2=null;
		private const MAX:int=99;
		
		private var callBackFunc:Function=null;
		
		private static var _instance:NpcBuy;
		
		//商店ID
		private var m_shopID:int = 0;
		
		public static function instance():NpcBuy{
			if(_instance==null){
				_instance=new NpcBuy();
			}
			return _instance;
		}
		
		public static function hasInstance():Boolean{
			if(null == _instance){
				return false;
			}
			return true;
		}
		
		public function NpcBuy()
		{
			super(getLink(WindowName.pop_gou_mai));
			
			//this.sysAddEvent(PubData.AlertUI,"NpcBuyTop",npcBuyTopHandler);
			PubData.AlertUI.addEventListener("NpcBuyTop", npcBuyTopHandler);
			
		}
		
		/**
		 *  
		 * @param v   1.购买 2.出售 3.兑换 4.使用元宝购买 5.使用贡献购买
		 * @param d
		 * @param must
		 * 
		 */		
		public function setType(v:int,d:Object,must:Boolean=false,shopID:int=0,backFunc:Function=null):void{
			type=v;
			bag=d as StructBagCell2;
			m_shopID = shopID;
			callBackFunc=backFunc;
			super.open(must);
		}
		override protected function openFunction():void{
			
			
			
			init();	
		}
				
		private function npcBuyTopHandler(e:DispatchEvent):void
		{
			if(null != this.parent)
			{
				this.parent.addChild(this);
				
			}
			
			
		}
		
		override protected function init():void {
			super.sysAddEvent(mc["ui_count"],MoreLess.CHANGE,countChangeHandle);
			mc["ui_count"].min=0;
			StringUtils.setEnable(mc["ui_count"]);
			mc["ui_count"].mouseChildren = true;
			StringUtils.setEnable(mc["btnMax"]);
			num=1;
			
			var max:int;
			if(type==1){
				max=int(Data.myKing.coin1/bag.buyprice1);
				if(max>=MAX)max=MAX;
				mc["ui_count"].max=max;
			}else if(type==2){
				max=bag.num;
				mc["ui_count"].max=bag.num;
				num=bag.num;
				if(bag.plie_num==1){
					StringUtils.setUnEnable(mc["ui_count"]);
					mc["ui_count"].mouseChildren = false;
					StringUtils.setUnEnable(mc["btnMax"]);
				}
				
			}else if(type==3){
				max=int(Data.beiBao.getBeiBaoCountById(bag.need_id,true)/bag.need_num);
				if(max>=MAX)max=MAX;
				mc["ui_count"].max=max;
			}
			else if(4 == type)
			{
				var yuanbao:int=Data.myKing.yuanBao;
				//2013-11-13 根据商店id判断是否只能用元宝购买
				if(this.m_shopID>0){
					var yuanbaoType:int=0;
					var shop:Pub_Shop_NormalResModel=XmlManager.localres.getPubShopNormalXml.getResPath4(m_shopID,bag.itemid) as Pub_Shop_NormalResModel;
					if(shop!=null){
						yuanbaoType=shop.need_sort;
					}
					if(yuanbaoType==2){
						yuanbao=Data.myKing.coin3;
					}
				}
				
				max=int(yuanbao/bag.buyprice3);
				if(max>=MAX)
				{
					max=MAX;
				}
				mc["ui_count"].max=max;
			}
			else if(5 == type)
			{
			}
			if(max==0)max=1;
			mc["ui_count"].max=max;
			mc["mc_title"].gotoAndStop(type);
			mc["btnSubmit"].gotoAndStop(type);
			mc["txt_name"].htmlText=ResCtrl.instance().getFontByColor(bag.itemname,bag.toolColor);
			
			ItemManager.instance().setToolTipByData(mc["mc_icon"],bag,1);
			mc["ui_count"].showCount(num);
		}
		
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
			
			switch(name) {
				case "btnSubmit":
					//type==1?buy():type==2?sell():exchange();
					switch(type)
					{
						case 1:
							buy();
							break;
						case 2:
							sell(bag.pos,mc["ui_count"].value);
							break;
						case 3:
							exchange();
							break;
						case 4:
							_buyFromYB();
							break;
						
						case 5:
							_buyFromGongXian();
							break;
						
						default:
							break;
					}
					break;
				case "btnMax":
					mc["ui_count"].showCount(mc["ui_count"].max);
					break;
				
			}
		}
		private function countChangeHandle(e:DispatchEvent):void {
			var count:int=int((e as DispatchEvent).getInfo.count);
			var price_all:int=0;
			if(type==1){
				price_all=count*bag.buyprice1;
				if(price_all<=Data.myKing.coin1)
					mc["txt_price_all"].htmlText=price_all;
				else
					mc["txt_price_all"].htmlText="<font color='#ff0000'>"+price_all+"</font>";
				mc["mc_money_type"].gotoAndStop(1);
			}else if(type==2){
				price_all=count* ResCtrl.instance().getEquipPrice(bag);
				mc["txt_price_all"].htmlText=price_all;
				mc["mc_money_type"].gotoAndStop(2);
			}else if(type==3){
				price_all=count*bag.need_num;
				mc["txt_price_all"].htmlText=price_all+Lang.getLabel("pub_ge");
				mc["mc_money_type"].gotoAndStop(3);
			}else if(type==4)
			{
				price_all=count*bag.buyprice3;
				if(price_all<=Data.myKing.yuanBao)
				{
					mc["txt_price_all"].htmlText=price_all;
				}
				else
				{
					mc["txt_price_all"].htmlText="<font color='#ff0000'>"+price_all+"</font>";
				}
				mc["mc_money_type"].gotoAndStop(4);
			}else if(type == 5)
			{
				mc["mc_money_type"].gotoAndStop(5);
			}
			
			mc["btnSubmit"].mouseEnabled=mc["btnSubmit"].mouseChildren=count>0;
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnSubmit"],count>0);
		}

		override protected function windowClose():void{
			super.windowClose();

		}
		/**************通信***********/
		/**
		 *	购买
		 */
		private function buy():void{
			this.uiRegister(PacketSCItemBuy.id,buyReturn);
			var client:PacketCSItemBuy=new PacketCSItemBuy();
			client.itemid=bag.itemid;
			client.num=mc["ui_count"].value;
			this.uiSend(client);
		}
		
		private function buyReturn(p:PacketSCItemBuy):void{
			if(p==null)return;
			if(super.showResult(p)){
				Lang.showMsg(Lang.getClientMsg("10003_npc_shop"));
				super.winClose();
			}else{
				
			}
		}
		
		private function _buyFromYB():void
		{
			this.uiRegister(PacketSCItemExchange.id,_buyFromYBReturn);
			var client:PacketCSItemExchange=new PacketCSItemExchange();
			client.shopid = m_shopID;
			client.itemid=bag.itemid;
			client.num=mc["ui_count"].value;
			this.uiSend(client);
		}
		
		private function _buyFromGongXian():void
		{
			this.uiRegister(PacketSCBuyGuildItem.id,SCBuyGuildItem);
			var client:PacketCSBuyGuildItem=new PacketCSBuyGuildItem();
			
			client.itemid=bag.itemid;
			client.num=mc["ui_count"].value;
			
			this.uiSend(client);
		
		}
		
		private function SCBuyGuildItem(p:PacketSCBuyGuildItem2):void
		{
			
			if(super.showResult(p))
			{
				
				super.winClose();
				
				if(callBackFunc!=null){
					callBackFunc();
					callBackFunc=null;
				}
				
			}
			else
			{
			
			}
		}
		
		private function _buyFromYBReturn(p:PacketSCItemExchange):void
		{
			if(p==null)return;
			if(super.showResult(p)){
				Lang.showMsg(Lang.getClientMsg("10003_npc_shop"));
				super.winClose();
				if(callBackFunc!=null){
					callBackFunc();
					callBackFunc=null;
				}
			}else{
				
			}
		}
		
		
		/**
		 *	兑换
		 */
		private function exchange():void{
			this.uiRegister(PacketSCItemExchange.id,exchangeReturn);
			var client:PacketCSItemExchange=new PacketCSItemExchange();
			client.shopid=NpcShop.instance().shopId;
			client.itemid=bag.itemid;
			client.num=mc["ui_count"].value;
			this.uiSend(client);
		}
		private function exchangeReturn(p:PacketSCItemExchange):void{
			if(p==null)return;
			if(super.showResult(p)){
				Lang.showMsg(Lang.getClientMsg("10003_npc_shop"));
				super.winClose();
				if(callBackFunc!=null){
					callBackFunc();
					callBackFunc=null;
				}
			}else{
				
			}
		}
		/**
		 *	出售 
		 */
		public function sell(pos:int,count:int):void{
			this.uiRegister(PacketSCItemSell.id,sellReturn);
			var client:PacketCSItemSell=new PacketCSItemSell();
			client.pos=pos;
			client.num=count;
			this.uiSend(client);
		
		}
		private function sellReturn(p:PacketSCItemSell):void{
			if(p==null)return;
			if(super.showResult(p)){
				Lang.showMsg(Lang.getClientMsg("10004_npc_shop"));
				if(this.isOpen)
					super.winClose();
			}else{
				
			}
		}
		
		
		override public function getID():int
		{
			return 1037;
		}
		
		
	}
}






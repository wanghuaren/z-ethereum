package ui.base.beibao
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_Shop_NormalResModel;
	import common.config.xmlres.server.Pub_Shop_PageResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import engine.support.IPacket;
	import nets.packets.PacketCSBankFetchMoney;
	import nets.packets.PacketCSBankStoreMoney;
	import nets.packets.PacketCSItemBuy;
	import nets.packets.PacketCSItemSell;
	import nets.packets.PacketSCBankFetchMoney;
	import nets.packets.PacketSCItemBuy;
	import nets.packets.PacketSCItemSell;
	
	import common.utils.StringUtils;
	
	import ui.frame.UIWindow;
	
	import world.FileManager;
	import common.managers.Lang;
	
	public class StoreGetMoney extends UIWindow
	{
		private static var _instance:StoreGetMoney;
		public static function instance():StoreGetMoney
		{
			if(_instance==null){
				_instance=new StoreGetMoney();
			}else{
				
				_instance.addObjToStage(_instance.mc);
			}
			return _instance;
		}
		
		public function StoreGetMoney()
		{
			super(getLink("pop_qu_qian"));
		}	
		override protected function init():void {
			super.sysAddEvent(mc["txt_ying_liang"],FocusEvent.FOCUS_IN,clear_ying_liang);
			mc["txt_ying_liang"].text = "0";
			(mc["txt_ying_liang"] as TextField).restrict = "0-9";
			(mc["txt_ying_liang"] as TextField).maxChars = 8;
			
			if (focusManager != null)focusManager.setFocus(mc["txt_ying_liang"]);
		}
		
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
			
			switch(name) {
				case "btnSubmit":
										
					if("0" == mc["txt_ying_liang"].text ||
						"" == mc["txt_ying_liang"].text)
					{
						return;
					}
					
					this.uiRegister(PacketSCBankFetchMoney.id,storeReturn);
					
					var p:PacketCSBankFetchMoney = new PacketCSBankFetchMoney();
					
					p.money = parseInt(mc["txt_ying_liang"].text);
					
					this.uiSend(p);
					
					//
					clear_ying_liang();
					
					break;
				
			}
		}
						
		
		public function clear_ying_liang(e:FocusEvent=null):void
		{
			mc["txt_ying_liang"].text= "";
		}
		
		
		
		private function storeReturn(p:IPacket):void{
			if(p==null)return;
			if(super.showResult(p)){
				
				super.winClose();
			}else{
				
				super.winClose();
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
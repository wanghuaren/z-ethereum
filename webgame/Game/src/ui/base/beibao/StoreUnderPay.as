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
	import nets.packets.PacketCSBankStoreMoney;
	import nets.packets.PacketCSItemBuy;
	import nets.packets.PacketCSItemSell;
	import nets.packets.PacketSCBankStoreMoney;
	import nets.packets.PacketSCItemBuy;
	import nets.packets.PacketSCItemSell;
	
	import ui.factory.UIFactory;
	
	import common.utils.StringUtils;
	
	import ui.frame.UIWindow;
	
	import world.FileManager;
	import common.managers.Lang;
	
	public class StoreUnderPay extends UIWindow
	{
		private static var _instance:StoreSaveMoney;
		public static function instance():StoreSaveMoney
		{
			if(_instance==null){
				_instance=new StoreSaveMoney();
			}else{
				
				_instance.addObjToStage(_instance.mc);
			}
			return _instance;
		}
		
		public function StoreUnderPay()
		{
			super(getLink("pop_store_chong_zhi"));
		}
		
		/**
		 *	窗体显示
		 * 	@param must 是否必须 
		 */
		public function show(must:Boolean=false) : void {
			if(must==false || (must==true&&!UIWindow.existView(this.mc))){
				super.addObjToStage(this.mc, true);
			}
		}
		
		override protected function init():void 
		{
			
			
		}
		
		override public function mcHandler(target:Object):void 
		{
			var name:String=target.name;
			
			switch(name) 
			{
				case "btnSubmit":
							UIFactory.getGame.OpenRmbLink();
							break;
					
			}
		}
		
		
		
		
	}
}
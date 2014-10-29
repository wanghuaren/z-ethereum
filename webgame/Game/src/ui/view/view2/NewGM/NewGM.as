package ui.view.view2.NewGM {
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import common.config.GameIni;
	
	import netc.Data;
	
	import nets.packets.PacketCSGameGM;
	import nets.packets.PacketSCGameGM;
	
	import ui.frame.UIWindow;
	import ui.base.vip.Vip;
	
	import common.managers.Lang;


	/**
	 * @联系GM
	 * @author andy
	 * @2011-10-25
	 */
	public class NewGM extends  UIWindow{
		private var sort:int=0;
		
		private static var _instance:NewGM;
		public static function getInstance():NewGM{
			if(_instance==null)
				_instance=new NewGM();
			return _instance;
		}
		public function NewGM() : void {
			super(getLink("win_GM"));
		}
		override protected function init():void{
			super.init();
			
			this.uiRegister(PacketSCGameGM.id,SCGameGM);

		}
		override public function mcHandler(target:Object):void {
			super.mcHandler(target);
			var name:String=target.name;
			if(name.indexOf("radio")>=0){
				sort=int(name.replace("radio",""));
			}
			switch(name) {
				case "btnSubmit":
					if(mc["bugtxt"].text == "") {
						//alert.ShowMsg("内容不能留空，请填写内容！", 2);
						
						alert.ShowMsg(Lang.getLabel("50003_NewGM"), 2);						
						
						return;
					}

					var _loc1:PacketCSGameGM=new PacketCSGameGM();
					_loc1.type=sort;
					//_loc1.content="(角色名称：" + Data.myKing.king.getKingName + ")" + mc["bugtxt"].text + "";
					
					_loc1.content="(" + Lang.getLabel("500031_NewGM") +"：" + Data.myKing.king.getKingName + ")" + mc["bugtxt"].text;
					
					
					this.uiSend(_loc1);
					mc["bugtxt"].text = "";
					break;
				case "btn_keFu":	
					
					break;
				case "btn_lunTan":	
					GameIni.bbs();
					break;
				case "btn_chongZhi":	
					Vip.getInstance().pay();
					break;
			}
		}

		private function SCGameGM(p:PacketSCGameGM):void {
			if(p.tag==0){
				Lang.showMsg(Lang.getClientMsg("pub_success"));
			}else{
				Lang.showMsg(Lang.getServerMsg(p.tag));
			}
		}

		override public function winClose() : void {
			super.winClose();
			//GameNet.removeListener("CSysBug", CSysBug);

		}
		
		override public function getID():int
		{
			return 1027;
		}
		
		
	}
}




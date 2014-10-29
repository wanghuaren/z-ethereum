package ui.base.beibao
{
	import flash.net.*;
	import flash.text.TextField;
	
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSItemSplit;
	import nets.packets.PacketSCItemSplit;
	
	import scene.manager.MouseManager;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	
	/**
	 * 背包拆分
	 * @author andy
	 * @date   2013-02-25
	 */
	public final class BeiBaoSplit extends UIWindow {
		private var bag:StructBagCell2;
		
		private static var _instance:BeiBaoSplit;
		public static function getInstance():BeiBaoSplit{
			if(_instance==null)
				_instance=new BeiBaoSplit();
			return _instance;
		}
		public function BeiBaoSplit() {
			super(getLink(WindowName.pop_chai_fen));
		}
		
		public function setData(v:StructBagCell2):void{
			bag=v;
			MouseManager.instance.show(0);
			super.open(true);
		}
		override protected function openFunction():void{
			init();
		}
		
		override protected function init():void {
			mc["txt_num"].text=1;
			(mc["txt_num"] as TextField).restrict="0-9";
			(mc["txt_num"] as TextField).maxChars=2;
		}
		
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
				
			switch(target.name) {
				case "btnOk":
					//
					SCItemSplit();
					break;
				default:
					break;
				
			}
		}
		

		
		/*****************通讯***************/
		/**
		 *	拆分
		 */
		private function SCItemSplit():void{
			this.uiRegister(PacketSCItemSplit.id,SCItemSplitReturn);
			var client:PacketCSItemSplit=new PacketCSItemSplit();
			client.pos=bag.pos;
			client.num=mc["txt_num"].text;
			this.uiSend(client);
		}
		private function SCItemSplitReturn(p:PacketSCItemSplit):void{
			if(p==null)return;
			if(super.showResult(p)){
				super.winClose();
			}else{
				
			}
		}

		
	}
	
}






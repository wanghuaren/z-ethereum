package ui.base.beibao
{
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.net.*;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSUseItemBatch;
	import nets.packets.PacketSCUseItemBatch;
	
	import scene.manager.MouseManager;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	
	/**
	 * 背包批量使用
	 * @author andy
	 * @date   2013-03-04
	 */
	public final class BeiBaoUsedMore extends UIWindow {
		private var bag:StructBagCell2;
		
		private static var _instance:BeiBaoUsedMore;
		public static function getInstance():BeiBaoUsedMore{
			if(_instance==null)
				_instance=new BeiBaoUsedMore();
			return _instance;
		}
		public function BeiBaoUsedMore() {
			super(getLink(WindowName.pop_pi_liang));
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
			super.sysAddEvent(mc["ui_count"],MoreLess.CHANGE,countChangeHandle);
			mcHandler(mc["btnMax"]);
		}
		
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
				
			switch(target.name) {
				case "btnOk":
					//
					SCUseItemBatch();
					break;
				case "btnMax":
					//最大
					count=Data.beiBao.getBeiBaoCountById(bag.itemid);
					mc["ui_count"].max=count;
					mc["ui_count"].showCount(count);
					break;
				default:
					break;
				
			}
		}
	
		private function countChangeHandle(e:DispatchEvent):void {
			count=int((e as DispatchEvent).getInfo.count);
		}
		
		/*****************通讯***************/
		/**
		 *	拆分
		 */
		private function SCUseItemBatch():void{
			this.uiRegister(PacketSCUseItemBatch.id,SCUseItemBatchReturn);
			var client:PacketCSUseItemBatch=new PacketCSUseItemBatch();
			client.itemid=bag.itemid;
			client.num=count;
			this.uiSend(client);
		}
		private function SCUseItemBatchReturn(p:PacketSCUseItemBatch):void{
			if(p==null)return;
			if(super.showResult(p)){
				super.winClose();
			}else{
				
			}
		}

		
	}
	
}






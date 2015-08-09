package ui.view.view2.other{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import flash.net.*;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSLimitsQuantityGift;
	import nets.packets.PacketSCLimitsQuantityGift;
	
	import ui.base.vip.Vip;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;


	/**
	 * 使用次数【包裹中点击】
	 * @author andy
	 * @date   2012-12-03
	 */
	public final class UseTimes extends UIWindow {
		private var itemId:int=0;
		private const COUNT:int=10;
		private var needCoin3:int=0;
		
		private static var _instance:UseTimes;
		public static function getInstance():UseTimes{
			if(_instance==null)
				_instance=new UseTimes();
			return _instance;
		}

		public function UseTimes() {
			super(getLink(WindowName.win_use_times));
		}
		
		public function reset(v:int):void{
			itemId=v;
			super.open(true);
		}
		override protected function openFunction():void{
			init();
		}
		
		override protected function init():void {
			super.init();
			var item:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(itemId) as Pub_ToolsResModel;
			if(item==null)return;
			var drop_id:int=item.drop_id;
			needCoin3=item.tool_coin3;
			//mc["txt_desc"].htmlText=item.tool_desc;
			//12000001 限量宝石宝箱 
			//12000002 限量升星石宝箱 
			if(12000001==itemId)
				mc["mc_desc"].gotoAndStop(1);
			else
				mc["mc_desc"].gotoAndStop(2);
		
			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(drop_id) as Vector.<Pub_DropResModel>;
			if(arr==null)return;
			arrayLen=arr.length;
			for(var i:int=1;i<=COUNT;i++){
				item=null;
				child=mc["item"+i];
				if(child==null)continue;
				if(i<=arrayLen)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i-1].drop_item_id) as Pub_ToolsResModel;
				if(item!=null){
//					child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
					ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
					child["txt_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);		
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=item.tool_id;
					bag.num=arr[i-1].drop_num;
					Data.beiBao.fillCahceData(bag);
					child.data=bag;
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
				}else{
					child["uil"].unload();
					child["txt_num"].text="";
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child,false);
				}
			}
		}
		

		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnOk":
					alert.ShowMsg(Lang.getLabel("10136_usetimes",[needCoin3]),4,null,lingQu);
					break;
				case "btnPay":
					Vip.getInstance().pay();
					break;
				default :
					break;
			}			
			
		}
		
		/******通讯********/
		/**
		 *	领取
		 */
		private function lingQu():void{
			super.uiRegister(PacketSCLimitsQuantityGift.id,liqngQuReturn);
			var client:PacketCSLimitsQuantityGift=new PacketCSLimitsQuantityGift();
			client.itemid=itemId;
			super.uiSend(client);
		}
		private function liqngQuReturn(p:PacketSCLimitsQuantityGift):void{
			if(super.showResult(p)){
				//2012-12-25 领取后右上大图标消失
				if(itemId==BeiBaoSet.MO_WEN_GIFT){
					ControlButton.getInstance().setVisible("arrMoWenGift",false);
				}else if(itemId==BeiBaoSet.QIANG_HUA_GIFT){
					ControlButton.getInstance().setVisible("arrQiangHuaGift",false);
				}else{
				
				}
				super.winClose();
			}else{
			
			}
		}

		
	}
}





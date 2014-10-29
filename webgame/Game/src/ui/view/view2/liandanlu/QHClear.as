package ui.view.view2.liandanlu
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Equip_Strong_CostResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipStrongClear;
	import nets.packets.PacketSCEquipInherit;
	import nets.packets.PacketSCEquipStrongClear;
	
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;

	/**
	 *	强化清除【】
	 *  andy 2013－12－18
	 */
	public class QHClear extends UIPanel
	{
		//原装备
		private var curData:StructBagCell2;
		private var selectItem:MovieClip;
		
		private static var _instance:QHClear;
		public static function instance():QHClear{
			if(_instance==null){
				_instance=new QHClear();
			}
			return _instance;
		}
		
		public function QHClear(){
			super(this.getLink(WindowName.win_qh_clear));
		}
		override public function init():void{
			super.init();
			mc["mc_result"].mouseChildren=false;
			mc["txt_star"].mouseEnabled=false;
			Lang.addTip(mc["btnDesc"],"10172_qh",150);
			mcHandler({name:"ebtn2"});

		}	
		override public function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
		}	
		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			if(name.indexOf("ebtn")>=0){
				var who:int=int(name.replace("ebtn",""));
				type=who;
				LianDanLu.instance().showEquip(who);
				super.initBtnSelected(target,2);
				return;
			}

			//点击主装备
			if(name.indexOf("item")==0){
				if(target.data==null)return;
				if(target.data.equip_strongLevel==0){
					Lang.showMsg(Lang.getClientMsg("10032_qhclear"));
					return;
				}
				curData=target.data;
				selectItem=target as MovieClip;
				clickItem();
				return;
			}
			switch(name){	
				case "btnFenJie":
					clear();
					break;
			}
		}

		/**
		 *	点击装备 
		 */
		public function clickItem():void{
			if(curData==null)return;

			if(curData.equip_strongLevel>0){
				//带星的装备
				//mc["txt_name"].htmlText=ResCtrl.instance().getFontByColor(data.itemname,data.toolColor-1);
				ItemManager.instance().setToolTipByData(mc["mc_result"],curData,1);
				LianDanLu.instance().showStar(mc["txt_star"],curData.equip_strongLevel);
				mc["txt_1"].htmlText=curData.itemname+" ("+curData.equip_strongLevel+")";
				mc["txt_2"].htmlText=curData.itemname+" (0)";
				
				var dropDesc:String="";
				var need:Pub_Equip_Strong_CostResModel=XmlManager.localres.equipStrongCostXml.getResPath2(3,curData.equip_strongLevel) as Pub_Equip_Strong_CostResModel;
				if(need!=null){
					var dropId:int=need.drop_id;
					var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;//vip.gift_item);
					var len:int=arr.length;
					var item:Pub_ToolsResModel;
					
					for(var i:int=0;i<len;i++){
						item=XmlManager.localres.getToolsXml.getResPath(arr[i].drop_item_id) as Pub_ToolsResModel;
						if(item!=null){
							dropDesc+=item.tool_name+" X "+arr[i].drop_num+"<br/>";
						}else{
							
						}
					}
				}
				mc["txt_drop"].htmlText=dropDesc;
				mc["txt_money"].htmlText=LianDanLu.instance().showMoney(3,curData.equip_strongLevel);
				mc["txt_money_type"].htmlText=LianDanLu.instance().showMoneyType(3,curData.equip_strongLevel);
				
			}else{
				
			}
		
			
		}
		
		override public function windowClose() : void {
			// 面板关闭事件
			super.windowClose();
			
		}
		/**
		 *	 
		 */
		override protected function reset():void{
			this.curData=null;
			mc["txt_star"].text="";
			mc["txt_money"].text="";
			mc["txt_money_type"].text="";
			mc["txt_1"].text="";
			mc["txt_2"].text="";
			mc["txt_drop"].text="";
			ItemManager.instance().removeToolTip(mc["mc_result"]);

			
		}
		/**************通信**************/
		/**
		 * 
		 * 2013-12-20
		 */
		private function clear():void{
			if(curData==null){
				Lang.showMsg(Lang.getClientMsg("10015_lian_dan_lu"));
				return;
			}

			this.uiRegister(PacketSCEquipStrongClear.id,clearReturn);
			var client:PacketCSEquipStrongClear=new PacketCSEquipStrongClear();
			
			client.pos=curData.pos;
			this.uiSend(client);
		}
		private function clearReturn(p:PacketSCEquipStrongClear):void{
			if(p==null)return;
			if(super.showResult(p)){
				selectChange();
				reset();
				ItemManager.instance().showWindowEffect("effect_zhuang_bei_success",mc,205,190);
			}else{
				
			}
			
		}
		
		
		/************/
		/**
		 *	列表选中条目刷新 
		 */
		private function selectChange():void{
			if(selectItem==null)return;
			if(selectItem.data==null||selectItem.data!=curData)return;
			if(curData.equip_strongLevel>0)
				selectItem["mc_up"]["txt_star"].htmlText=curData.equip_strongLevel;
			else
				selectItem["mc_up"]["txt_star"].htmlText="";
		}
		
	}
}
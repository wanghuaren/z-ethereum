package ui.view.view2.liandanlu
{
	import common.managers.Lang;
	
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipStrongTransfer;
	import nets.packets.PacketSCEquipAwake;
	import nets.packets.PacketSCEquipStrongTransfer;
	
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;

	/**
	 *	强化转移【锻造】
	 *  andy 2013－12－18 
	 */
	public class QHMove extends UIPanel
	{
		
		//原装备
		private var curData:StructBagCell2;
		private var curItem:MovieClip;
		//目标装备
		private var desData:StructBagCell2;
		private var desItem:MovieClip;

		private static var _instance:QHMove;
		public static function instance():QHMove{
			if(_instance==null){
				_instance=new QHMove();
			}
			return _instance;
		}
		
		public function QHMove(){
			super(this.getLink(WindowName.win_qh_move));
		}
		override public function init():void{
			super.init();
			mc["txt_star"].mouseEnabled=false;
			mc["txt_star_new"].mouseEnabled=false;
			Lang.addTip(mc["btnDesc"],"10171_qh",150);
			mcHandler({name:"ebtn1"});
		}	
		override public function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
		}	
		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			
			if(name.indexOf("ebtn")>=0){
				var who:int=int(name.replace("ebtn",""));
				LianDanLu.instance().showEquip(who);
				super.initBtnSelected(target,2);
				return;
			}
			if(name.indexOf("item")>=0){
				clickItem(target,target.data);
				return;
			}
			switch(name){	
				case "btnZhuanYi":
					zhuanYi();
					break;
				default:
					break;
			}
		}
		
		/**
		 *	点击装备 
		 */
		public function clickItem(target:Object,data:StructBagCell2):void{
			if(target==null||data==null)return;
			
			if(data.equip_strongLevel>0){
				//带星的装备
				//				if(desData!=null&&data.pos==desData.pos){
				//					Lang.showMsg(Lang.getClientMsg("10157_tunshi"));
				//					return;
				//				}
				curData=data;
				curItem=target as MovieClip;
				//mc["txt_name"].htmlText=ResCtrl.instance().getFontByColor(data.itemname,data.toolColor-1);
				ItemManager.instance().setToolTipByData(mc["mc_result1"],curData,1);
				mc["txt_money"].htmlText=LianDanLu.instance().showMoney(2,curData.equip_strongLevel);
				mc["txt_money_type"].htmlText=LianDanLu.instance().showMoneyType(2,curData.equip_strongLevel);
				LianDanLu.instance().showStar(mc["txt_star"],curData.equip_strongLevel);
			}else{
				//不带星的装备
				//				if(curData!=null&&data.pos==curData.pos){
				//					Lang.showMsg(Lang.getClientMsg("10157_tunshi"));
				//					return;
				//				}
				desData=data;
				desItem=target as MovieClip;
				//mc["txt_name2"].htmlText=ResCtrl.instance().getFontByColor(data.itemname,data.toolColor-1);
				ItemManager.instance().setToolTipByData(mc["mc_result2"],desData,1);
			}
			
			//预览效果
			if(curData!=null&&desData!=null){
				var newData:StructBagCell2=new StructBagCell2();
				newData.itemid=desData.itemid;
				Data.beiBao.fillCahceData(newData);
				newData.equip_strongLevel=curData.equip_strongLevel;
				newData.strongFailed=curData.strongFailed;
				ItemManager.instance().setToolTipByData(mc["mc_result3"],newData,1);
				LianDanLu.instance().showStar(mc["txt_star_new"],curData.equip_strongLevel);
			}else{
				ItemManager.instance().removeToolTip(mc["mc_result3"]);
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
			this.desData=null;
			
			mc["txt_star"].text="";
			mc["txt_star_new"].text="";
			mc["txt_money"].text="";
			ItemManager.instance().removeToolTip(mc["mc_result1"]);
			ItemManager.instance().removeToolTip(mc["mc_result2"]);
			ItemManager.instance().removeToolTip(mc["mc_result3"]);	
		}
		
		/**************通信**************/
		/**
		 * 转移
		 * 2013-12-20 
		 */
		private function zhuanYi():void{
			if(curData==null||desData==null){
				Lang.showMsg(Lang.getClientMsg("10015_lian_dan_lu"));
				return;
			}
			this.uiRegister(PacketSCEquipStrongTransfer.id,zhuanYiReturn);
			var client:PacketCSEquipStrongTransfer=new PacketCSEquipStrongTransfer();
			
			client.srcpos=curData.pos;
			client.dstpos=desData.pos;

			this.uiSend(client);
		}
		private function zhuanYiReturn(p:PacketSCEquipStrongTransfer):void{
			if(p==null)return;
			if(super.showResult(p)){
				selectChange();
				reset();
				ItemManager.instance().showWindowEffect("effect_zhuang_bei_success",mc,210,200);
			}else{
				
			}
			
		}

		
		
		/**
		 *	列表选中条目刷新 
		 */
		private function selectChange():void{
			if(curItem==null)return;
			if(curItem.data==null||curItem.data!=curData)return;
			if(curData.equip_strongLevel>0)
				curItem["mc_up"]["txt_star"].htmlText="+"+curData.equip_strongLevel;
			else
				curItem["mc_up"]["txt_star"].htmlText="";
			
			if(desItem==null)return;
			if(desItem.data==null||desItem.data!=desData)return;
			if(desData.equip_strongLevel>0)
				desItem["mc_up"]["txt_star"].htmlText="+"+desData.equip_strongLevel;
			else
				desItem["mc_up"]["txt_star"].htmlText="";
		}
	}
}
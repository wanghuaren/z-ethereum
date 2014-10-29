package ui.view.view4.chibang
{
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.drag.MainDrag;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipStrongStoneCompose;
	import nets.packets.PacketCSEquipStrongTransfer;
	import nets.packets.PacketCSToolCompose;
	import nets.packets.PacketSCEquipAwake;
	import nets.packets.PacketSCEquipStrongStoneCompose;
	import nets.packets.PacketSCEquipStrongTransfer;
	import nets.packets.PacketSCToolCompose;
	
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *	翅膀合成【锻造】
	 */
	public class ChiBangCompose extends UIWindow
	{
		
		//原装备
		private var curData:StructBagCell2;
		private var curItem:MovieClip;
		//目标装备
		private var desData:StructBagCell2;
		private var desItem:MovieClip;

		private static var _instance:ChiBangCompose;
		public static function instance():ChiBangCompose{
			if(_instance==null){
				_instance=new ChiBangCompose();
			}
			return _instance;
		}
		
		public function ChiBangCompose(){
			super(this.getLink(WindowName.win_chi_bang_he_cheng));
		}
		override protected function init():void 
		{
			Lang.addTip(mc["btnDesc"],"10174_cb");
			showStones(mc["sp_stone"]);
			showEquip();
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD,bagAddHandler);
			mcHandler({name:"ebtn1"});
		}	
		override protected function  mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
		}	
		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			
			if(name.indexOf("ebtn")>=0){
			//	LianDanLu.instance().showEquip(4,false);
			//	super.initBtnSelected(target,1);
				return;
			}
			if(name.indexOf("item")>=0){
				clickItem(target,target.data);
				return;
			}
			switch(name){	
				case "btnBuyStone":
					NpcBuy.instance().setType(4, target.parent["mc_icon"].data,true,NpcShop.PUB_SHOP_BUY_ID,showEquip);
					break;
			
				default:
					break;
			}
		}
	
		private function heChengReturn(p:IPacket):void{
			if(super.showResult(p)){	
				//show();
				//Lang.showMsg(Lang.getClientMsg("10033_HC",[curData.itemname]));
			}else{
				
			}
		}
		private var arrHotSell:Array=[11800501,11800502,11800503];
		/**
		 *	强化石数量
		 */
		public function showStones(sp_stone:Object):void{
			
			var　sp:Sprite=new Sprite();
			var bag:StructBagCell2=null;
			var count:int=0;
			for each(var itemid:int in arrHotSell){
				child=ItemManager.instance().getStrongStoneItem(itemid) as MovieClip;
				child.mouseChildren=true;
				sp.addChild(child);
				
				bag=ItemManager.instance().setToolTip(child["mc_icon"],itemid);
				child["txt_name"].text=bag.itemname;
				child["txt_count"].text=Data.beiBao.getBeiBaoCountById(bag.itemid,true);
				
				
			}
			CtrlFactory.getUIShow().showList2(sp,1,0,40);
			sp_stone.source=sp;
			
		}
		private function bagAddHandler(e:DispatchEvent):void {
			var itemId:int=int(e.getInfo.itemid);
			if(this.arrHotSell.indexOf(itemId)>=0){
				showStones(mc["sp_stone"]);
			}	
		}
		/**
		 *	点击装备 
		 */
		public function clickItem(target:Object,data:StructBagCell2):void{
			if(target==null||data==null)return;
			if(data.sort_para1>0){
				HeChengChibang.getInstance().init(mc as MovieClip,data.itemid);
			}else{
				
			}
			

		}

		override protected function windowClose() : void {
			// 面板关闭事件
			super.windowClose();
			mc["txt_money"].text="";
			mc["txt_num"].text="";
//			mc["txt_money_type"].text="";
			ItemManager.instance().removeToolTip(mc["item1"]);
			ItemManager.instance().removeToolTip(mc["item2"]);	
		}
		/**
		 *	 
		 */
//		override protected function reset():void{
//			this.curData=null;
//			this.desData=null;
//
//			mc["txt_money"].text="";
//			mc["txt_num"].text="";
//			mc["txt_money"].text="";
//			mc["txt_money_type"].text="";
//			ItemManager.instance().removeToolTip(mc["item1"]);
//			ItemManager.instance().removeToolTip(mc["item2"]);	
//		}
//		public static const arrLimit:Array=[0,ResCtrl.EquipLimit_Strong,ResCtrl.EquipLimit_Strong,ResCtrl.EquipLimit_Strong,ResCtrl.EquipLimit_Beswallow,ResCtrl.EquipLimit_Inherit,ResCtrl.EquipLimit_ColorUp,ResCtrl.EquipLimit_Awake,ResCtrl.EquipLimit_Resolve];	
		private const defaultCount:int=24;
		private var sp_content:Sprite=null;
		private var isDrag:Boolean=false;
		private var arrBagData:Array=null;
		/**从背包获得羽毛  
		 *11800501	一级羽毛	
11800502	二级羽毛	
11800503	三级羽毛	
11800504	四级羽毛	
 
		 * @param who
		 * @param drag
		 * 
		 */
		public function showEquip():void{
			
			
			var temp:Array=[];
			arrBagData = new Array();
			for(var t:int =11800501;t<=11800504;t++)
			{
			var adarr:Array = Data.beiBao.getBeiBaoDataById(t);
			arrBagData = 	arrBagData.concat(adarr);
			}
			if(arrBagData!=null){
				var item:StructBagCell2=null;
				var len:int=arrBagData.length;
				sp_content=new Sprite();
				var cellCount:int=len<defaultCount?defaultCount:len;
				for(i=0;i<cellCount;i++){
					child=ItemManager.instance().getChiBangItem(i) as MovieClip;
					if(child==null)continue;
					child.name="item"+(i+1);
					if(i<len){
						item=arrBagData[i];
						if(isDrag){
							MainDrag.getInstance().regDrag(child);
						}else{
							MainDrag.getInstance().unregDrag(child);
						}
						child.mouseEnabled = true;
						setOneEuip(child,item);
						if(child["mc_not_show"]!=null)
							child["mc_not_show"].visible=false;
					}else{
						child.mouseEnabled = false;
						if(child["mc_not_show"]!=null)
							child["mc_not_show"].visible=true;
					}
					sp_content.addChild(child);
				}
			}
			//			panel.mc["sp_equip"].overHeight=30;
			
			sp_content.x=10;
			CtrlFactory.getUIShow().showList2(sp_content,6,0,40);
			mc["sp_equip"].source=sp_content;
			mc["sp_equip"].position=0;
		}
		
		/**
		 *	设置一个装备信息
		 */
		public function setOneEuip(child:MovieClip,item:StructBagCell2):void{
			child.mouseChildren=false;
			//child["mc_up"].gotoAndStop(type);
			if(item!=null){
				ItemManager.instance().setToolTipByData(child,item);
//				if(type==1||type==2||type==3){
//					//强化星级
//					if(item.equip_strongLevel>0){
//						child["mc_up"]["txt_star"].htmlText="+"+item.equip_strongLevel;
//					}else{
//						child["mc_up"]["txt_star"].htmlText="";
//					}
//				}else{
//					
//				}
			}else{
				
			}
		}
		/**************通信**************/
	}
	
	
}
import engine.support.IPacket;

import netc.DataKey;

import nets.packets.PacketCSEquipStrongStoneCompose;
import nets.packets.PacketCSToolCompose;
import nets.packets.PacketSCEquipStrongStoneCompose;
import nets.packets.PacketSCToolCompose;
import nets.packets.PacketSCWingLevelUp;

import ui.view.view2.liandanlu.HeCheng2;
import ui.view.view4.chibang.ChiBangCompose;


class HeChengChibang extends HeCheng2
{
	private static var  _instance:HeChengChibang;
	private const arrEquipStrong:Array=[11800501,11800502,11800503,11800504];
	public static function  getInstance():HeChengChibang{
		if(_instance==null){
			_instance=new HeChengChibang();
		}
		return _instance;
	}
	
	public function HeChengChibang()
	{
		super.arrStone=arrEquipStrong;
		super.ruleLabel="10123_liandanlu";
	}
	
	override protected function heCheng():void{
		DataKey.instance.register(PacketSCToolCompose.id,chibangheChengReturn);
		var client:PacketCSToolCompose=new PacketCSToolCompose();
		client.makeid=makeId;
		client.count=compose_count;
		DataKey.instance.send(client);
	}
	private function chibangheChengReturn(p:IPacket):void{
		super.heChengReturn(p);
		if((p as PacketSCToolCompose).tag==0){
			if(mc["mc_effect_hecheng"]!=null)
				mc["mc_effect_hecheng"].play();
			ChiBangCompose.instance().showEquip();
		}
	}
}	
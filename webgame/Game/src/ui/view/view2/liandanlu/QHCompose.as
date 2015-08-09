package ui.view.view2.liandanlu
{
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipStrongStoneCompose;
	import nets.packets.PacketCSEquipStrongTransfer;
	import nets.packets.PacketSCEquipAwake;
	import nets.packets.PacketSCEquipStrongStoneCompose;
	import nets.packets.PacketSCEquipStrongTransfer;
	
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;

	/**
	 *	强化石合成【锻造】
	 *  andy 2014－08－12 
	 */
	public class QHCompose extends UIPanel
	{
		
		//原装备
		private var curData:StructBagCell2;
		private var curItem:MovieClip;
		//目标装备
		private var desData:StructBagCell2;
		private var desItem:MovieClip;

		private static var _instance:QHCompose;
		public static function instance():QHCompose{
			if(_instance==null){
				_instance=new QHCompose();
			}
			return _instance;
		}
		
		public function QHCompose(){
			super(this.getLink(WindowName.win_qh_hc));
		}
		override public function init():void{
			super.init();
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD,bagAddHandler);
			Lang.addTip(mc["btnDesc"],"10173_qh",150);
			QH.instance().showStones(mc["sp_stone"]);
			mcHandler({name:"ebtn1"});
		}	
		override public function mcDoubleClickHandler(target:Object):void{
			var name:String=target.name;
		}	
		override public function mcHandler(target:Object):void{
			var name:String=target.name;
			
			if(name.indexOf("ebtn")>=0){
				LianDanLu.instance().showEquip(4,false);
				super.initBtnSelected(target,1);
				return;
			}
			if(name.indexOf("item")>=0){
				clickItem(target,target.data);
				return;
			}
			switch(name){	
				case "btnBuyStone":
					NpcBuy.instance().setType(4, target.parent["mc_icon"].data,true,NpcShop.PUB_SHOP_BUY_ID);
					break;
				default:
					break;
			}
		}

		private function bagAddHandler(e:DispatchEvent):void {
			var itemId:int=int(e.getInfo.itemid);
			if(QH.instance().arrHotSell.indexOf(itemId)>=0&&LianDanLu.instance().type==4){
				QH.instance().showStones(mc["sp_stone"]);
				LianDanLu.instance().showEquip(4,false);
			}	
		}
		/**
		 *	点击装备 
		 */
		public function clickItem(target:Object,data:StructBagCell2):void{
			if(target==null||data==null)return;
			
			HeChengStrong.getInstance().init(mc as MovieClip,data.itemid);
			

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

			mc["txt_money"].text="";
			mc["txt_num"].text="";
			mc["txt_money"].text="";
			mc["txt_money_type"].text="";
			ItemManager.instance().removeToolTip(mc["item1"]);
			ItemManager.instance().removeToolTip(mc["item2"]);	
		}
		
		/**************通信**************/
	}
}


import engine.support.IPacket;

import netc.DataKey;

import nets.packets.PacketCSToolCompose;
import nets.packets.PacketSCToolCompose;

import ui.frame.ItemManager;
import ui.view.view2.liandanlu.HeCheng2;
import ui.view.view2.liandanlu.LianDanLu;
import ui.view.view2.liandanlu.QH;


class HeChengStrong extends HeCheng2
{
	private static var  _instance:HeChengStrong;
	public static function  getInstance():HeChengStrong{
		if(_instance==null){
			_instance=new HeChengStrong();
		}
		return _instance;
	}
	//显示下拉内容
	private const arrEquipStrong:Array=[11900001,11900002,11900003,11900004];
	
	public function HeChengStrong()
	{
		super.arrStone=arrEquipStrong;
		super.ruleLabel="10123_liandanlu";
	}
	
	override protected function heCheng():void{
		DataKey.instance.register(PacketSCToolCompose.id,heChengReturn);
		var client:PacketCSToolCompose=new PacketCSToolCompose();
		client.makeid=makeId;
		client.count=compose_count;
		DataKey.instance.send(client);
	}
	override protected function heChengReturn(p:IPacket):void{
		super.heChengReturn(p);
		if((p as PacketSCToolCompose).tag==0){
			QH.instance().showStones(mc["sp_stone"]);
			LianDanLu.instance().showEquip(4,false);
			ItemManager.instance().showWindowEffect("effect_zhuang_bei_success",mc,210,200);
		}
	}
}	
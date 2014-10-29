package ui.base.beibao
{
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	import common.utils.drag.MainDrag;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import netc.dataset.BeiBaoSet;
	import netc.packets2.StructBagCell2;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.mainStage.UI_index;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view2.booth.Booth;
	import ui.base.jiaose.JiaoSe;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.base.npc.NpcBuy;
	import ui.base.npc.NpcShop;

	import ui.view.view6.GameAlert;

	/**
	 *	背包道具点击下拉菜单
	 *  2013-07-30 andy 
	 */
	public class BeiBaoMenu extends EventDispatcher
	{
		//悬浮
		private var mc:MovieClip=null;
		//悬浮父类
		private var mc_parent:Sprite=null;
		//最大菜单数量
		private const MAX_COUNT:int=13;
		//按钮高度
		private const BTN_MENU_HEIGHT:int=30;
		//
		private var curData:StructBagCell2=null;
		//
		private var curTarget:MovieClip=null;
		//排序
		private var arrBagMenuSort:Array=[];
		
		/**
		 *	穿上装备 
		 */
		public static const BAG_MENU_1:int=1;
		/**
		 *	脱下装备 
		 */
		public static const BAG_MENU_2:int=2;
		/**
		 *	展   示 
		 */
		public static const BAG_MENU_3:int=3;
		/**
		 *	丢   弃 【2013－10－11 出售】
		 */
		public static const BAG_MENU_4:int=4;
		/**
		 *	使   用 
		 */
		public static const BAG_MENU_5:int=5;
		/**
		 *	批量使用
		 */
		public static const BAG_MENU_6:int=6;
		/**
		 *	拆   分
		 */
		public static const BAG_MENU_7:int=7;
		/**
		 *	 锻造装备
		 */
		public static const BAG_MENU_8:int=8;
		/**
		 *	学    习 
		 */
		public static const BAG_MENU_9:int=9;
		/**
		 *	 炼    制
		 */
		public static const BAG_MENU_10:int=10;
		/**
		 *	寻    路
		 */
		public static const BAG_MENU_11:int=11;
		/**
		 *	孵  化 
		 */
		public static const BAG_MENU_12:int=12;
		/**
		 *	服用 
		 */
		public static const BAG_MENU_13:int=13;
		
		private static var _instance:BeiBaoMenu;
		public static function getInstance():BeiBaoMenu{
			if(_instance==null)
				_instance=new BeiBaoMenu();
			return _instance;
		}
		public function BeiBaoMenu()
		{
			
		}
		
		
		public function initTip():void{
			//悬浮容器父类
			mc_parent=PubData.mainUI.cartoon;
			//悬浮
			mc=GamelibS.getswflink("game_index","bag_menu") as MovieClip;
			
			if(null != mc){
			mc.name="pubMenu";
			}
			//排序数据
			arrBagMenuSort=Lang.getLabelArr("arrBagMenuSort");
			
			if(null != mc){
				
			mc.addEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
		
		/**
		 *	根据配置数据显示下拉 二进制数据
		 */
		public function showMenu(target:MovieClip):void{
			if(mc==null){
				initTip();
			}
			if(mc==null)return;
			curTarget=target;
			curData=target.data;
 			if(curData==null)return;
			var limitMenu:int=curData.menu_limit;
			if(limitMenu==0)return;
			var child:DisplayObject=null;
			
			var index:int=0;
			var padding_top:int=5;
			for(var i:int=1;i<=MAX_COUNT;i++){
				child=mc["abtn"+i];
				if(child==null)continue;
				if(BitUtil.getBitByPos(limitMenu,i)==0){
					child.visible=false;
					child.y=0;
				}else{
					//只有包裹的道具才可以穿装备
					if(i==BAG_MENU_1&&curData.pos>BeiBaoSet.BEIBAO_END_INDEX)continue;
					//只有身上的装备才可以脱装备
					if(i==BAG_MENU_2&&curData.pos<=BeiBaoSet.BEIBAO_END_INDEX)continue;
					child.visible=true;
					child.y=index*BTN_MENU_HEIGHT+padding_top;
					index++;
				}
			}
			//排序
			var len:int=arrBagMenuSort.length;
			var sort:int=0;
			for(i=1;i<=len;i++){
				child=mc["abtn"+arrBagMenuSort[i]];
				if(child==null)continue;
				if(child.visible){
					child.y=sort*BTN_MENU_HEIGHT+padding_top;
					sort++;
				}else{
;
				}
			}
			mc["mc_bg"].height=index*BTN_MENU_HEIGHT+padding_top*2;
			mc["mc_bg"].height=index*BTN_MENU_HEIGHT+padding_top*2;
			
			mc_parent.addChild(mc);
			setPostion(target);
		}
		
		private function setPostion(target:DisplayObject):void{
			var p:Point=target.parent.localToGlobal(new Point(target.x+target.width,target.y+target.height));; 
			mc.x=p.x-10;
			mc.y=p.y-10;
			if(mc_parent==null)mc_parent=PubData.AlertUI;
			if(mc_parent==null)return;
			if((mc.x+mc.width)>=mc_parent.stage.stageWidth){
				mc.x=p.x-mc.width-5;
			}
			
			if((mc.y+mc.height)>=mc_parent.stage.stageHeight){
				mc.y=p.y-mc.height-5;
			}
			
		}
		
		/**
		 *	不显示 必须的 
		 */
		public function notShow():void{
			if(mc!=null&&mc.parent!=null)mc.parent.removeChild(mc);
		}
		
		/**
		 *	点击菜单 
		 */
		private function clickHandler(me:MouseEvent):void{
			var name:String=me.target.name;
			if(curData==null)return;
			var type:int=int(name.replace("abtn",""));
			switch(type){
				case BAG_MENU_1:
					BeiBao.getInstance().clickMenuUse(curTarget);
					break;
				case BAG_MENU_2:
					takeOff(curData);
					break;
				case BAG_MENU_3:
					show(curData);
					break;
				case BAG_MENU_4:
					BeiBao.getInstance().saleToSys(curData);					
					break;
				case BAG_MENU_5:
					BeiBao.getInstance().clickMenuUse(curTarget);
					break;
				case BAG_MENU_6:
					piLiang(curData);
					break;
				case BAG_MENU_7:
					chaiFen(curData);
					break;
				case BAG_MENU_8:
					LianDanLu.instance().setType(1);
					break;
				case BAG_MENU_9:
					BeiBao.getInstance().clickMenuUse(curTarget);
					break;
				case BAG_MENU_10:
					
					break;
				case BAG_MENU_11:
					seek(curData);
					break;
				case BAG_MENU_12:
					BeiBao.getInstance().clickMenuUse(curTarget);
					break;
				case BAG_MENU_13:
					BeiBao.getInstance().clickMenuUse(curTarget);
					break;
				default:
					break;
			}
			notShow();
		}

		/**
		 *	穿装备 
		 */
		private function wear(bag:StructBagCell2):void{
			if(bag==null)return;
			BeiBao.getInstance().clickMenuUse(curData);
		}
		/**
		 *	脱装备 
		 */
		private function takeOff(bag:StructBagCell2):void{
			if(bag==null)return;
			if(bag.sort==13){
				JiaoSe.getInstance().equipOff(bag.pos);
			}else if(bag.sort==27){
				
			}else{
				
			}
		}
		/**
		 *	展示 【发送到主聊天】 
		 */
		private function show(bag:StructBagCell2):void{
			if(bag==null)return;
			BeiBao.getInstance().txtChat(bag,UI_index.chat["txtChat"]);
		}
		
		/**
		 *	丢弃  
		 */
		private function destroy(bag:StructBagCell2):void{
			if(bag==null)return;
			var alert:GameAlert=new GameAlert();
			alert.ShowMsg(Lang.getLabel("10037_bao_guo"), 4, mc, BeiBao.getInstance().destroyItem,bag.pos);
		}
		/**
		 *	批量使用  
		 */
		public function piLiang(bag:StructBagCell2):void{
			if(bag==null)return;
			//已经上架
			if(Booth.isBooth&&bag.lock){
				Lang.showMsg(Lang.getClientMsg("10143_beibao"));
				return;
			}
			//不能批量使用
			if(bag.isBatch==false){
				Lang.showMsg(Lang.getClientMsg("10145_beibao"));
				return;
			}
			BeiBaoUsedMore.getInstance().setData(bag);
		}
		/**
		 *	拆分  
		 */
		private function chaiFen(bag:StructBagCell2):void{
			if(bag==null)return;
			//已经上架
			if(Booth.isBooth&&bag.lock){
				Lang.showMsg(Lang.getClientMsg("10143_beibao"));
				return;
			}
			//不能拆分
			if(bag.num==1){
				Lang.showMsg(Lang.getClientMsg("10144_beibao"));
				return;
			}
			BeiBaoSplit.getInstance().setData(bag);
		}
		/**
		 *	寻路  
		 */
		private function seek(bag:StructBagCell2):void{
			if(bag==null)return;
			var seekId:int=bag.seek_id;
			GameAutoPath.seek(seekId);
		}
		
	}
}
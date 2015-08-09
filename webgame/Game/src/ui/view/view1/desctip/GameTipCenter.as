package ui.view.view1.desctip
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	

	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	
	import scene.event.MapDataEvent;
	
	import ui.frame.UIActMap;
	import ui.base.mainStage.UI_index;
	import ui.view.view1.fuben.FuBen;
	import ui.base.huodong.HuoDong;

	import ui.view.view2.other.ExpAdd;
	import ui.view.view2.other.ExpiredTip;
	import ui.base.jineng.JiNengMain;
	import ui.view.view6.GameAlert;
	import ui.view.view7.UI_Exclamation;
	import ui.view.view7.UI_ExclamationCenter;

	/**
	 *	消息提示【中间按钮】
	 *  andy 2013-06-20
	 */
	public class GameTipCenter
	{
		private static var Pool : Array = [];
		private static var List : Array = [];
		private static var waitingIcoin:Array=[];//等待显示的信息
		
		//private static var panel : Sprite  = UI_index.indexMC;
		private static var  isShow:Boolean=true;
		
		private static function get panel():Sprite
		{
			//return UI_index.indexMC;
			return UI_ExclamationCenter.instance.mc;
		}
		
		private static var _instance:GameTipCenter;
		public static function get instance():GameTipCenter
		{
			if (null == _instance)
			{
				_instance=new GameTipCenter();
			}
			
			return _instance;
		}

		public function GameTipCenter()
		{
			init();
		}
		/**
		 *	初始化 
		 *  2013-06-21
		 */
		private function init():void{
			//技能
			Data.myKing.addEventListener(MyCharacterSet.LEVEL_UPDATE, me_lvl_up);
			//技能天赋
			Data.myKing.addEventListener(MyCharacterSet.SKILL_POINT_UPD,SKILL_POINT_UPD_HAND);
		}
		
		public function chkSkillTipCenter():void{
//			me_lvl_up();
//			SKILL_POINT_UPD_HAND();
		}
		private function me_lvl_up(e:DispatchEvent=null):void
		{
			if(Data.skill.hasUp())
			{
				addTipButton(null,WarningIconCenter.JI_NENG);
			}
		}	
		private function SKILL_POINT_UPD_HAND(e:DispatchEvent=null):void
		{
			
		}	
		/**
		*    type 显示类型
		 *   Func 有一个返回参数 1代表确认 0代表取消
		*/
		public function addTipButton(Func : Function,type : int,msg:String="",sn:Object=1) : void {
			return;
			var icon : WarningIconCenter = null;
			if(type<=0)type=1;
				
			//相同的只出现一个
			if(isExistTip(type))return;
			
			if(Pool.length > 0) {
				icon = Pool.shift() as WarningIconCenter;
			} else {
				icon = new WarningIconCenter();		
			}
			Lang.addTip(icon,"warningiconcenter_"+type,150);
			icon.setIcon(type);
			icon.Func = Func;
			icon.msg = msg;

			icon.sn = sn;
			icon.buttonMode = true;
			
			icon.addEventListener(Event.REMOVED_FROM_STAGE, REMOVED_FROM_STAGE);
			icon.addEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN);
			

			//界面飞出信息个数，暂定15个，
			if(List.length>=15){
				waitingIcoin.push(icon);
			}else{
				addToPanel(icon);
				UpdateList(icon);
			}
		}
		
		//添加至面板
		private  function addToPanel(icon:WarningIconCenter):void{
			List.push(icon);
			icon.visible=isShow;
			panel.addChild(icon);
		} 
		//刷新列表
		public function UpdateList(icon : WarningIconCenter = null) : void {
			if(icon!=null)icon.x = GameIni.MAP_SIZE_W;
			var xx:int;
			for(var s:* in List) {
				var IC : WarningIconCenter = List[s] as WarningIconCenter;
				IC.y = GameIni.MAP_SIZE_H-208;
				xx = 330 + IC.width * s;
				TweenLite.to(IC, 1, {x:xx});
			}
		}
		/**
		 *	是否有消息 
		 */
		public function isHave():Boolean{
			if(List==null)return false;
			return List.length>0?true:false;
		}
		
		private function REMOVED_FROM_STAGE(e : Event) : void {
			var icon : WarningIconCenter = e.currentTarget as WarningIconCenter;
			icon.removeEventListener(Event.REMOVED_FROM_STAGE, REMOVED_FROM_STAGE);
			icon.removeEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN);
			icon.Func = null;
			Pool.push(icon);
			List.splice(List.indexOf(icon), 1);
			
			//如果有等待的信息，
			icon=null;
			if(waitingIcoin.length>0){
				icon=waitingIcoin.shift();
				addToPanel(icon);
			}
			UpdateList(icon);
		}
		
		private function MOUSE_DOWN(e : MouseEvent) : void {
			var icon : WarningIconCenter = e.currentTarget as WarningIconCenter;
			switch(icon.leixing){
				case 1:
					//JiNengMain.instance.setType(1,true);
					JiNengMain.instance.open(true);
					break;
				case 2:
					//
					//JiNengMain.instance.setType(2,true);
					JiNengMain.instance.open(true);
					break;
				case 3:
						break;
				case 4:
					break;
				default:
					break;
			}
			icon.parent.removeChild(icon);
		}
		
		public function removeIcon(sn:int):void{
			for each(var wi:WarningIconCenter in List){
				if(wi!=null&&wi.parent!=null&&wi.sn == sn){
					wi.parent.removeChild(wi);
				}
			}
		}

		/**
		 *	是否显示警告信息 【进入剧情不显示】
		 *  @2012-08-14 andy 
		 */
		public function showTip(v:Boolean=true):void{
			isShow=v;
			for each(var wi:WarningIconCenter in List){
				wi.visible=isShow;
			}
		}
		
		/**
		 *	提示是否存在
		 *  @2013-06-21 andy 
		 */
		public function isExistTip(type:int):Boolean{
			var ret:Boolean=false;
			for each(var wi:WarningIconCenter in List){
				if(wi.leixing==type){
					ret=true;
					break;
				}				
			}
			return ret;
		}
	}
}
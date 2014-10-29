package ui.view.view2.other{
	import common.managers.Lang;
	
	import flash.events.TextEvent;
	import flash.net.*;
	
	import netc.Data;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view4.yunying.ZhiZunVIP;


	/**
	 * 经验加成【世界等级-角色等级>=10触发】
	 * @author andy
	 * @date   2012-12-13
	 */
	public final class ExpAdd  {
		public var worldLevel:int=40;
		private var myLevel:int=0;
		/**
		 *	经验加成需要玩家等级 
		 */
		public static const LEVEL_NEED:int=35;
		/**
		 *	与世界等级差值 
		 */
		public static const LEVEL_OFF:int=15;
		
		private static var _instance:ExpAdd;
		public static function getInstance():ExpAdd{
			if(_instance==null)
				_instance=new ExpAdd();
			return _instance;
		}
		public function ExpAdd() {
//			super(getLink(WindowName.win_exp_add));
		}
		/**
		 *	@param level 世界等级 
		 */
		public function setWorldLevel(level:int):void{
			worldLevel=level;
		}

		public  function getStringShiJieDengJi():String {
//			super.init();
			var cha:int=worldLevel-Data.myKing.level;
			//增加200%经验
			var exp_rate:int=(cha+Data.myKing.Vip)*10;
			//世界经验显示
			if(worldLevel<=Data.myKing.level){
				cha = Data.myKing.level - worldLevel
				return Lang.getLabel("10140_expaddCha",[worldLevel,cha]);
			}
			return Lang.getLabel("10140_expadd",[worldLevel,cha,exp_rate,Data.myKing.Vip]);
		}

		/**
		 *	是否可以显示经验加成 
		 */
		public function isShow():Boolean{
			if(Data.myKing.level<=LEVEL_NEED)return false;
			if(worldLevel-Data.myKing.level<LEVEL_OFF)return false;
			myLevel=Data.myKing.level;
			return true;
		}
	}
}





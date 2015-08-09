package ui.view.view1.desctip{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Action_DescResModel;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import scene.event.MapDataEvent;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import world.WorldEvent;

	/**
	 * @author andy
	 * 消息提示按钮【中心】
	 */
	public final class WarningIconCenter extends Sprite{
		//技能升级
		public static const JI_NENG:int=1;
		//技能天赋加点
		public static const JI_NENG_TIAN_FU:int=2;
		//宠物天赋加点
		public static const PET_TIAN_FU:int=3;
		//神兵诀提示
		public static const SHEN_BING:int=4;
		
		
		/**
		 *	参数 
		 */
		public var sn:Object;
		public var leixing:int=1;
		/**
		 *	回调函数 
		 */
		public var Func:Function =null;
		public var msg:String;
		private var instance:MovieClip =null;
		public function WarningIconCenter():void{
			instance=GamelibS.getswflink("game_index","WarningIconCenter") as MovieClip;
		
			if(instance==null)return;
				
			instance.mouseEnabled = false;
			instance.mouseChildren = false;
			instance.tabChildren=false;
			
			this.addChild(instance);
			
			
		}


		public function setIcon(warningIcon:int):void{
			leixing = warningIcon;
			if(instance==null)return;
			instance.gotoAndStop(warningIcon);
		}
	}
}

package ui.view.view7
{
	import common.config.GameIni;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_MessagePanel3  extends UIWindow
	{
		
		private static var _instance:UI_MessagePanel3;
		
		public static function get instance():UI_MessagePanel3
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_MessagePanel3):void
		{
			_instance = value;
		}
		
		public function UI_MessagePanel3(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			super(DO, null, 1, false);
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
		}
		
		override protected function init():void
		{					
			resize();
			
		}
		
		public function resize():void
		{
			var w:int = GameIni.MAP_SIZE_W;
			//340来自youXiaoJiaoMsg2.createTf
			this.x=w/2 - this.width/2 - 340/2;//this.width/2;// - 90/2;
			
			var h:int = GameIni.MAP_SIZE_H;
			
			this.y=h-220;
			//this.y = 486;
			
		}
		
		
		
		override public function mcHandler(target:Object):void
		{
			
			UI_index.instance.mcHandler(target);
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		override public function clickToTop():Boolean
		{
			return false;
		}
		
		
	}
	
	
	
	
	
	
	
	
	
}

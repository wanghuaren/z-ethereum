package ui.view.view7
{
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_Duiwu  extends UIWindow
	{
		
		private static var _instance:UI_Duiwu;
		
		public static function get instance():UI_Duiwu
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_Duiwu):void
		{
			_instance = value;
		}
		
		public function UI_Duiwu(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			super(DO, null, 1, false);
			
			this.canDrag = false;
		}
		
		override protected function init():void
		{		
			this.x = 4 + 6 + 2;
			this.y = 173;//163;//90;
		}
		
		
		override public function mcHandler(target:Object):void
		{
			
			UI_index.instance.mcHandler(target);
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		
	}
	
	
	
	
	
	
	
	
	
}

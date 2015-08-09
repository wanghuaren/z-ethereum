package ui.view.view7
{
	import flash.display.DisplayObject;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_MenuHead  extends UIWindow
	{
		
		private static var _instance:UI_MenuHead;
		
		public static function get instance():UI_MenuHead
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_MenuHead):void
		{
			_instance = value;
		}
		
		public function UI_MenuHead(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			super(DO, null, 1, false);
			
		}
		
		
		override public function mcHandler(target:Object):void
		{
			
			UI_index.instance.mcHandler(target);
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		override protected function init():void
		{		
			
			
		}
		
		
		
		
	}

	
}



package ui.view.view7
{
	import flash.display.DisplayObject;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_ScalePanel  extends UIWindow
	{
		
		private static var _instance:UI_ScalePanel;
		
		public static function get instance():UI_ScalePanel
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_ScalePanel):void
		{
			_instance = value;
		}
		
		public function UI_ScalePanel(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			super(DO, null, 1, false);
			mouseEnabled = false;
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

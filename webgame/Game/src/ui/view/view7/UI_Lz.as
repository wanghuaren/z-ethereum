package ui.view.view7
{
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_Lz  extends UIWindow
	{
		
		private static var _instance:UI_Lz;
		
		public static function get instance():UI_Lz
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_Lz):void
		{
			_instance = value;
		}
		
		public function UI_Lz(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			super(DO, null, 1, false);
			
		}
		
		override protected function init():void
		{		
			this.x = 167;
			this.y = 135;
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
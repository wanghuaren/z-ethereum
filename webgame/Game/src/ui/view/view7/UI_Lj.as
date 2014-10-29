package ui.view.view7
{
	import flash.display.DisplayObject;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	/**
	 * 连击
	 * @author steven guo
	 * 
	 */	
	public class UI_Lj extends UIWindow
	{
		private static var _instance:UI_Lj;
		
		public static function get instance():UI_Lj
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_Lj):void
		{
			_instance = value;
		}
		
		public function UI_Lj(DO:DisplayObject)
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
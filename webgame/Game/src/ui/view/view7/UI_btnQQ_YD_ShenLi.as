package ui.view.view7
{
	import flash.display.DisplayObject;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_btnQQ_YD_ShenLi extends UIWindow
	{
		
		private static var _instance:UI_btnQQ_YD_ShenLi;
		
		public static function get instance():UI_btnQQ_YD_ShenLi
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_btnQQ_YD_ShenLi):void
		{
			_instance = value;
		}
		
		public function UI_btnQQ_YD_ShenLi(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			DO.x = 0;
			DO.y = 0;
			
			super(DO, null, 1, false);
			
		}
		
		override protected function init():void
		{		
			this.x = 373;
			this.y = 17;
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

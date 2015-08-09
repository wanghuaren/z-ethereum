package ui.view.view7
{
	import flash.display.DisplayObject;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_JingYan  extends UIWindow
	{
		
		private static var _instance:UI_JingYan;
		
		public static function get instance():UI_JingYan
		{
			return _instance;
		}
		
		public static function hasInstance():Boolean
		{
			if(null == _instance)
			{
				return false;
			}
			
			return true;
		
		}
		
		public static function setInstance(value:UI_JingYan):void
		{
			_instance = value;
		}
		
		public function UI_JingYan(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			
			super(DO, null, 1, false);			
	
			
		}
		
		override protected function init():void
		{		
			
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

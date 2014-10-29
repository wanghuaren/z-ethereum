package ui.view.view7
{
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;

	/**
	 *	界面提示容器
	 *  2013-06-20 andy 
	 */
	public class UI_ExclamationCenter  extends UIWindow
	{
		
		private static var _instance:UI_ExclamationCenter;
		
		public static function get instance():UI_ExclamationCenter
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_ExclamationCenter):void
		{
			_instance = value;
		}
		
		public function UI_ExclamationCenter(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			if(DO as DisplayObjectContainer)
			{
				var DOC:DisplayObjectContainer = DO as DisplayObjectContainer;
					
				while(DOC.numChildren > 0)
				{
					DOC.removeChildAt(0);
				}
			
			}
			
			
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

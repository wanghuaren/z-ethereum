package ui.view.view7
{
	import flash.display.DisplayObject;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	public class UI_MessagePanel2  extends UIWindow
	{
		private static var _instance:UI_MessagePanel2;
		public static function get instance():UI_MessagePanel2
		{
			return _instance;
		}
		public static function setInstance(value:UI_MessagePanel2):void
		{
			_instance = value;
		}
		public function UI_MessagePanel2(DO:DisplayObject)
		{
			//项目转换
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
	}
}

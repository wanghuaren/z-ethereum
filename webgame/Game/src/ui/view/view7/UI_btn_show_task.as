package ui.view.view7
{
	import common.utils.AsToJs;
	
	import flash.display.DisplayObject;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_btn_show_task extends UIWindow
	{
		
		private static var _instance:UI_btn_show_task;
		
		public static function get instance():UI_btn_show_task
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_btn_show_task):void
		{
			_instance = value;
		}
		
		public function UI_btn_show_task(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
//			DO.x = 0;
//			DO.y = 0;
			
			super(DO, null, 1, false);
			
		}
		
		override protected function init():void
		{		
//			this.x = 422;
//			this.y = 10;
		}
		
		
		override public function mcHandler(target:Object):void
		{
			//
			var target_name:String = target.name;
			
			
			switch (target_name)
			{					
				case "btn_show_task_1":
					AsToJs.showTask();
					break;
				default:"";
			}
			
			
			UI_index.instance.mcHandler(target);
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		
	}
	
	
	
	
	
	
	
	
	
}

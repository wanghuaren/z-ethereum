package ui.view.view7
{
	import common.config.GameIni;
	
	import flash.display.DisplayObject;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	
	public class UI_Mc_Fu_Ben  extends UIWindow
	{
		
		private static var _instance:UI_Mc_Fu_Ben;
		
		public static function get instance():UI_Mc_Fu_Ben
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
		
		public static function setInstance(value:UI_Mc_Fu_Ben):void
		{
			_instance = value;
		}
		
		public function UI_Mc_Fu_Ben(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
				
			DO.x = 0;
			DO.y = 0;
			
			super(DO, null, 1, false);
			
		}
		
		override protected function init():void
		{		
			this.x = GameIni.MAP_SIZE_W;
			this.y = 36;
			
			//(mc as MovieClip).gotoAndStop(3);
		}
		
		
		
		override public function mcHandler(target:Object):void
		{
			//
			var target_name:String = target.name;
			
			UI_Mrt.instance.mcHandler(target);
			//UI_index.instance.mcHandler(target);
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		
		
	}
	
	
	
	
	
	
	
	
	
}
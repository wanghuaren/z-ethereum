package ui.view.view7
{
	import common.config.GameIni;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_Mc_Mai_Zuan  extends UIWindow
	{
		
		private static var _instance:UI_Mc_Mai_Zuan;
		
		public static function get instance():UI_Mc_Mai_Zuan
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_Mc_Mai_Zuan):void
		{
			_instance = value;
		}
		
		public function UI_Mc_Mai_Zuan(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			DO.x = 0;
			DO.y = 0;
			
			super(DO, null, 1, false);
			
			var _mc:MovieClip = DO as MovieClip;
			if(GameIni.PF_3366 == GameIni.pf())
			{
				//蓝钻
				_mc.gotoAndStop(2);
			}
			else
			{
				//黄钻
				_mc.gotoAndStop(1);
			}
			
		}
		
		override protected function init():void
		{		
			this.x = 340;
			this.y = 25;
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

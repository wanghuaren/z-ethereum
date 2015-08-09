package ui.view.view7
{
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_BtnLong  extends UIWindow
	{
		
		private static var _instance:UI_BtnLong;
		
		public static function get instance():UI_BtnLong
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_BtnLong):void
		{
			_instance = value;
		}
		
		public function UI_BtnLong(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			//DO.x = 0;
			//DO.y = 0;
			
			if(DO as SimpleButton)
			{
				var p:MovieClip = new MovieClip();
				p.addChild(DO);
				p.name = DO.name;
				
				DO = p;
			
			}
				
			super(DO, null, 1, false);			
			
			//this.x = 1;
			//this.y = 346;
			
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

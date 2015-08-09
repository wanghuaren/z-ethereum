package ui.view.view7
{
	import common.config.PubData;
	
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	
	import scene.action.hangup.GamePlugIns;
	
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_AutoFightHead  extends UIWindow
	{
		
		private static var _instance:UI_AutoFightHead;
		
		public static function get instance():UI_AutoFightHead
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_AutoFightHead):void
		{
			_instance = value;
		}
		
		public function UI_AutoFightHead(DO:DisplayObject)
		{
			
			UIMovieClip.currentObjName=null;
			
			super(DO, null, 1, false);
			
		}
		
		
		override public function mcHandler(target:Object):void
		{
			//
			var target_name:String = target.name;
			
			switch (target_name)
			{					
				case "btnAutoFightCancel":
					if (GamePlugIns.getInstance().running)
					{
						GamePlugIns.getInstance().stop();
					}
					break;
				default:"";
			}
			
			
			UI_index.instance.mcHandler(target);
			
		}
				
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		override public function clickToTop():Boolean
		{
			return false;
		}
				
		override protected function init():void
		{	
			var win_UI_index:int=PubData.AlertUI.getChildIndex(UI_Mrb.instance);
			
						
			PubData.AlertUI.addChildAt(this, win_UI_index + 1);
			//
			
			
		}
		
		
		
		
	}
	
	
}



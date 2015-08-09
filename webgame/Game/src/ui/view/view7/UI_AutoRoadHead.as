package ui.view.view7
{
	import common.config.PubData;
	
	import ui.frame.UIMovieClip;
	
	import flash.display.DisplayObject;
	
	import netc.Data;
	import netc.DataKey;
	
	import nets.packets.PacketCSPlayerMove;
	import nets.packets.PacketCSPlayerMoveStop;
	
	import scene.manager.SceneManager;
	
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	
	public class UI_AutoRoadHead  extends UIWindow
	{
		
		private static var _instance:UI_AutoRoadHead;
		
		public static function get instance():UI_AutoRoadHead
		{
			return _instance;
		}
		
		public static function setInstance(value:UI_AutoRoadHead):void
		{
			_instance = value;
		}
		
		public function UI_AutoRoadHead(DO:DisplayObject)
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
				case "btnAutoRoadCancel":
					
					var p:PacketCSPlayerMoveStop = new PacketCSPlayerMoveStop();
					p.mapid = SceneManager.instance.currentMapId;
					p.posx = Data.myKing.king.mapx;
					p.posy = Data.myKing.king.mapy;
					DataKey.instance.send(p);
					
					//
					Data.myKing.king.getSkin().getHeadName().setAutoPath = false;
					
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



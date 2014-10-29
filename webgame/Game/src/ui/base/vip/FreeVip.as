package ui.base.vip
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import common.config.GameIni;
	
	import netc.Data;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.npc.NpcShop;
	import ui.base.vip.Vip;
	
	import common.managers.Lang;


	/**
	 * 试用VIP	
	 * @author andy
	 * @date   2012-10-10
	 */
	public final class FreeVip extends UIWindow {
		//private var itemId:int=0;

		private static var _instance:FreeVip;
		public static function getInstance():FreeVip{
			if(_instance==null)
				_instance=new FreeVip();
			return _instance;
		}

		public function FreeVip() {
//			super(getLink(WindowName.win_vip_free));
		}
		

		
		override protected function init():void {
			super.init();
//			this.x=20;
//			this.y=120;
		}
		

		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnIKnow":
					super.winClose();
					break;
			}			
			
		}
		
		/******通讯********/

	}
}





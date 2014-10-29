package ui.view.view2.other{
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import flash.events.TextEvent;
	import flash.net.*;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.renwu.Renwu;
	import ui.view.view2.NewMap.TransMap;
	
	import world.WorldEvent;


	/**
	 * Pk提示
	 * @author andy
	 * @date   2014-01-14
	 */
	public final class PKTiShi extends UIWindow {		
		private static var _instance:PKTiShi;
		public static function getInstance():PKTiShi{
			if(_instance==null)
				_instance=new PKTiShi();
			return _instance;
		}
		public function PKTiShi() {
			super(getLink(WindowName.win_gong_ji_mo_shi));
		}

		override protected function init():void {
			super.init();
			
		}

		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnclose":
//					var seekId:int=30100027;
//					var te:TextEvent=new TextEvent(TextEvent.LINK);
//					te.text="1@" + seekId;
//					Renwu.textLinkListener_(te);
					super.winClose();
					break;
				default:
					break;
			}			
			
		}

		
	}
}





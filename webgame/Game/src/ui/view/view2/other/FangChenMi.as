package ui.view.view2.other{
	import common.config.GameIni;
	import common.managers.Lang;
	
	import flash.net.*;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;


	/**
	 * 防沉迷
	 * @author andy
	 * @date   2013-08-06
	 */
	public final class FangChenMi extends UIWindow {
		
		private static var _instance:FangChenMi;
		public static function getInstance():FangChenMi{
			if(_instance==null)
				_instance=new FangChenMi();
			return _instance;
		}
		public function FangChenMi() {
			super(getLink(WindowName.win_fang_chen_mi));
		}
		public function setData(v:int):void{
			type=v;
			super.open();
		}
		
		override protected function init():void {
			super.init();
			//玩家警告通知类型(1为3小时内每小时通知，2为3小时满通知，3为4-5小时通知，4为5-6小时通知)
			switch (type)
			{
				case 1:
					mc["txt"].text=Lang.getLabel("20028_UIMessage");
					break;
				case 2:
					mc["txt"].text=Lang.getLabel("20029_UIMessage");
					break;
				case 3:
					mc["txt"].text=Lang.getLabel("20030_UIMessage");
					break;
				case 4:
					mc["txt"].text=Lang.getLabel("20031_UIMessage");
					break;
				default:
					break;
			}
		}


		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnOk":
					//
					GameIni.authorized();
					super.winClose();
					break;

			}			
		}
		
		override public function winClose():void{
			super.winClose();
			
		}
		
		
	}
}





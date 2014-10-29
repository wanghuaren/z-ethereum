package ui.base.vip
{
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.bangpai.BangPaiMain;
	import ui.base.renwu.Renwu;
	import ui.base.huodong.HuoDong;
	
	public class NoWuHun extends UIWindow
	{
		private static var _instance:NoWuHun;
		public static function getInstance():NoWuHun{
			if(_instance==null)
				_instance=new NoWuHun();
			return _instance;
		}
		
		public function NoWuHun()
		{
			//super(getLink(WindowName.win_no_wu_hun_dian));
		}
		
		override protected function init():void {
			super.init();
//			super.sysAddEvent(mc,TextEvent.LINK,linkHandle);
//			mc["txt_biao"].htmlText=Renwu.getChuanSongText(30100149);
//			mc["txt_dou"].htmlText=Renwu.getChuanSongText(30100258);
		}
		
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
			switch(target.name) {
				case "mcMainTask":
					BangPaiMain.instance.type = 2;
					BangPaiMain.instance.open();
					break;
				
				case "mcPk":
//					HuoDong.instance().setType(3);
					break;
				
				case "btnMainTask":
					//任务
					//Renwu.instance().open();
					BangPaiMain.instance.type = 2;
					BangPaiMain.instance.open();
					break;
				case "btnBangPai":
					//帮派任务
					BangPaiMain.instance.type = 2;
					BangPaiMain.instance.open();
					break;
				case "btnPK":
					//华山论剑
					HuoDong.instance().setType(3);
					break;
				default:
					break;
			}
			
			if(name=="btnMainTask"||name=="btnBangPai"||
				name=="btnPK" || name == "mcPk" || name == "mcMainTask")
			{
				super.winClose();
			}
		}
		
		private function linkHandle(e:TextEvent):void{
			//传送
			//			if(e.text.indexOf("@")>=0){
			//				Renwu.textLinkListener_(e);
			//				return;
			//			}
			
		}
		
	}
}


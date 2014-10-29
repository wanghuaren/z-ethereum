package ui.base.vip
{
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import ui.frame.UIMovieClip;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.*;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.packets2.PacketSCPayChangeMoney2;
	
	import nets.packets.PacketCSPayChangeMoney;
	import nets.packets.PacketSCPayChangeMoney;
	
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	import ui.frame.WindowName;
	import ui.base.renwu.Renwu;
	import ui.view.view2.NewMap.DiGongMap;
	import ui.view.view2.NewMap.TransMap;
	import ui.base.huodong.HuoDong;
	import ui.view.view2.other.ControlButton;
	
	import world.FileManager;

	
	/**
	 * 银两不足
	 * @author andy
	 * @date   2013-09-06
	 */
	public final class NoYueLi extends UIWindow {

		
		private static var _instance:NoYueLi;
		public static function getInstance():NoYueLi{
			if(_instance==null)
				_instance=new NoYueLi();
			return _instance;
		}
		public function NoYueLi() {
			super(getLink(WindowName.win_no_yueli));
		}
		
		override protected function init():void {
			super.init();
//			super.sysAddEvent(mc,TextEvent.LINK,linkHandle);
//			mc["txt_huan_ren_wu"].htmlText=Renwu.getChuanSongText(Data.myKing.campid==2?30100019:30100049);
//			mc["txt_da_bao"].htmlText=Renwu.getChuanSongText(30100134);
		}
		
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
			switch(target.name) {
				case "btnDuiHuan":
				case "btnDuiHuan1":	
					DuiHuanYueLi.getInstance().open(true);
					break;	
				case "btnTask":
					//任务
				case "btnMainTask":
					//任务
					Renwu.instance().open();
					break;
				case "btnDayTask":
					//每日任务
					HuoDong.instance().setType(2);
					break;
				case "btnPK":
					//华山论剑
					HuoDong.instance().setType(3);
					break;
				default:
					break;
			}
			
			if(name=="btnDuiHuan"||name=="btnTask"||name=="btnMainTask"||
				name=="btnDayTask"||name=="btnPK"){
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

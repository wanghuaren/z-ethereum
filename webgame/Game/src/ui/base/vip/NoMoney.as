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
	 * @date   2012-08-09
	 */
	public final class NoMoney extends UIWindow {

		
		private static var _instance:NoMoney;
		public static function getInstance():NoMoney{
			if(_instance==null)
				_instance=new NoMoney();
			return _instance;
		}
		public function NoMoney() {
			super(getLink(WindowName.win_no_money));
		}
		
		public function setType(v:int,must:Boolean=false):void{			
			type=v;
			super.open(must);
		}
		
		override protected function init():void {
			super.init();
			super.sysAddEvent(mc,TextEvent.LINK,linkHandle);
			//2013-12-30 银两不足，银两来源
			if(type==0)type=1;
			mc["mc_title"].gotoAndStop(type);
			mc["txt_biao"].htmlText=Renwu.getChuanSongText(30100149);
			mc["txt_kuang"].htmlText=Renwu.getChuanSongText(30100111);
		}
		
		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnDuiHuan":
				case "btnDuiHuan1":
					DuiHuan.getInstance().open(true);
					break;	
				case "btnTask":
					//任务
					Renwu.instance().open(true);
					break;
				default:
					break;
			}
		}

		private function linkHandle(e:TextEvent):void{
			//传送
			if(e.text.indexOf("@")>=0){
				Renwu.textLinkListener_(e);
				return;
			}

		}

	}
}

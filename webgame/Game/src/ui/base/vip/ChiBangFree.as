package ui.base.vip
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	;
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
	import ui.view.view4.yunying.ZhiZunVIP;
	
	import world.FileManager;

	
	/**
	 * 免费翅膀
	 * @author andy
	 * @date   2012-12-21
	 */
	public final class ChiBangFree extends UIWindow {

		
		private static var _instance:ChiBangFree;
		public static function getInstance():ChiBangFree{
			if(_instance==null)
				_instance=new ChiBangFree();
			return _instance;
		}
		public function ChiBangFree() {
			super(getLink(WindowName.win_chibang_free));
		}
		
		override protected function init():void {
			super.init();

		}
		
		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnBuy":
//					Vip.getInstance().pay();
					ChongZhi.getInstance().open();
					super.winClose();
					break;	

			}
		}


	}
}

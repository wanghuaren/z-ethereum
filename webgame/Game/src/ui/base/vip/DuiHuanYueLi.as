package ui.base.vip
{
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ChangeResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_VipResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import ui.frame.UIMovieClip;
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.TextField;
	
	
	import netc.Data;
	import netc.packets2.PacketSCPayChangeMoney2;
	
	import nets.packets.PacketCSPayChangeExp2;
	import nets.packets.PacketCSPayChangeMoney;
	import nets.packets.PacketSCPayChangeExp2;
	import nets.packets.PacketSCPayChangeMoney;
	
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.yunying.ZhiZunVIP;
	
	import world.FileManager;
	
	
	/**
	 * 阅历兑换
	 * @author andy
	 * @date   2013-09-06
	 */
	public final class DuiHuanYueLi extends UIWindow {
		//【兑换元宝】
		private var exchangeCoin:int=0;
		//最大值
		private var exchangeCoinMax:int=10000;
		//每次可以兑换的阅历
		private var exchangeGold:int=100;
		
		private static var _instance:DuiHuanYueLi;
		public static function getInstance():DuiHuanYueLi{
			UIMovieClip.currentObjName=null;
			if(_instance==null)
				_instance=new DuiHuanYueLi();
			return _instance;
		}
		public function DuiHuanYueLi(obj:Object=null) {
			super(getLink(WindowName.win_dui_huan_yueli),obj);
		}
		
		override protected function init():void {
			super.init();
			super.uiRegister(PacketSCPayChangeExp2.id,changeReturn);
			super.sysAddEvent(mc["ui_count"],MoreLess.CHANGE,countChangeHandle);
			mc["ui_count"].max=exchangeCoinMax;
			setTimes(1);
			
		}
		
		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnDuiHuan":
					duiHuanConfirm();
					break;	
				case "btnMax":
					setTimes(exchangeCoinMax);
					break;
				default:
					break;
			}
		}
		private function countChangeHandle(e:DispatchEvent):void {
			var count:int=int((e as DispatchEvent).getInfo.count);
			mc["txt_need"].htmlText=Lang.getLabel("10225_yueli",[count,count*exchangeGold]);
			exchangeCoin=count;
		}
		
		
		/**
		 *	兑换确认 
		 */
		private function duiHuanConfirm():void{
			duiHuan();
		}
		/**
		 *	兑换 
		 */
		private function duiHuan():void{
			var client:PacketCSPayChangeExp2=new PacketCSPayChangeExp2();
			//2013-10-15 role做为兑换次数使用
			//2013-10-23 role做为兑换元宝数量
			client.role=exchangeCoin;
			uiSend(client);
			
		}
		private function changeReturn(p:PacketSCPayChangeExp2):void{
			if(super.showResult(p)){
				Data.myKing.ExchangCount=p.times;
				
			}else{
				
			}
		}
		
		override public function winClose():void
		{
			super.winClose();
		}
		private function payFunction():void{
			Vip.getInstance().pay();
		}
		
		private function setTimes(cnt:int):void{
			exchangeCoin=cnt;
			mc["ui_count"].showCount(exchangeCoin);
		}
		
	}
}

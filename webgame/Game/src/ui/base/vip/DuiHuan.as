package ui.base.vip
{
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.xmlres.GameData;
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
	
	import nets.packets.PacketCSPayChangeMoney;
	import nets.packets.PacketSCPayChangeMoney;
	
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.yunying.ZhiZunVIP;
	
	import world.FileManager;

	
	/**
	 * 银两兑换
	 * @author andy
	 * @date   2012-04-12
	 */
	public final class DuiHuan extends UIWindow {
		//【兑换元宝】
		private var exchangeCoin:int=0;
		//最大值
		private var exchangeCoinMax:int=10000;
		//每次可以兑换的银两数
		private var exchangeGold:int=1000;
		;
		
		private static var _instance:DuiHuan;
		public static function getInstance():DuiHuan{
			UIMovieClip.currentObjName=null;
			if(_instance==null)
				_instance=new DuiHuan();
			return _instance;
		}
		public function DuiHuan(obj:Object=null) {
			super(getLink(WindowName.win_dui_huan),obj);
		}
		
		override protected function init():void {
			super.init();
			super.uiRegister(PacketSCPayChangeMoney.id,changeReturn);
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
			mc["txt_need"].htmlText=Lang.getLabel("10051_vip",[count,count*exchangeGold]);
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
			var client:PacketCSPayChangeMoney=new PacketCSPayChangeMoney();
			//2013-10-15 role做为兑换次数使用
			//2013-10-23 role做为兑换元宝数量
			client.role=exchangeCoin;
			uiSend(client);
			
		}
		private function changeReturn(p:PacketSCPayChangeMoney2):void{
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

		/**
		 *	还剩余多少次数可兑换 
		 *  @2012-08-12
		 */
		public function getRemainTimes():int{
			var ret:int=100;

			return ret;
		}
	}
}

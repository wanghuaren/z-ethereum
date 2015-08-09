package ui.base.vip
{
	import com.greensock.TweenMax;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Limit_TimesResModel;
	import common.config.xmlres.server.Pub_Vip_TypeResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.TextField;
	
	import netc.Data;
	
	import ui.base.beibao.Store;
	import ui.base.huodong.HuoDong;
	import ui.base.npc.NpcShop;
	import ui.base.vip.Vip;
	import ui.frame.UIMovieClip;
	import ui.frame.UIWindow;
	import ui.frame.WindowModelClose;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;
	import ui.view.view6.GameAlert;

	
	/**
	 * VipGuide
	 * @author andy
	 * @date   2014-05-27
	 */
	public final class VipGuide extends UIWindow {

		private static const delay_day_count:int = 2;
		
		private static var _instance:VipGuide;
		public static function getInstance():VipGuide{
			if(_instance==null)
				_instance=new VipGuide();
			return _instance;
		}
		public function VipGuide(obj:Object=null) {
			super(getLink("win_ji_huo_vip"),obj);
		}
		
		override protected function openFunction():void{
			init();
		}
		
		/**
		 * 
		 */
		public function setData(v:int,must:Boolean=true):void{
			curPage=v;
			super.open(must);
		}
		override protected function init():void {
			super.init();
			var _typeVipConfig:Pub_Vip_TypeResModel = null;
			_typeVipConfig = GameData.getVipTypeXml().getResPath(1) as Pub_Vip_TypeResModel;
			(mc['tips_Text'] as TextField).mouseWheelEnabled = false;
			mc["tips_Text"].htmlText = _typeVipConfig.vip_content;
			mc['tips_Text'].height = mc['tips_Text'].textHeight + 10;    
			mc['spCurrent'].source = mc['tips_Text']; 
		}
		
		private function show(isFirst:Boolean=false):void{
			
		}
		
		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnPay":
					ZhiZunVIPMain.getInstance().setType(1);
					break;
				
			}
		}
		
		/**
		 *	是否显示乐翻天大图标 
		 */
		public function chkVipGuideBigIcon(needCheckVipVip:Boolean=true):Boolean
		{
			//2014－11－04 策划要求屏蔽
			return false;
			if(PubData.mergeServerDay>0)return false;
			//开服时间
			var _starServerTime:String=GameIni.starServerTime();
			var _starServerTimeDate:Date=StringUtils.changeStringTimeToDate(_starServerTime);
			
			//开服之后30天时间
			var _10Day:Date=StringUtils.addDay(_starServerTimeDate,delay_day_count);
			
			//计算是否在领取奖励的时间之内
			var _today:Date=Data.date.nowDate;
			var _todayTime:Number=_today.getTime();
			
			var _ret:Boolean=false;
			
			//开服时间到活动结束时间
			if (_todayTime >= _starServerTimeDate.getTime() && _todayTime < _10Day.getTime() && 
				(needCheckVipVip==false ||(needCheckVipVip==true && Data.myKing.VipVip==0))
				)
			{
				_ret=true;
			}
			else
			{
				_ret=false;
			}
			
			return _ret;
		}	
	}
}

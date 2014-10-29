/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.view1.fuben.area
{
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import netc.packets2.StructIntParamList2;
	
	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSPlayerLeaveInstance;
	
	import ui.frame.UIWindow;
	
	import world.WorldEvent;
	
	/**
	 * @author liuaobo
	 * @create date 2013-8-1
	 */
	public class ShenLongTuTengJiangLi extends UIWindow
	{
		private static var sipl:Vector.<StructIntParamList2>;
		private static var callbacktype:int;
		private var daoJiShi:int;
		/**
		 * 是否胜利 
		 */
		private var _hasWin:Boolean = false;
		/**
		 * 是否通关 
		 */
		private var _hasPass:Boolean = false;
		
		public function ShenLongTuTengJiangLi(value:Vector.<StructIntParamList2>,_callbacktype:int)
		{
			sipl=value;
			callbacktype = _callbacktype;
			super(getLink("win_shen_long_tu_teng"));
		}
		
		private static var _instance:ShenLongTuTengJiangLi=null;
		
		public static function instance(value:Vector.<StructIntParamList2>,_callbacktype:int):ShenLongTuTengJiangLi
		{
			if (null == _instance)
			{
				_instance=new ShenLongTuTengJiangLi(value,_callbacktype);
			}
			else
			{
				sipl=value;
			}
			return _instance;
		}
		
		public static function hasAndGetInstance():Array
		{
			if(null != _instance)
			{
				return [true,_instance];
			}
			
			return [false,null];
		}
		// 面板初始化
		override protected function init():void
		{
			super.init();
			mc['txtDaoJiShi'].mouseEnabled = false;
			reset();
			showValue();
			//
			daoJiShi = 30;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
		}
		
		private function reset():void
		{
			_hasWin = false;
			_hasPass = false;
		}
		
		public function daoJiShiHandler(e:WorldEvent):void
		{
			daoJiShi--;
			if(daoJiShi >= 0)
			{
				mc['txtDaoJiShi'].text = daoJiShi.toString();
			}else{
				if (_hasWin){//胜利
					if (_hasPass){//通关
						leave();
					}else{//未通关，显示【进入下一层】
						mcHandler({name:"btnNext"});
					}
				}else{
					leave();
				}
			}
		}
		
		private function showValue():void
		{
			//是否胜利
			this._hasWin = sipl[0].intparam==2;
			//是否通关
			this._hasPass = sipl[1].intparam == 1;
			//当前第几层
			var currLayer:int = sipl[2].intparam;
			//星级
			var starLevel:int = sipl[3].intparam;//1-6
			//金钱
			var exp:int = sipl[4].intparam;
			//经验
			var money:int = sipl[5].intparam;
			this.mc["btnExit"].visible = true;
			//总层数
			if (this._hasWin){
				MovieClip(this.mc["mcTitle"]).gotoAndStop(1);
				if (this._hasPass){
					this.mc["btnNext"].visible = false;
					this.mc["tTimeSuffix"].htmlText = "秒后自动【离开副本】";
				}else{
					this.mc["btnExit"].visible = false;
					this.mc["btnNext"].visible = true;
					this.mc["tTimeSuffix"].htmlText = "秒后自动【继续挑战】";
				}
			}else{
				MovieClip(this.mc["mcTitle"]).gotoAndStop(2);
				this.mc["btnNext"].visible = false;
				this.mc["tTimeSuffix"].htmlText = "秒后自动【离开副本】";
			}
			
			
			this.mc["tLayer"].htmlText = "第"+currLayer+"层";
			this.mc["tMoney"].htmlText = money.toString();
			this.mc["tExp"].htmlText = exp.toString();
			
			var mcStar:MovieClip;
			for (var i:int = 1;i<=5;i++){
				mcStar = this.mc["remarkStar"+i];
				if (i>starLevel-1){
					mcStar.gotoAndStop(2);
				}else{
					mcStar.gotoAndStop(1);
				}
			}
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "btnNext":
					var p:PacketCSCallBack = new PacketCSCallBack();
					p.callbacktype = 100011202;
					this.uiSend(p);
					this.winClose();
					break;
				case "btnExit":
					this.leave();
					break;
			}
		}
		
		private function leave():void{
			var vo3:PacketCSPlayerLeaveInstance = new PacketCSPlayerLeaveInstance();
			vo3.flag = 1;
			uiSend(vo3);
			this.winClose();
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShiHandler);
			super.windowClose();
		}
		
	}
}
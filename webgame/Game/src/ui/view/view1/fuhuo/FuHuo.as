package ui.view.view1.fuhuo
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;

	import engine.event.DispatchEvent;
	import engine.support.IPacket;

	import flash.display.ActionScriptVersion;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.engine.TextElement;

	import netc.Data;

	import nets.packets.PacketCSCallBack;
	import nets.packets.PacketCSRelive;
	import nets.packets.PacketSCRelive;
	import nets.packets.PacketSCReliveResult;

	import scene.action.hangup.GamePlugIns;
	import scene.manager.SceneManager;

	import ui.base.vip.Vip;
	import ui.frame.UIWindow;
	import ui.view.view2.liandanlu.LianDanDesc;
	import ui.view.view2.other.DeadStrong;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;

	import world.WorldEvent;

	/**
	 *	复活
	 *  suhang 2011－02－04
	 */
	public class FuHuo extends UIWindow
	{
		//复活定时时间 5分钟即 300秒
		//现改为30秒
		public static const FU_HUO_DELAY_TIME:int=30; //300;

		public var current_fu_huo_time:int;

		public static var flag:int;

		public static var killer_name:String="";
		//锁屏
		//private static var _Enabled:Sprite =new Sprite();

		private static var _instance:FuHuo;

		public static function instance():FuHuo
		{
			if (_instance == null)
			{
				_instance=new FuHuo();
			}
			return _instance;
		}

		public static function hasInstance():Boolean
		{
			if (null == _instance)
			{
				return false;
			}
			return true;
		}

		public function FuHuo()
		{
			super(this.getLink("win_fu_huo"));
		}

		override protected function init():void
		{
			super.init();

			this.removeChild(this.getChildByName("moveBar"));

			//-------------------------------------------------------
			if (0 == flag)
			{
//				mc["btnRelive10"].visible = false;
				CtrlFactory.getUIShow().setColor(mc["btnRelive10"]);
//				mc["txt_yb"].visible=false;
				CtrlFactory.getUIShow().setColor(mc["txt_yb"]);
				mc["txt_vip"].visible=false;
			}
			else
			{
				CtrlFactory.getUIShow().setColor(mc["btnRelive10"], 1);
//				mc["btnRelive10"].visible=true;
				CtrlFactory.getUIShow().setColor(mc["txt_yb"],1);
//				mc["txt_yb"].visible=true;
				mc["txt_yb"].htmlText=Lang.getLabel('10197_fuhuo_20');
				mc["txt_vip"].visible=true;
			}

			//
			this.uiRegister(PacketSCReliveResult.id, fuHuoResult);
			this.uiRegister(PacketSCRelive.id, fuHuoReturn);

			this.sysAddEvent(PubData.AlertUI, "fuHuoTop", fuHuoTopHandler);

			super.sysAddEvent(mc["txt_vip"], TextEvent.LINK, zz); //LianDanDesc.instance().linkHandle);

			//-----------------------------------------------------------------------------------
			var LimitTimes:int=Vip.getInstance().getLimitTimesByVipVip(FU_HUO_LIMIT);
			var LimitTimes2:int; // = Data.huoDong.getLimitById(FU_HUO_LIMIT).curnum;

			if (null != Data.huoDong.getLimitById(FU_HUO_LIMIT))
			{
				LimitTimes2=Data.huoDong.getLimitById(FU_HUO_LIMIT).curnum;
			}

			var LimitTimes3:int=Vip.getInstance().getLimitTimesByVipVip(FU_HUO_LIMIT, 3);


			if (Data.myKing.VipVip > 0 && LimitTimes > 0)
				//if(true)
			{
				//Vip.getInstance().getVipName(),LimitTimes,
				mc["txt_vip"].htmlText=Lang.getLabel("10199_vip", [LimitTimes - LimitTimes2]);

			}
			else
			{
				mc["txt_vip"].htmlText=Lang.getLabel("10198_vip", [LimitTimes3]);
			}
//			if(20200186 == SceneManager.instance.currentMapId){
//				mc["btnRelive0"].visible = false;
//				mc["btnRelive10"].visible = true;
//				mc["txt_yb"].visible = true;
//				mc["txt_yb"].htmlText = Lang.getLabel('10197_fuhuo_GRPW_50');
//				mc["txt_tip"].visible = true;
//				(mc["txt_tip"] as TextField).htmlText =Lang.getLabel("10197_fuhuo_GRPW");
//				mc["txt_vip"].visible = true;
//				mc["txt_vip"].htmlText=Lang.getLabel("10197_fuhuo_GRPW2");
//			}

			start();

			replace();

		}

		public function zz(e:TextEvent):void
		{

			ZhiZunVIPMain.getInstance().open(true);
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;

			switch (name)
			{
				case "btnRelive10":
//					if(20200186 == SceneManager.instance.currentMapId){
//						var vo2:PacketCSCallBack = new PacketCSCallBack();
//						vo2.callbacktype = 100021203;//个人排位赛中 死亡复活
//						uiSend(vo2);
					if (flag != 0)
						fuHuo(1);
//					}
					break;
				case "btnRelive0":

					fuHuo(2);
					break;
				default:
					break;
			}
		}

		/**
		 *	开始定时
		 */
		public function start():void
		{

			current_fu_huo_time=FU_HUO_DELAY_TIME;

			//killer_name = "大王八";
			//
			if ("" != killer_name)
			{
				(mc["txt_tip"] as TextField).htmlText=Lang.getLabel("10197_fuhuo", [killer_name]);

			}
			else
			{
				(mc["txt_tip"] as TextField).htmlText=XmlManager.localres.HintXml.getResPath_ByRandom(3).hint_content;
			}
//			if(20200186 == SceneManager.instance.currentMapId){
//				mc["btnRelive0"].visible = false;
//				mc["btnRelive10"].visible = true;
//				mc["txt_yb"].visible = true;
//				mc["txt_yb"].htmlText = Lang.getLabel('10197_fuhuo_GRPW_50');
//				mc["txt_tip"].visible = true;
//				(mc["txt_tip"] as TextField).htmlText =Lang.getLabel("10197_fuhuo_GRPW");
//				mc["txt_vip"].visible = true;
//				mc["txt_vip"].htmlText=Lang.getLabel("10197_fuhuo_GRPW2");
//			}
			//GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,coolTime);
			//GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,coolTime);
		}
		/**
		 *	复活时间定时
		 */
		public static const FU_HUO_LIMIT:int=88000012; //80700894;

		private function coolTime(we:WorldEvent):void
		{
			if (current_fu_huo_time > 0)
			{
				current_fu_huo_time--;

				//1.【回城复活】按钮调整为【安全区复活(30秒)】按钮
				//2.显示倒计时变化，为0时执行按钮功能(在最近的复活点复活)

				//(mc["txt_time"] as TextField).mouseEnabled = false;
				//mc["txt_time"].text = "(" + current_fu_huo_time.toString() + Lang.getLabel("30009_second") +")";


				if (current_fu_huo_time == 0)
				{
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, coolTime);
					SetIndexEnabled(true);

					//自动安全区复活
					fuHuo(2);



					super.winClose();
				}
			}

		}

		/**************通信**************/
		/**
		 *	 复活
		 */
		//private function fuHuo(type:int=2):void{
		private function fuHuo(type:int):void
		{

			var client:PacketCSRelive=new PacketCSRelive();
			client.mode=type;
			this.uiSend(client);

			//2012-06-18 andy 死亡后如何强大提示【右下角】
			var level:int=Data.myKing.level;
			if (level >= DeadStrong.MIN_LEVEL && level <= DeadStrong.MAX_LEVEL)
			{
				//DeadStrong.getInstance().open(true);
			}

			if (2 == type)
			{
				//安全区复活 需要停止挂机
				if (GamePlugIns.getInstance().running)
				{
					GamePlugIns.getInstance().stop();
				}
			}
		}

		private function fuHuoReturn(p:IPacket):void
		{
			close();
		}

		private function fuHuoResult(p:IPacket):void
		{
			if (!showResult(p))
			{
				//alert.ShowMsg(Lang.getServerMsg((p as Object).tag),2);
				//	alert.ShowMsg("元宝不足!",2);
			}
		}

		private function fuHuoTopHandler(e:DispatchEvent):void
		{
			if (null != this.parent)
			{
				this.parent.addChild(this);

			}


		}

		override public function closeByESC():Boolean
		{
			return false;
		}



		public function close():void
		{
			//GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,coolTime);

			super.winClose();
		}


		/************内部方法**************/
		//锁屏
		public static function SetIndexEnabled(bo:Boolean):void
		{

			if (bo)
			{
				//_Enabled.graphics.clear();
			}
			else
			{
				//UI_index.indexMC.addChild(_Enabled);
				//_Enabled.cacheAsBitmap=true;
				//_Enabled.graphics.clear();
				//_Enabled.graphics.beginFill(color,0.2);
				//_Enabled.graphics.drawRect(0,0,GameIni.MAP_SIZE_W,GameIni.MAP_SIZE_H);
				//_Enabled.graphics.endFill();
			}
		}

		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标

		private function replace():void
		{

			if (null == m_gPoint)
			{
				m_gPoint=new Point();

			}

			if (null == m_lPoint)
			{
				m_lPoint=new Point();
			}

			if (null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x=(mc.stage.stageWidth - mc.width) >> 1;
				m_gPoint.y=(mc.stage.stageHeight - mc.height) >> 1;

				m_lPoint=mc.parent.globalToLocal(m_gPoint);

				mc.x=m_lPoint.x;
				mc.y=m_lPoint.y;
			}


		}

	}
}

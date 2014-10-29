package main
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.MapDef;
	import com.bellaxu.def.RenderGroupDef;
	import com.bellaxu.map.MapBlockContainer;
	import com.bellaxu.mgr.FrameMgr;
	import com.bellaxu.mgr.LayerMgr;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.StageUtil;
	import com.greensock.plugins.Physics2DPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.xh.config.Global;
	import com.xh.display.XHButton;
	import com.xh.display.XHLoadIcon;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.server.DBModel;
	import common.utils.AsToJs;
	import common.utils.Stats;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.load.Loadres;
	import engine.utils.Debug;
	import engine.utils.FPSUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.DataKey;
	
	import nets.packets.PacketSCUnAuto;
	
	import scene.action.Action;
	import scene.action.BodyAction;
	import scene.action.FightAction;
	import scene.king.SkinManage;
	import scene.manager.ResourceManager;
	import scene.manager.SceneManager;
	import scene.music.GameMusic;
	import scene.utils.PowerManage;
	
	import ui.base.login.NewRole_new;
	import ui.base.mainStage.UI_index;
	import ui.base.shejiao.SheJiao;
	import ui.layout.GameLayout;
	import ui.view.UIMessage;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view1.desctip.GameTipCenter;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view1.xiaoGongNeng.Welcome;
	import ui.view.view2.other.DeadStrong;
	import ui.view.view2.other.QuickInfo;
	import ui.view.view3.drop.ResDrop;
	import ui.view.view7.UI_JingYan;
	import ui.view.view7.UI_Mc_Fu_Ben;
	import ui.view.view7.UI_MessagePanel3;
	import ui.view.view7.UI_Mrt;
	
	import world.WorldDispatcher;
	import world.WorldEvent;
	import world.WorldState;

	/**
	 * @author wanghuaren
	 * @version 2011.2.28
	 */
	[SWF(frameRate="60", backgroundColor="0x000000")]
	public class Game_main extends Sprite
	{
		public var LoadBar:MovieClip;
		public var LoadBg:MovieClip;
		public var LoadPic:Loader;

		public function Game_main()
		{
			Security.allowDomain('*');
			Security.allowInsecureDomain('*');
			//读取文本数据时
			//如果将 system.useCodepage 属性设置为 true，
			//则会使用运行该播放器的操作系统的传统代码页来解释文本，而不将文本解释为 Unicode。
			System.useCodePage=true;
			Global.LOAD_ASSET_FROM_LOCAL=false;
//			Movie.MovieHitAreaOptimizeEnabled=true;
//			Movie.MovieHitAreaCachEnabled=true;
			DBModel;
			new XHLoadIcon();
			new XHButton();
			TweenPlugin.activate([Physics2DPlugin]);
			
			_instance=this;
			if (stage)
			{
				addtoStageHandler1();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addtoStageHandler1);
			}
		}
		private static var _instance:Game_main;

		public static function get instance():Game_main
		{
			if (_instance == null)
			{
				_instance=new Game_main();
			}
			return _instance;
		}
//		private var rb1:ResourceBundle=new ResourceBundle("en_US","whr");
		public var m_half_prev:int;
		//public var m_v:int;                                                             
		public var m_prev:int;
		public var m_prev_100:int;
		public var m_two_prev2000:int;
		public var m_prev_5000:int;
		public var m_prev_10000:int;
		public var m_prev_30000:int;
		public var m_prev_200:int;
		public var m_prev_400:int;
		public var m_prevFps:int;
		protected var countadd:int;
		private var _fps:uint;
		protected var i:int;
		protected var jump_reset:int;
		public var t:int;
		//刚刚失去焦点的时候需要一个稳定期
		private var _deactivateNum:int=0;
		private var m_SlowFrameRate:int=0;
		private var m_cTime:int=0;
//		private function isSlow():Boolean
//		{
//			return m_isSlowFrameRate;
//		}
		/**
		 * 用于控制吃药的时间间隔
		 * @return
		 *
		 */
		private var m_chiyaoInterval:int;
		//是否失去焦点了
		private var m_isDeactivate:Boolean;
		private var m_isSlowFrameRate:Boolean;
		private var m_pTime:int=0;
		private var m_pTime2:int=0;

		//private var m_testFrameTimer:Timer;
		public function set setFps(value:uint):void
		{
			_fps=value;
		}
		private var hideLoadBarUI_Count:int=0;

		public function HideLoadBarUI(e:WorldEvent=null):void
		{
			if (hideLoadBarUI_Count > 25)
			{
				return;
			}
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "8,-删除加载界面"));
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.CREATEROLE, hasRoleHandler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.TXT_INFO, txtInfoHandler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.TXT_INFO2, txtInfo2Handler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.TXT_INFO3, txtInfo3Handler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.PIC_SOURCE, picSourceChangeHandler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.BAR_PERCENT, barPercentHandler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.CHONGLIAN, chongLianHandler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.PKWIN, chongLianHandler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.LOGINERROR, chongLianHandler);
			//WorldDispatcher.instance.removeEventListener(WorldDispatcher.IN_GROUND,inGroundHandler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.LOAD_RES, loadresHandler);
			if (null != this.LoadBg)
			{
				if (null != this.LoadBg.parent)
				{
					this.LoadBg.parent.removeChild(this.LoadBg);
				}
			}
			if (null != this.LoadPic)
			{
				if (null != this.LoadPic.parent)
				{
					this.LoadPic.parent.removeChild(this.LoadPic);
				}
			}
			//
			if (null != this.LoadBar)
			{
				if (null != this.LoadBar.parent)
				{
					this.LoadBar.parent.removeChild(this.LoadBar);
				}
			}
			hideLoadBarUI_Count++;
		}
		public var isHideLoadBarUI:Boolean=false;

		public function ShowLoadBarUI():void
		{
			if (isHideLoadBarUI)
			{
				HideLoadBarUI();
				return;
			}
			var w:int=this.stage.stageWidth;
			var h:int=this.stage.stageHeight;
			var needAdd:Boolean=false;
			//
			if (null != LoadBg)
			{
				if (null == LoadBg.parent)
				{
					needAdd=true;
				}
			}
			//
			if (null != LoadBar)
			{
				if (null == LoadBg.parent)
				{
					needAdd=true;
				}
			}
			//
			if (null != LoadPic)
			{
				if (null == LoadPic.parent)
				{
					needAdd=true;
				}
			}
			//x,y
			if (null != this.LoadBg)
			{
				LoadBg.x=0;
				LoadBg.y=0;
				LoadBg.width=w;
				LoadBg.height=h;
			}
			//-------------------------------------   begin    -------------------------------------
			if (null != this.LoadPic)
			{
				if (null != LoadPic.content)
				{
					if (1 == GameLayout.LOADING_PIC_ALIGN_MODE)
					{
						LoadPic.x=w / 2;
						LoadPic.y=0;
						//1440 x 900 是图片宽高
						var pcn:Number=h / GameLayout.LOAD_X_JPG_INFO.Height_;
						LoadPic.content.width=pcn * GameLayout.LOAD_X_JPG_INFO.Width_;
						LoadPic.content.height=h;
						LoadPic.x-=(pcn * GameLayout.LOAD_X_JPG_INFO.Width_) / 2;
					}
					if (2 == GameLayout.LOADING_PIC_ALIGN_MODE)
					{
						LoadPic.x=(w - LoadPic.content.width) >> 1; // 2;
						LoadPic.y=(h - LoadPic.content.height) >> 1;
					}
				}
			}
			//-------------------------------------   end    -------------------------------------
			if (null != this.LoadBar)
			{
				if (1 == GameLayout.LOADING_PIC_ALIGN_MODE)
				{
					//x,y
					replace();
					this.LoadBar.x=this.LoadBar.x - GameLayout.LOADING_FLA_DOC.LoadBarWidth_ / 2 - GameLayout.LOADING_FLA_DOC.LoadBarWidthOffest_ / 2;
					this.LoadBar.y=h - GameLayout.LOADING_FLA_DOC.LoadBarHeight_;
				}
				if (2 == GameLayout.LOADING_PIC_ALIGN_MODE)
				{
					//x,y
					replace();
					this.LoadBar.x=this.LoadBar.x - GameLayout.LOADING_FLA_DOC.LoadBarWidth_ / 2 - GameLayout.LOADING_FLA_DOC.LoadBarWidthOffest_ / 2;
					this.LoadBar.y=h - GameLayout.LOADING_FLA_DOC.LoadBarHeight_;
					//------------
					if (null != this.LoadPic)
					{
						//
						var upH:int=102;
						if (null != LoadPic.content)
						{
							//不完全贴图片底边，再往上一点
							this.LoadBar.y=LoadPic.y + LoadPic.content.height - upH;
						}
						else
						{
							//不完全贴图片底边，再往上一点
							this.LoadBar.y=LoadPic.y + GameLayout.LOAD_X_JPG_INFO.Height_ - upH;
						}
					}
						//------------
				}
			}
			//
			if (needAdd)
			{
				if (null != LoadBg)
				{
					this.addChild(LoadBg);
				}
				if (null != LoadPic && null != LoadPic.content)
				{
					this.addChild(LoadPic);
				}
				if (null != LoadBar)
				{
					this.addChild(LoadBar);
				}
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
			var mc:MovieClip=this.LoadBar;
			if (null != mc && null != mc.parent && null != mc.stage)
			{
				//m_gPoint.x = (mc.stage.stageWidth - mc.width ) >> 1 ;
				//m_gPoint.y = (mc.stage.stageHeight - mc.height)>> 1 ;
				m_gPoint.x=(mc.stage.stageWidth) >> 1;
				m_gPoint.y=(mc.stage.stageHeight) >> 1;
				m_lPoint=mc.parent.globalToLocal(m_gPoint);
				mc.x=m_lPoint.x;
					//mc.y = m_lPoint.y;
			}
		}

		private var timerFrame:Timer=new Timer(1);
		public function Map_frameHandler(e:TimerEvent):void
		{
			DataKey.instance.process();
			FightAction.tick();
		}

		public function Stage_frameHandler(e:Event=null):void
		{
			t=getTimer();
			(countadd > 9999) ? countadd=0 : countadd++;
//			_doTestFrameRate2(e);

//			DataKey.instance.process();
			/////////////////////
			ResTool.render();
			SceneManager.instance.update();
//			CursorMgr.init();
//			FightAction.tick();
			////////////////////
			ShowLoadBarUI();
			//每帧事件			
			GameClock.instance.dispatchEvent__(WorldEvent.CLOCK__);
			//100毫秒事件			
			if (t - m_prev_100 >= 100)
			{
				m_prev_100=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK__SECOND100);
			}
			//200毫秒事件
			if (t - m_prev_200 >= 200)
			{
				m_prev_200=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK__SECOND200);
			}
			//400毫秒事件
			if (t - m_prev_400 >= 400)
			{
				m_prev_400=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK__SECOND400);
			}
			//半秒事件
			if (t - m_half_prev >= 500)
			{
				m_half_prev=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK_HALF_OF_SECOND);
			}
			//1秒事件
			if (t - m_prev >= 1000)
			{
				m_prev=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK_SECOND);
			}
			//2秒事件
			if (t - m_two_prev2000 >= 2000)
			{
				m_two_prev2000=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK_TWO_SECOND);
			}
			//5秒事件
			if (t - m_prev_5000 >= 5000)
			{
				m_prev_5000=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK_FIVE_SECOND);
			}
			//10秒事件
			if (t - m_prev_10000 >= 10000)
			{
				m_prev_10000=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK_TEN_SECOND);
			}
			//30秒事件
			if (t - m_prev_30000 >= 30000)
			{
				m_prev_30000=t;
				GameClock.instance.dispatchEvent__(WorldEvent.CLOCK_THIRTY_SECOND);
			}
			if (this.m_isSlowFrameRate && this.m_isDeactivate)
			{
				for (var i:int=0; i <= m_SlowFrameRate; ++i)
				{
					this.Stage_frameServerHandler(i);
				}
				return;
			}
			//本人战斗控制
			var bon:int;
			var curSta:String=GameIni.currentState;
			if (WorldState.ground == curSta)
			{
				//
				if (PowerManage.isRunStart)
				{
					PowerManage.frameHandler(e);
				}
				var isMyRun:Boolean=false
				if (null != Data.myKing.king)
				{
					Data.myKing.king.CenterAndShowMap();
				}
				var doDepth:Boolean=false;
				if (FrameMgr.isBad)
				{
					if (0 == (countadd % 21))
						doDepth=true;
				}
				else
				{
					if (0 == (countadd % 15))
						doDepth=true;
				}
				if (doDepth)
				{
					SceneManager.instance.Depth_Core(LayerDef.bodyLayer);
				}
				if (FrameMgr.isBad)
				{
					//跟跑步一样,40 * 1.3 = 52
					Data.myKing.AutoDoSth(countadd, 60);

				}
				else
				{
					if (GameData.curFps == GameData.FPS_LOW)
					{
						Data.myKing.AutoDoSth(countadd, 33);
					}
					else
					{
						Data.myKing.AutoDoSth(countadd, 40);
					}
				}
//				if (SceneManager.instance.isSlowFrameRateHyper)
//				{
//					//跟跑步一样,40 * 1.3 = 52
//					Data.myKing.AutoDoSth(countadd, 50);
//				}
//				else if (SceneManager.instance.isSlowFrameRateHyperDeep)
//				{
//					Data.myKing.AutoDoSth(countadd, 60);
//				}
//				else
//				{
//					if (GameIni.FPS == 30)
//					{
//						Data.myKing.AutoDoSth(countadd, 33);
//					}
//					else
//					{
//						Data.myKing.AutoDoSth(countadd, 40);
//					}
//				}
				//
				if (0 == (countadd % 6))
				{
					//现在不需要移坐标了，改成% 5
					Action.instance.fight.MoveHeadMenu();
					Action.instance.fight.MoveNpcStatus();
				}
				//监控吃药  根据祥子的指示： 采用一直Timer监控的办法。不断监视当前血量，以至于做到吃药的实时性。
//				if (0 == (countadd % 6))
//				{
//					if (_chiyaoInterval()) //这里控制一下监控的频率
//					{
//						//GamePlugIns.getInstance().chiYao();
//					}
//				}
			}
			//
			if (UIMessage.run)
			{
				UIMessage.message2Timer(e);
			}
			//
			if (SkinManage.run)
			{
				//在这边改成 % 2
				//if (0 == (countadd % 2))
				//{
				SkinManage.TIMER_HAND();
					//}
			}
			//
			if (!scene.manager.ResourceManager.instance.isLoading)
			{
				//在这边改成 % 2
				//if (0 == (countadd % 2))
				//{
				scene.manager.ResourceManager.instance.TIMER_HAND();
					//}
			}
			else
			{
				//在这边改成 % 2
				//if (0 == (countadd % 2))
				//{
				scene.manager.ResourceManager.instance.TIMER_HAND2();
					//}
			}
			if (UI_Mrt.hasInstace())
			{
				UI_Mrt.instance.setHideState()
			}
		}

		public function Stage_frameServerHandler(i:int):void
		{
			//i+1，敏感点
			t=getTimer() + ((i + 1) * 40);
			(countadd > 9999) ? countadd=0 : countadd++;
			//本人战斗控制
			if (WorldState.ground == GameIni.currentState)
			{
				//
				if (PowerManage.isRunStart)
				{
					PowerManage.frameHandler();
				}
				//
				Data.myKing.AutoDoSth(countadd, 40);
				if (0 == (countadd % 6))
				{
					//现在不需要移坐标了，改成% 6
					Action.instance.fight.MoveHeadMenu();
				}
				//监控吃药  根据祥子的指示： 采用一直Timer监控的办法。不断监视当前血量，以至于做到吃药的实时性。 
				if (0 == (countadd % 15))
				{
					if (_chiyaoInterval()) //这里控制一下监控的频率
					{
						//GamePlugIns.getInstance().chiYao();
					}
				}
			}
			//
			if (UIMessage.run)
			{
				UIMessage.message2Timer();
			}
			//
			if (SkinManage.run)
			{
				//在这边改成 % 2
				if (0 == (countadd % 2))
				{
					SkinManage.TIMER_HAND();
				}
			}
			//
			if (!scene.manager.ResourceManager.instance.isLoading)
			{
				//在这边改成 % 2
				if (0 == (countadd % 2))
				{
					scene.manager.ResourceManager.instance.TIMER_HAND();
				}
			}
			else
			{
				//在这边改成 % 2
				if (0 == (countadd % 2))
				{
					scene.manager.ResourceManager.instance.TIMER_HAND2();
				}
			}
		}

		// fux_map
		public function Stage_resizeHandler(event:Event=null,m_stage:Stage=null):void
		{
			if(m_stage==null)
				m_stage=Main.instance().stage;
			// get
			var w:int=m_stage.stageWidth;
			var h:int=m_stage.stageHeight;
			if (200 >= w && 200 >= h)
				return;

			MapBlockContainer.H_BLOCK_NUM=Math.ceil(w / MapDef.TILE_WIDTH);
			MapBlockContainer.V_BLOCK_NUM=Math.ceil(h / MapDef.TILE_HEIGHT);

			GameIni.MAP_SIZE_W=w;
			GameIni.MAP_SIZE_H=h;
			//----newcodes
			SceneManager.instance.resize();
			//----end
			resize_UI_index(w, h);
			// state
			var currentState:String=GameIni.currentState;
			switch (currentState)
			{
				case WorldState.ground:
					resize_win(w, h);
					resize_welcome(w, h);
					ResDrop.instance.stageResizeHandler(w, h);
					centerKing();
					QuickInfo.getInstance().resize();
					break;
				case WorldState.changeGround:
					ResDrop.instance.stageResizeHandler(w, h);
					centerKing();
					QuickInfo.getInstance().resize();
					break;
				case WorldState.login:
					//由login enterFrame接管
					break;
				case WorldState.role:
					NewRole_new.instance.resize();
					break;
				case WorldState.init:
					break;
			}
		}

		private function mouseRightKeyHandler(e:MouseEvent):void
		{
			if (PubData.canRightKey && !SceneManager.MapInLoading)
			{
				BodyAction.indexUI_GameMap_Mouse_Down(e);
			}
		}

		public function addtoStageHandler1(e:Event=null):void
		{
			PubData.version=Number(Capabilities.version.split(" ")[1].split(",")[0]) + Number(Capabilities.version.split(" ")[1].split(",")[1]) * 0.1;
			
			StageUtil.stage=this.stage;
			LayerMgr.init();
			FrameMgr.regist(this.stage);
			FrameMgr.addFunction(Stage_frameHandler, RenderGroupDef.NO_DELAY);
			FPSUtils.setup(this.stage);
			ResTool.init(stage);
//			if (PubData.canRightKey&&MouseEvent.RIGHT_CLICK!=null){
//				this.stage.addEventListener(MouseEvent.RIGHT_CLICK, mouseRightKeyHandler);
//			}
			// fux_map
			this.stage.align=StageAlign.TOP_LEFT;
			this.stage.scaleMode=StageScaleMode.NO_SCALE;
			this.stage.quality=StageQuality.LOW;
			//Tab键卡画面问题解决，设tabChildren，stage会失去焦点到网页上
			//在resizeWin时设UI_index.instance.tabChildren = false;
			//this.stage.tabChildren = false;					
			// 屏蔽按tab键focus出现黄色边框
			this.stage.stageFocusRect=false;
			//游戏初始化状态
			GameIni.currentState=WorldState.init;
			//
			setFps=stage.frameRate;
			//将主应用设置为显示列表的底层
//			addChildAt(Main.instance(), 0);
			LayerDef.viewLayer.addChild(Main.instance());
			//
			Main.instance().addEventListener(Main.MAIN_LOADED, mainLoadComplete);
			//主应用执行初始化操作
			Main.instance().mainInit();
		}
		public function libLoadedCall(m_stage:Stage=null):void
		{
			// 强制触发一次，设一下GameIni的MAP_SIZE值
			Stage_resizeHandler(null,m_stage);
//			PowerManage.PreTimer=getTimer();
			//
//			this.stage.addEventListener(Event.ENTER_FRAME, this.Stage_frameHandler);
			timerFrame.addEventListener(TimerEvent.TIMER, Map_frameHandler);
			timerFrame.start();
			m_stage.addEventListener(Event.DEACTIVATE, _deactivateListener);
			m_stage.addEventListener(Event.ACTIVATE, _activateListener);
			m_stage.addEventListener(Event.RESIZE, this.Stage_resizeHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
//			DataKey.instance.register(PacketSCUnAuto.id, serviceEnterFrameHandler)
		}

//		public function serviceEnterFrameHandler(p:PacketSCUnAuto):void
//		{
//			Stage_frameHandler();
//		}

		public function ioErrorHandler(e:IOErrorEvent):void
		{
			trace("IO_ERROR");
		}

		public function btnRefresPageClick(e:MouseEvent):void
		{
			AsToJs.callJS("refreshpage");
		}

		public function resize_UI_index(w:int, h:int):void
		{
			if (UI_index.instance == null || UI_index.instance.mc == null || UI_index.indexMC_mrb == null)
			{
				return;
			}
			GameTip.UpdateList();
			UI_index.indexMC["mc_FanLiRi"].x=(w - UI_index.indexMC["mc_FanLiRi"].width) / 2;
			UI_index.indexMC_mrb.y=h;
			if (UI_index.instance.mc["mcDebugLabel"] != null)
			{
				UI_index.instance.mc["mcDebugLabel"].x=(w - UI_index.instance.mc["mcDebugLabel"].width) >> 1;
			}
			if (UI_index.indexMC_mrt["missionHide"].visible == true)
			{
//				UI_index.indexMC_mrt["missionMain"]["normalTask"]["msg_youxia"].x = UI_index.indexMC_mrt["missionMain"].x;
//				UI_index.indexMC_mrt["missionMain"]["normalTask"]["msg_youxia"].y = UI_index.indexMC_mrt["missionMain"].y+UI_index.indexMC_mrt["missionMain"].height;
			}
			if (GameTipCenter.instance.isHave())
			{
				GameTipCenter.instance.UpdateList();
			}
			if (null != UI_index.indexMC_jingyan)
			{
				//	UI_index.indexMC_jingyan.x=w / 2 - 420 / 2;
				//	UI_index.indexMC_jingyan.y=h / 2 - 200 / 2;
				if (UI_JingYan.hasInstance())
				{
					UI_JingYan.instance.x=w / 2 - 420 / 2;
					UI_JingYan.instance.y=h / 2 - 200 / 2;
				}
			}
			//
//			if (null != UI_index.indexMC_jingyan_zhonghe)
//			{
//				UI_index.indexMC_jingyan_zhonghe.x=w / 2 - 460 / 2;
//				UI_index.indexMC_jingyan_zhonghe.y=h - 65 - 154;
//			}
//			if (null != UI_index.indexMC["mc_fu_ben"])
//			{
//				UI_index.indexMC_jingyan_zhonghe.x=w - UI_index.indexMC_jingyan_zhonghe.width - 10;
//				UI_index.indexMC_jingyan_zhonghe.y=h - 65 - UI_index.indexMC_jingyan_zhonghe.height;
//			}
			//
			//UI_index.indexMC_zhengba.x = w / 2 - 140 / 2;				
			//UI_index.indexMC_zhengba.y =  h - 45 - 180;
			//- UI_index.indexMC_taskAccept.textWidth / 2
			UI_index.indexMC_taskAccept.x=w / 2 - UI_index.indexMC_taskAccept.textWidth / 2;
			UI_index.indexMC_taskAccept.y=h - 45 - 40 - 100; //- 180;
			//废弃
//				UI_index.instance.mc["scalePanel"]["backBoard"].width=w;
			var mrbWidth:int=UI_index.instance.mc["mrb"].width;
			var buttonMenuWidth:int=UI_index.instance.mc["mrb"]["mc_index_menu"].width;
			var mrbX:int=int(w - (mrbWidth - buttonMenuWidth) >> 1);
			var actualX:int=0;
			if (mrbX + mrbWidth > w)
			{ //显示不全，则从右边界往左偏移
				actualX=w - mrbWidth;
			}
			else
			{
				actualX=mrbX;
			}
			if (actualX < 0)
				actualX=0;
//				UI_index.instance.mc["scalePanel"].x=
			UI_index.instance.mc["mrb"].x=actualX;
//				if (w>UI_index.instance.mc["mrb"].width){
//					if (w-mrbX
//					mrbX = w-UI_index.instance.mc["mrb"].width+270;
//				}else{
//					mrbX = 270;
//				}
//				UI_index.instance.mc["scalePanel"].x=UI_index.instance.mc["mrb"].x=w>UI_index.instance.mc["mrb"].width?w-UI_index.instance.mc["mrb"].width+270:270;
//				if ((int(w / 2) - int(UI_index.instance.mc["mrb"].width / 2) + 20 - UI_index.instance.mc["chat"].width) > 0)
			if (UI_index.instance.mc["mrb"].x - 20 - UI_index.instance.mc["chat"].x - UI_index.instance.mc["chat"].width > 0)
			{
//					UI_index.instance.mc["chat"].y=h - 193;
				UI_index.instance.mc["chat"].y=h - 224;
//					UI_index.instance.mc["btnLong"].y=h - 183 + MainChat.btnLongYoff;
				UI_index.instance.mc["btnLong"].y=UI_index.instance.mc["chat"].y + 202;
				if (UI_index.instance.mc["chat"].visible == false)
				{
					UI_index.instance.mc["btnLong"].y=h - 20;
				}
			}
			else
			{
//					UI_index.instance.mc["chat"].y=h - 250;
				UI_index.instance.mc["chat"].y=h - 340;
//					UI_index.instance.mc["btnLong"].y=h - 250 + MainChat.btnLongYoff;
				UI_index.instance.mc["btnLong"].y=UI_index.instance.mc["chat"].y + 202;
				if (UI_index.instance.mc["chat"].visible == false)
				{
					UI_index.instance.mc["btnLong"].y=h - 20;
				}
			}
			//UI_index.instance.mc["mc_fu_ben"].x=UI_index.instance.mc["mrt"].x=w;	
			UI_index.instance.mc["mrt"].x=w;
			if (UI_Mc_Fu_Ben.hasInstance())
			{
				UI_Mc_Fu_Ben.instance.x=w - 550;
			}
			if (UI_index.indexMC["bossHp"].visible == true)
			{
				UI_index.indexMC["bossHp"].x=w / 2 - UI_index.indexMC["bossHp"].width / 2;
				UI_index.indexMC["bossHp"].y=0;
			}
			if ((int(w / 2) - int(UI_index.instance.mc["mrb"].width / 2) - UI_index.instance.mc["messagePanel"].width) > 0)
			{
				UI_index.instance.mc["messagePanel"].y=h - 118;
				UI_index.instance.mc["messagePanel2"].y=h - 118 - 100;
			}
			else
			{
				UI_index.instance.mc["messagePanel"].y=h - 170;
				UI_index.instance.mc["messagePanel2"].y=h - 170 - 100;
			}
			UI_index.instance.mc["messagePanel"].x=w - UI_index.instance.mc["messagePanel"].width;
			UI_index.instance.mc["messagePanel2"].x=w - UI_index.instance.mc["messagePanel2"].width - 250;

			if (null != UI_MessagePanel3.instance)
			{
				UI_MessagePanel3.instance.resize();
			}
			UI_index.instance.mc["message"].x=(w - 560) / 2;
			//2012-06-13 andy 社交小界面自适应屏幕全屏切换
			var p:Point=new Point();
			if (SheJiao.hasInstance())
			{
				if (SheJiao.getInstance().isOpen)
				{
					p.x=UI_index.indexMC_mrb["mc_index_menu"]["btnSheJiao"].x;
					p=UI_index.indexMC_mrb["mc_index_menu"].localToGlobal(p);
					SheJiao.getInstance().x=p.x;
					SheJiao.getInstance().y=p.y - SheJiao.getInstance().mc.height + 60;
					p=null;
				}
			}
			//2012-06-18 andy 死亡复活后强大提示适应屏幕全屏切换
			if (DeadStrong.hasInstance())
			{
				if (DeadStrong.getInstance().isOpen)
				{
					DeadStrong.getInstance().x=GameIni.MAP_SIZE_W - 50 - DeadStrong.getInstance().mc.width;
					DeadStrong.getInstance().y=GameIni.MAP_SIZE_H - 50 - DeadStrong.getInstance().mc.height;
				}
			}
		}

		public function resize_welcome(w:int, h:int):void
		{
			try
			{
				if (null == Welcome._instance)
				{
					return;
				}
				//
				var d:DisplayObject=Welcome.instance();
				if (null != d)
				{
					//+200是因为元件不在原点
					//d.x=w / 2+ 200;
					//d.y=h / 2 - d.height / 2+ 100;
					d.x=(w - d.width) / 2;
					d.y=(h - d.height) / 2;
				}
			}
			catch (err:Error)
			{
				Debug.instance.traceMsg(err.message + " func:resize_ShowLoading");
			}
		}

		public function resize_win(w:int, h:int):void
		{
			try
			{
				if (PubData.AlertUI.getChildByName("mc_help") != null)
				{
					PubData.AlertUI.getChildByName("mc_help").width=w;
					PubData.AlertUI.getChildByName("mc_help").height=h;
				}
				if (PubData.AlertUI.getChildByName("win_xitong") != null)
				{
					PubData.AlertUI.getChildByName("win_xitong").x=w - 180;
					PubData.AlertUI.getChildByName("win_xitong").y=h - PubData.AlertUI.getChildByName("win_xitong")["mc"].height - 50;
				}
				if (PubData.AlertUI.getChildByName("win_xitong_shejiao") != null)
				{
					PubData.AlertUI.getChildByName("win_xitong_shejiao").x=w - 280;
					PubData.AlertUI.getChildByName("win_xitong_shejiao").y=h - PubData.AlertUI.getChildByName("win_xitong")["mc"].height - 50;
				}
			}
			catch (err:Error)
			{
				Debug.instance.traceMsg(err.message + " func:resize_win");
			}
		}

		public function setLoadBar(bg:MovieClip, bar:MovieClip, pic:Loader):void
		{
			LoadBg=bg;
			LoadBar=bar;
			LoadPic=pic;
			LoadBar["btnRefresPage"].visible=true;
			//LoadBar["uil"].setCompleteFunc=LoadBarPhotoComplete;
			LoadBar["btnRefresPage"].addEventListener(MouseEvent.CLICK, btnRefresPageClick);
			//
			WorldDispatcher.instance.addEventListener(WorldDispatcher.CREATEROLE, hasRoleHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.TXT_INFO, txtInfoHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.TXT_INFO2, txtInfo2Handler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.TXT_INFO3, txtInfo3Handler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.PIC_SOURCE, picSourceChangeHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.BAR_PERCENT, barPercentHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.CHONGLIAN, chongLianHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.PKWIN, chongLianHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.LOGINERROR, chongLianHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.IN_GROUND, inGroundHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.LOAD_RES, loadresHandler);
		}

		public function setLoadingRes(resSWF:Dictionary, resAPP:Dictionary, urlval:Object=null):void
		{
			Main.instance().setLoadingRes(resSWF, resAPP, urlval);
		}

		private function _activateListener(e:Event):void
		{
			m_isDeactivate=false;
			//获得焦点，打开声音【由于有些浏览器不支持焦点事件，特此去除监听】
			GameMusic.setActivate(true);
//			SceneManager.instance.isDeactivate=false;
		}

		private function _chiyaoInterval():Boolean
		{
			//return false;
			var _ret:Boolean=false;
			var _t:int=getTimer();
			//                                                CHI_YAO_INTERVAL
			if ((_t - m_chiyaoInterval) >= 6000)
			{
				m_chiyaoInterval=_t;
				_ret=true;
			}
			return _ret;
		}

		private function _deactivateListener(e:Event):void
		{
			m_isDeactivate=true;
			//失去焦点，关闭声音			
			GameMusic.setActivate(false);
			//
//			SceneManager.instance.isDeactivate=true;
		}
		protected var fpsNow:uint;
		protected var timerFps:uint;

		//private var isClose:Boolean=false;
		private function _doTestFrameRate2(event:Event):void
		{
			m_cTime=getTimer();
			//var lo:int = 
//			if (GameIni.FPS == 30)
//			{
//				SceneManager.instance.slowFrameRate=((m_cTime - m_pTime2 - 33) / 33) + 2;
//			}
//			else
//			{
//				SceneManager.instance.slowFrameRate=((m_cTime - m_pTime2 - 40) / 40) + 2;
//			}
			m_pTime2=m_cTime;
			//-----------------------------------------
			timerFps=m_cTime; //getTimer();
			if (timerFps - 1000 > m_prevFps)
			{
				m_prevFps=timerFps;
				//MsgPrint.printTrace("fpsNow:" + fpsNow,MsgPrintType.WINDOW_REFRESH);
				//14
				//if(_fps > fpsNow && 
				//	(_fps - fpsNow) >= 15)
				//{
				//}else
				//{
				//}
				GameIni.currentFps=fpsNow;
				fpsNow=0;
			}
			fpsNow++;
			//-----------------------------------------
			//
			if (!m_isDeactivate)
			{
				m_isSlowFrameRate=false;
				return;
			}
			if (_deactivateNum >= 10)
			{
				_deactivateNum=0;
				if ((m_cTime - m_pTime) >= 100)
				{
					m_isSlowFrameRate=true;
				}
				else
				{
					m_isSlowFrameRate=false;
				}
				if (GameIni.FPS == 30)
				{
					m_SlowFrameRate=((m_cTime - m_pTime - 33) / 33) + 2;
				}
				else
				{
					m_SlowFrameRate=((m_cTime - m_pTime - 40) / 40) + 2;
				}
			}
			else
			{
				++_deactivateNum;
			}
			m_pTime=m_cTime;
		}

		private function barPercentHandler(e:WorldEvent):void
		{
			var langval:Object=GameIni.langval;
			//var descStr:String = null == langval? "Load UI File":langval["load_ui_file"];
			var descStr:String=null == langval ? "加载UI资源" : langval["load_ui_file"];
			//免得两边都在操纵进度条，造成进度条闪
			//if(LoadBar["desc"].text.indexOf("加载ui文件") >= 0)
			//if(LoadBar["desc"].text.indexOf("UI File") >= 0)
			if (LoadBar["desc"].text.indexOf(descStr) >= 0)
			{
				return;
			}
			if (null != LoadBar)
			{
				LoadBar["bar"].gotoAndStop(e.data);
			}
		}

		/**
		 * 重连
		 * @param e
		 *
		 */
		private function chongLianHandler(e:WorldEvent):void
		{
			isHideLoadBarUI=true;
			HideLoadBarUI();
		}

		private function fullScreen():void
		{
			//必定全屏
			WorldDispatcher.instance.addEventListener(WorldDispatcher.SysConfig_QUANPING, fullScreenByMap);
			//SysConfig.SCSystemSetting(NewRole_new.sysSet,true);
			SysConfig.getInstance().SCSystemSetting(NewRole_new.sysSet);
			SysConfig.tellClose2(true);
		}

		private function fullScreenByMap(e:WorldEvent=null):void
		{
			centerKing();
		}

		public function centerKing():void
		{
			if (Data.myKing.king != null)
			{
				Data.myKing.king.CenterAndShowMap();
				Data.myKing.king.CenterAndShowMap2();
			}
		}

		public function hasRoleHandler(value:int):void
		{
			//0表示有角色，将直接进入游戏
			if (0 != value)
			{
				isHideLoadBarUI=true;
				HideLoadBarUI();
			}
		}

		private function inGroundHandler(e:WorldEvent):void
		{
			//inGround才消除
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.IN_GROUND, inGroundHandler);
			if (null != LoadBar)
			{
				//快些消失
				isHideLoadBarUI=true;
				HideLoadBarUI();
			}
			//TweenLite.delayedCall(0.5,fullScreen);
//			fullScreen();
		}

		private function loadCompleteHandler(e:DispatchEvent):void
		{
			var ld:Loadres=e.getInfo;
			if (null != ld)
			{
				ld.removeEventListener(DispatchEvent.EVENT_LOAD_PROGRESS, loadProgressHandler);
				ld.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadCompleteHandler);
			}
		}

		private function loadProgressHandler(e:DispatchEvent):void
		{
			if (null != LoadBar)
			{
				//[PercentLoaded, TotalLoadeded, list, names, bLoaded, bTotal];
				var arr:Array=e.getInfo;
				var b1:int=parseInt(arr[0]);
				if (b1 == 0)
				{
					b1=1;
				}
				if (b1 > 100)
				{
					b1=100;
				}
				LoadBar["bar"].gotoAndStop(b1);
				//var arr:Array=[PercentLoaded, TotalLoadeded, list, names, bLoaded, bTotal,e_target,n,totlen - 1];
				//LoadBar["desc"].text="加载ui文件" + " " + arr[2];
				var langval:Object=GameIni.langval;
				//var descStr:String = null == langval? "Load UI File":langval["load_ui_file"];				
				var descStr:String=null == langval ? "加载UI资源" : langval["load_ui_file"];
				LoadBar["desc"].text=descStr + " " + arr[7] + " " + arr[0] + "%";
			}
		}

		private function loadresHandler(e:WorldEvent):void
		{
			var ld:Loadres=e.data;
			if (null != ld)
			{
				ld.addEventListener(DispatchEvent.EVENT_LOAD_PROGRESS, loadProgressHandler);
				ld.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadCompleteHandler);
			}
		}

		private function mainLoadComplete(e:Event):void
		{
			Main.instance().removeEventListener(Main.MAIN_LOADED, mainLoadComplete);
			Main.instance().addtoStageHandler(null);
			Main.instance().LoadLocalResStart();
		}

		private function picSourceChangeHandler(e:WorldEvent):void
		{
			if (null != LoadBar)
			{
				//LoadBar["uil"].source=e.data;
			}
		}

		private function txtInfo2Handler(e:WorldEvent):void
		{
			if (null != LoadBar)
			{
				LoadBar["desc2"].htmlText=e.data;
			}
		}

		private function txtInfo3Handler(e:WorldEvent):void
		{
			if (null != LoadBar)
			{
				//LoadBar["txt_info3"].text += e.data + "  ";
			}
			PubData.LoginRecordStatus+=e.data + "  ";
			Stats.getInstance().addLog("LoginRecordStatus" + PubData.LoginRecordStatus);
		}

		private function txtInfoHandler(e:WorldEvent):void
		{
			trace(LoadBar)
			if (null != LoadBar && e.data != null)
			{
				trace(LoadBar.parent)
				trace(LoadBar.visible)
				LoadBar["desc"].text=e.data;
			}
			trace("=============")
		}
	}
}

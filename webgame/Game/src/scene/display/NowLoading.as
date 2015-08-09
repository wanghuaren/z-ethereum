package scene.display
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.Loadxml;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_HintResModel;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.clock.GameClock;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	import main.Main;
	
	import scene.load.GameNewLoadMain;
	import scene.manager.SceneManager;
	
	import ui.frame.UIMovieClip;
	import ui.layout.GameLayout;
	
	import world.FileManager;
	import world.WorldDispatcher;
	import world.WorldEvent;
	import world.WorldState;

	/**
	 *	2011-12-23 andy 整理
	 */
	public class NowLoading extends UIMovieClip
	{
		//private var count:int=0;
		private var firstL:Boolean=false;
		//private static var pictrue:int=1;
		private static var isShow:Boolean=false;

		private var noLocalres:Boolean;

		private var lastCurSta:String = "";
		private var curSta:String = "";


		private var _loadBg:Shape;
		private var _loadBar:MovieClip=null;
		private var _loadPic:Loader=null;

		public function get LoadBg():Shape
		{
			if (null == _loadBg)
			{
				_loadBg=new Shape();
				_loadBg.name="mc_black";
			}

			return _loadBg;
		}

		public function get LoadPic():Loader
		{
			if (null == _loadPic)
			{
				_loadPic=new Loader();
				_loadPic.contentLoaderInfo.addEventListener(Event.COMPLETE, picComplete);
				_loadPic.addEventListener(IOErrorEvent.IO_ERROR, loadErr);
			}

			if (null != _loadPic)
			{
				if (!GameNewLoadMain.FirstInGame)
				{
					_loadPic.alpha=0.0;
				}
			}

			return _loadPic;
		}
private function loadErr(e:IOErrorEvent):void{
	trace("nowloading 加载错误")
}
		public function get LoadBar():MovieClip
		{
			if (null == _loadBar)
			{
				_loadBar=gamelib.getswflink("game_login", "mNowLoading") as MovieClip;

				_loadBar["Loadtxt"].text="";
				_loadBar["Downtxt"].text="";
				_loadBar["btnRefReshPage"].addEventListener(MouseEvent.MOUSE_DOWN, refreshPageHandler);
			}

			//
			if (null != _loadBar)
			{

				if (!GameNewLoadMain.FirstInGame && 2 != _loadBar.currentFrame)
				{
					_loadBar.gotoAndStop(2);


				}
				else if (GameNewLoadMain.FirstInGame && 1 != _loadBar.currentFrame)
				{
					_loadBar.gotoAndStop(1);
				}

				//
				if (2 == _loadBar.currentFrame)
				{
					_loadBar['bar2'].visible=false;

					if (_loadBar.hasOwnProperty("Maptxt") && null != _loadBar["Maptxt"])
					{
						var jumpMapStr:String=Lang.getLabel("pub_jump_map", [SceneManager.instance.currentMapName]);

						if (null == jumpMapStr || "" == jumpMapStr)
						{
							jumpMapStr="正在前往" + SceneManager.instance.currentMapName + "...";
						}

						_loadBar["Maptxt"].text=jumpMapStr;
					}

					//
					_loadBar["Downtxt"].htmlText="";
					_loadBar["Loadtxt"].htmlText="";
					_loadBar["btnRefReshPage"].visible=false;
				}
				else
				{
					_loadBar['bar2'].visible=true;
					
					//------------------------------
					curSta = GameIni.currentState;
					
										
					var inGame:Boolean = false;
										
					if(curSta == WorldState.selectRole ||
					   curSta == WorldState.role)
					{
						lastCurSta = curSta;
						inGame = true;
						
					}else if(curSta == WorldState.ground && lastCurSta == WorldState.selectRole)
					{
						inGame = true;
						
					}else if(curSta == WorldState.ground && lastCurSta == WorldState.role)
					{
						inGame = true;
						
					}
					
					if(inGame)
					{
						var bar2Frame:int = _loadBar['bar2'].currentFrame;
						
						bar2Frame = Math.round(bar2Frame/2);
						
						var txtStr:String = Lang.getLabel("pub_load_in_game") + bar2Frame + "%";
						
						if(95*2 == _loadBar['bar2'].currentFrame)
						{
							_loadBar['bar2'].stop();
						}
						
						_loadBar["Downtxt"].htmlText=txtStr;
						WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, txtStr));
					}
					
					
					
					//------------------------------
				}
			}


			return _loadBar;
		}

		/**
		 *	单类
		 */
		private static var _instance:NowLoading;

		public static function getInstance():NowLoading
		{
			if (_instance == null)
			{
				_instance=new NowLoading();
			}

			return _instance;
		}

		public function NowLoading():void
		{

			init();

		}

		public function init():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			LoadBar;
			Main.instance().addEventListener(Main.LOCAL_RES_LOADED, resLOADED);
			ShowLoadBarUI();

			//
			WorldDispatcher.instance.addEventListener(WorldDispatcher.TXT_INFO, txtInfoHandler);
			WorldDispatcher.instance.addEventListener(WorldDispatcher.TXT_INFO2, txtInfo2Handler);

		}

		private function txtInfoHandler(e:WorldEvent):void
		{

			if (null != LoadBar && e.data != null)
			{
				if (1 == LoadBar.currentFrame)
				{
					LoadBar["Downtxt"].htmlText=e.data;
				}
				else
				{
					LoadBar["Downtxt"].htmlText="";
				}
			}

		}

		private function txtInfo2Handler(e:WorldEvent):void
		{
			if (null != LoadBar)
			{
				if (1 == LoadBar.currentFrame)
				{

					LoadBar["Loadtxt"].htmlText=e.data;
				}
				else
				{
					LoadBar["Loadtxt"].htmlText="";
				}
			}
		}

		private function onAdded(e:Event):void
		{
			trace("onAdded in NowLoading");
		}

		private function onRemoved(e:Event):void
		{
			trace("onRemoved in NowLoading");
		}

		public function picComplete(e:Event):void
		{

		}

		private function resLOADED(e:Event):void
		{
			if (noLocalres)
			{
				var hint:Pub_HintResModel=XmlManager.localres.HintXml.getResPath_ByRandom() as Pub_HintResModel;

				var txtStr:String="<font color='#00FF00' size='14'><b>" + Lang.getLabel("20025_SysConfig") + "</b></font>" + hint.hint_content;
				LoadBar["Loadtxt"].htmlText=txtStr;

				WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO2, txtStr));

			}
		}

		private function refreshPageHandler(e:MouseEvent):void
		{
			LoadBar["btnRefReshPage"].removeEventListener(MouseEvent.MOUSE_DOWN, refreshPageHandler);
			AsToJs.callJS("refreshpage");
		}

		//private function CompleteFunc():void
		//{
		//mc["pic"].alpha=0;

		//TweenLite.to(mc["pic"], 0.5, {alpha: 1});
		//}

		public function drawBg(w:int, h:int):void
		{
			if (w == LoadBg.width || h == LoadBg.height)
			{
				return;
			}
			//var shape:Shape=new Shape();
			LoadBg.graphics.clear();

			var LoadBgAlpha:Number=1.0;

			if (!GameNewLoadMain.FirstInGame)
			{
				LoadBgAlpha=0.0;
			}

			LoadBg.graphics.beginFill(0x000000, LoadBgAlpha);
			//+200表示要完全遮住，MAP_SIZE_W有可能在拖动时获得数值小于屏幕宽高
			//bg.graphics.drawRect(0, 0, GameIni.MAP_SIZE_W + 300, GameIni.MAP_SIZE_H + 300);
			LoadBg.graphics.drawRect(0, 0, w + 300, h + 300);
			LoadBg.graphics.endFill();

			LoadBg.x=0;
			LoadBg.y=0;

		}

		public function HideLoadBarUI():void
		{
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}

		}

		public var countadd:int=0;

		public function ShowLoadBarUI(e:Event=null):void
		{

			if (null == this.stage)
			{
				return;
			}


			var w:int=Main.instance().stage.stageWidth;
			var h:int=Main.instance().stage.stageHeight;

			countadd++;

			var needAdd:Boolean=false;

			if (null != this.LoadBg)
			{
				if (null == this.LoadBg.parent)
				{
					needAdd=true;
				}
			}


			if (null != this.LoadPic)
			{
				if (null == this.LoadPic.parent && null != this.LoadPic.content)
				{
					needAdd=true;
				}
			}


			if (null != this.LoadBar)
			{
				if (null == this.LoadBar.parent)
				{
					needAdd=true;

				}

				//if(countadd > 26)
				//if (countadd > 6)
				if (countadd > 8)
				{
					this.LoadBar.visible=true;
				}
				else
				{
					this.LoadBar.visible=false;
				}

			}

			//x,y
			if (null != LoadBg)
			{
				//x,y里面有设
				drawBg(w, h);
			}

			if (null != LoadPic && null != LoadPic.content)
			{
				if (1 == GameLayout.LOADING_PIC_ALIGN_MODE)
				{
					LoadPic.x=w / 2;
					LoadPic.y=0;

					var pcn:Number=h / GameLayout.LOAD_X_JPG_INFO.Height_;

					LoadPic.content.width=pcn * GameLayout.LOAD_X_JPG_INFO.Width_;
					LoadPic.content.height=h;

					LoadPic.x-=(pcn * GameLayout.LOAD_X_JPG_INFO.Width_) / 2;
				}

				if (2 == GameLayout.LOADING_PIC_ALIGN_MODE)
				{
					LoadPic.x=(w - LoadPic.content.width) >> 1; // 2;
					LoadPic.y=((h - LoadPic.content.height) >> 1 ) - 55;

				}

			}

			if (null != LoadBar)
			{
				if (1 == GameLayout.LOADING_PIC_ALIGN_MODE)
				{
					replace();

					LoadBar.x=LoadBar.x - GameLayout.LOGIN_FLA_DOC.LoadBarWidth_ / 2;
					LoadBar.y=h - GameLayout.LOGIN_FLA_DOC.LoadBarHeight_;
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
						var upH:int=202;

						if (null != LoadPic.content)
						{
							//不完全贴图片底边，再往上一点
							this.LoadBar.y=LoadPic.y + LoadPic.content.height - upH + 90;
						}
						else
						{
							//不完全贴图片底边，再往上一点
							this.LoadBar.y=LoadPic.y + GameLayout.LOAD_X_JPG_INFO.Height_ - upH + 90;
						}
					}
						//------------
				}


			}


			if (needAdd)
			{
				if (null != LoadBg)
				{
					if (this.contains(LoadBg) == false)
						this.addChild(LoadBg);
				}

				if (null != LoadPic && null != LoadPic.content)
				{


					if (!GameNewLoadMain.FirstInGame)
					{
						LoadPic.alpha=0.0;
					}
					if (this.contains(LoadPic) == false)
						this.addChild(LoadPic);
				}

				if (null != LoadBar)
				{
//					if (this.contains(LoadBar)==false)
					this.addChild(LoadBar);
				}

			}


		}

		/**
		 *	nowloading 显示
		 */
		public function show(first:Boolean=false):void
		{
			//
			if (!PubData.LoadUI.contains(this))
			{
				PubData.LoadUI.addChild(this);
			}

			GameClock.instance.removeEventListener(WorldEvent.CLOCK__, ShowLoadBarUI);
			GameClock.instance.addEventListener(WorldEvent.CLOCK__, ShowLoadBarUI);



			var pic_str:String;

			if (!isShow || firstL)
			{
				//countadd=0;
				if (!PubData.mainUI.contains(PubData.LoadUI))
				{
					//					
					PubData.mainUI.addChild(PubData.LoadUI);
					ShowLoadBarUI();
				}
				noLocalres=!(first && Loadxml.localres_complete);
				if (!first && !firstL)
				{
					var map_id:int=SceneManager.instance.currentMapId;
					if (map_id < 1)
						map_id=GameIni.MAP_ID;
					var map:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(map_id) as Pub_MapResModel;
					var arr:Array;

					arr=map.loading_pic.split(",");

					if (null == cur_pic_str)
					{
						var pic_num:int=arr[int(Math.random() * arr.length)];

						if (pic_num >= 3)
						{
							pic_num=2;
						}

						cur_pic_str=pic_str=FileManager.instance.getLoadIconById(pic_num);
						//mc["pic"].source=pic_str;
						LoadPic.load(new URLRequest(cur_pic_str), new LoaderContext(true));

						WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.PIC_SOURCE, pic_str));
					}

					//mc["pic"].alpha=0;

//					var hint:Pub_HintResModel=XmlManager.localres.HintXml.getResPath_ByRandom();
//
//					var txtStr:String="<font color='#00FF00' size='14'><b>" + Lang.getLabel("20025_SysConfig") + "</b></font>" + hint.hint_content;
//
//					//_instance.mc["Loadtxt"].htmlText=txtStr;
//
//					WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO2, txtStr));

				}
				else if (first && !firstL)
				{

					if (null == cur_pic_str)
					{
						var pic_num:int=(int(Math.random() * 2) + 1);

						if (pic_num >= 3)
						{
							pic_num=2;
						}

						cur_pic_str=pic_str=FileManager.instance.getLoadIconById(pic_num);


						LoadPic.load(new URLRequest(cur_pic_str), new LoaderContext(true));

						WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.PIC_SOURCE, pic_str));

					}

//					if (!noLocalres)
//					{
//						var hint:Pub_HintResModel=XmlManager.localres.HintXml.getResPath_ByRandom();
//
//						var txtStr:String="<font color='#00FF00' size='14'><b>" + Lang.getLabel("20025_SysConfig") + "</b></font>"
//						if (hint != null)
//						{
//							txtStr+=hint.hint_content;
//						}
//						//_instance.mc["Loadtxt"].htmlText=txtStr;
//
//						WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO2, txtStr));
//
//					}
				}
				if (!isShow)
				{
					isShow=true;
					setBarScaleX(1);
					this.showtime2();
				}
			}


			//	PubData.mainUI.stage.addChild(PubData.LoadUI);
			firstL=first;
		}

		public function showtime2():void
		{
			// fux 对象池满情况处理
			//上古传说2清内存的地方
		}

		/**
		 *	进度条数据
		 */
		public function setBarScaleX(scalex:Number, desc:String=""):void
		{
			if (scalex != 1)
				return;
			scalex=scalex < 0 ? 0 : scalex;
			scalex=scalex > 1 ? 1 : scalex;
			//mc["bar2"].scaleX=scalex;

			this.timerByBar2();
			//mc["Downtxt"].text=desc;
		}

		/**
		 *	nowloading 隐藏
		 */
		public function hide():void
		{
			//test
			//return;
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.TXT_INFO, txtInfoHandler);
			WorldDispatcher.instance.removeEventListener(WorldDispatcher.TXT_INFO2, txtInfo2Handler);


			//fux 这里加入即可，不需要再在onComplete里面设，
			//可解决切换地图时调窗口大小的bug
			GameIni.currentState=WorldState.ground;

			//
			this._timerByBar2.reset();
			this.removeTimerByBar2TimerHandler();

			var p:int=100;
			//mc["bar2"].gotoAndStop(p);
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.BAR_PERCENT, p));


			//var txtStr:String= "正在读入数据,请稍候...(100%)";
			//var txtStr:String= "加载完成!(100%)";

			var txtStr:String=Lang.getLabel("pub_load_in_game") + "100%";

			//mc["Downtxt"].text=txtStr;			
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, txtStr));


			isShow=false;
			this.alpha=1;
			

			onComplete();

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.IN_GROUND));

		}


		public static var cur_pic_str:String=null;

		private function onComplete():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__, ShowLoadBarUI);

			//
			this._timerByBar2.reset();
			this.removeTimerByBar2TimerHandler();

			//mc["bar2"].Stop(1);
			//mc["Downtxt"].text="";
			//mc["Loadtxt"].text="";

			//			
			HideLoadBarUI();
			countadd = 0;
			this.alpha=1;

			//在初始或在onComplete时设一次图像
//			var pic_str:String;
//
//			var pic_num:int=(int(Math.random() * 2) + 1);
//
//			if (pic_num >= 3)
//			{
//				pic_num=2;
//			}
//
//			cur_pic_str=pic_str=FileManager.instance.getLoadIconById(pic_num);
//						
//			LoadPic.load(new URLRequest(cur_pic_str),new LoaderContext(true));
		}

		/**
		 *	进度条控制
		 */
		private var _timerByBar2:Timer;

		//private var bar2Mode:int=1;

		private function timerByBar2():Timer
		{
			if (null == _timerByBar2)
			{
				//_timerByBar2 = new Timer(200,10);			

				//慢一点
				_timerByBar2=new Timer(300, 200);
			}

			if (!_timerByBar2.hasEventListener(TimerEvent.TIMER))
			{
				_timerByBar2.addEventListener(TimerEvent.TIMER, timerByBar2TimerHandler);
			}

			if (!_timerByBar2.running)
			{
				_timerByBar2.reset();
				_timerByBar2.start();
			}

			return _timerByBar2;
		}

		private function timerByBar2TimerHandler(event:TimerEvent):void
		{
			var p:int=_timerByBar2.currentCount;
			LoadBar["bar2"].gotoAndStop(p);
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.BAR_PERCENT, p));

			//var txtStr:String = "正在读入数据,请稍候...(" + _timerByBar2.currentCount * 10 + "%)";
			//mc["Downtxt"].text=txtStr;
			//WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO,txtStr));

			if (190 == _timerByBar2.currentCount)
			{
				this._timerByBar2.reset();
				this.removeTimerByBar2TimerHandler();
			}
		}

		private function removeTimerByBar2TimerHandler():void
		{
			_timerByBar2.removeEventListener(TimerEvent.TIMER, timerByBar2TimerHandler);
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
				m_gPoint.y=((mc.stage.stageHeight) >> 1) ;

				m_lPoint=mc.parent.globalToLocal(m_gPoint);

				//
				//var b:Number = 2500/mc.stage.stageWidth;
				//m_lPoint.x = m_lPoint.x * b;

				
				mc.x=m_lPoint.x;
				//mc.y = m_lPoint.y;


			}


		}

	}
}

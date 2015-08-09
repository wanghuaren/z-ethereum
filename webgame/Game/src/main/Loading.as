package main
{
	import com.xh.config.Global;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.SelfConf;
	import common.config.xmlres.Loadxml;
	
	import engine.event.DispatchEvent;
	import engine.load.Loadres;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import sample.Astar.throwWhenOutOfMemory;
	
	import ui.layout.GameLayout;

	public class Loading extends MovieClip
	{
		private var loadres:Loadres;
		private var gameLoadTxtLoader:Loadxml;
		//private var gameDataTxtLoader:Loadxml;
		private var loadloadinglang:Loadxml;
		private var urlval:Object;
		private var langval:Object;
		private var loadXmlErrorCount:int;
		private const loadXmlMaxErrorCount:int=3;
		private var _timerByBar2:Timer;
		private const bar2Mode:int=1;
		//"LoadBar"
		public var LoadBar:MovieClip;
		public var LoadPic:Loader;
		public var LoadBg:MovieClip;

		public function Loading():void
		{
			Security.allowDomain("*");
			urlval=this.loaderInfo.parameters;
			//2012-10-18 andy 登陆名字滚屏显示  XX进入玄仙传奇
			if (urlval != null && urlval.hasOwnProperty("loginuser"))
			{
				GameIni.url_loginuser=urlval["loginuser"];
			}
			if (stage)
			{
				addtoStageHandler(null);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addtoStageHandler);
			}
		}

		private function addtoStageHandler(e:Event=null):void
		{
			this.stage.align=StageAlign.TOP_LEFT;
			this.stage.scaleMode=StageScaleMode.NO_SCALE;
			this.stage.quality=StageQuality.LOW;
			GameIni.FPS=this.stage.frameRate;
			//
			this.addEventListener(IOErrorEvent.IO_ERROR, IO_ERROR);
			LoadStart();
			//
			this.addEventListener(Event.ENTER_FRAME, resizeHandler);
		}
		public var countadd:int=0;

		private function resizeHandler(e:Event=null):void
		{
			var w:int=this.stage.stageWidth;
			var h:int=this.stage.stageHeight;
			countadd++;
			//LoadBg
			if (null == LoadBg)
			{
				var APP1:ApplicationDomain=this.loaderInfo.applicationDomain;
				var linkmc1:Class=APP1.getDefinition("LBg") as Class;
				LoadBg=new linkmc1();
			}
			//LoadBar
			if (null == LoadBar)
			{
				var APP2:ApplicationDomain=this.loaderInfo.applicationDomain;
				var linkmc2:Class=APP2.getDefinition("LBar") as Class;
				LoadBar=new linkmc2();
				LoadBar.visible=false;
			}
			else
			{
				if (countadd >= 5)
				{
					LoadBar.visible=true;
				}
				else
				{
					LoadBar.visible=false;
				}
			}
			//------------------------------------------------------------------------------
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
			//-------------------------------------   begin    -------------------------------------
			//x,y
			if (null != this.LoadBg)
			{
				LoadBg.x=0;
				LoadBg.y=0;
				LoadBg.width=w;
				LoadBg.height=h;
			}
			if (null != this.LoadPic)
			{
				if (null != LoadPic.content)
				{
					if (1 == GameLayout.LOADING_PIC_ALIGN_MODE)
					{
						LoadPic.x=w / 2;
						LoadPic.y=0;
						//1440 x 900 是图片宽高
						//h 
						var pcn:Number=h / GameLayout.LOAD_X_JPG_INFO.Height_;
						LoadPic.content.width=pcn * GameLayout.LOAD_X_JPG_INFO.Width_;
						LoadPic.content.height=h;
						LoadPic.x-=(pcn * GameLayout.LOAD_X_JPG_INFO.Width_) / 2;
							//w
						/*var pcn:Number=w / GameLayout.LOAD_X_JPG_INFO.Width_;
						LoadPic.content.width=w;
						LoadPic.content.height=pcn * GameLayout.LOAD_X_JPG_INFO.Height_;
						LoadPic.x -= (pcn * GameLayout.LOAD_X_JPG_INFO.Width_)/2;*/
					}
					if (2 == GameLayout.LOADING_PIC_ALIGN_MODE)
					{
						LoadPic.x=(w - LoadPic.content.width) >> 1; // 2;
						LoadPic.y=(h - LoadPic.content.height) >> 1;
					}
				}
			}
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
						var upH:int=202;
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
			//-------------------------------------   end    -------------------------------------
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
			//------------------------------------------------------------------------------
		}
		private var count:int=0;

		private function LoadingHandler(e:Event):void
		{
			var pcent:int=int(this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal * 100);
			if (null != LoadBar)
			{
				LoadBar["bar"].scaleX=pcent / 100;
				//LoadBar["desc"].text = "Init: "  + String(pcent) + "[" + this.loaderInfo.bytesLoaded + ":" + this.loaderInfo.bytesTotal + "]%";
				LoadBar["desc"].text="Init: " + String(pcent) + "%  进度：" + (count++) + "-" + this.loaderInfo.bytesLoaded + "--" + this.loaderInfo.bytesTotal;
				LoadBar["desc2"].text="";
			}
			if (pcent >= 100)
			{
				this.removeEventListener(Event.ENTER_FRAME, LoadingHandler);
				LoadStart();
			}
		}

		private function LoadStart():void
		{
			gameDataTxtComplete();
		}
		private var loadhttp:String;

		private function gameDataTxtComplete(e:DispatchEvent=null):void
		{
			GameIni.CONNECT_IP=urlval.ServerAddress;
			GameIni.CONNECT_PORT=urlval.Port;
			loadhttp=urlval.ResAddressMax;
			GameIni.HTTP_IP0=GameIni.HTTP_IP1=loadhttp;
			if (loadhttp != null)
			{
				Global.ASSET_URL_SUFFIX=loadhttp.replace("GameRes/", "");
			}
			Security.loadPolicyFile(loadhttp + "crossdomain.xml");
			this.loadloadinglangStart(loadhttp);
		}

		public function picComplete(e:Event):void
		{
			
		}

		public function picError(e:Event):void
		{
		}

		private function loadloadinglangStart(loadhttp:String):void
		{
			//加载语言包
			loadloadinglang=new Loadxml();
			loadloadinglang.addEventListener("loadComplete", loadloadinglangComplete);
			loadloadinglang.addEventListener("IOErrorEvent", loadloadinglangIOError);
			loadloadinglang.addEventListener("XMLSecurityError", loadloadinglangSecurityError);
			//加载语言包;
			if (null != LoadBar)
			{
				LoadBar["desc"].text="Language Loading...";
				LoadBar["desc2"].text="";
			}
			loadloadinglang.loadfile(loadhttp + "localres/gameloadinglang.amd");
		}

		private function loadloadinglangComplete(e:DispatchEvent):void
		{
			loadloadinglang.removeEventListener("loadComplete", loadloadinglangComplete);
			loadloadinglang.removeEventListener("IOErrorEvent", loadloadinglangIOError);
			loadloadinglang.removeEventListener("XMLSecurityError", loadloadinglangSecurityError);
			//;
			var langxml:XML=new XML(e.getInfo);
			var scriptList:XMLList=langxml.script;
			langval=new Object();
			for each (var sc:XML in scriptList)
			{
				var variList:XMLList=sc.vari;
				var n:String;
				var t:String;
				for each (var c:XML in variList)
				{
					n=c.@n;
					t=c.text();
					langval[n]=t;
				}
			}
			GameIni.langval=langval;
			// 检FP播放版本
			if (urlval != null && urlval.hasOwnProperty("PlayerVersion"))
			{
				if (null != LoadBar)
				{
					//LoadBar["desc"].text = "检测您的Flash播放控件版本...(" + urlval["PlayerVersion"] + ")";
					LoadBar["desc"].text=langval["check_your_flashPlayer_version"] + "...(" + urlval["PlayerVersion"] + ")";
					LoadBar["desc2"].text="";
				}
				LoadingInit();
			}
			else
			{
				LoadingInit();
			}
			//pic
			LoadPic=new Loader();
			LoadPic.contentLoaderInfo.addEventListener(Event.COMPLETE, picComplete);
			LoadPic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, picError);
			//;
//			var pic_num:int=(int(Math.random() * 2) + 1);
//
//			if (pic_num >= 3)
//			{
//				pic_num=2;
//			}
			//var loadhttp:String=GameIni.GAMEDATAXML.LoadServer[0].@loadhttp;
//			var picUrl:String=loadhttp + "Icon/Load_" + pic_num.toString() + ".jpg";
			var picUrl:String=loadhttp + "Icon/Load_1.jpg";
			LoadPic.load(new URLRequest(picUrl), new LoaderContext(true));
		}

		private function LoadingInit():void
		{
			////因为要改变加载文件结构   要从网页中读取  所以 urlvar 移动到此处加载
			//GameIni.urlval=urlval;
			//
			//GameIni.url_pay=urlval.rmb.replace(/\|\|/g, "&");
			//PubData.account=urlval.login_account;
			if (null != LoadBar)
			{
				LoadBar["bar"].scaleX=1;
				//LoadBar["desc"].text="正在加载游戏，请稍候...";
				LoadBar["desc"].text=langval["loading_now_please_wait"];
				//LoadBar["desc2"].text = "如果您是第一次打开游戏，加载可能较慢，请耐心等等.";
				LoadBar["desc2"].text=langval["if_you_first_run_game_please_wait"];
			}
			gameLoadTxtLoader=new Loadxml();
			gameLoadTxtLoader.addEventListener(DispatchEvent.EVENT_IO_ERROR, gameLoadTxtIOErrorEvent);
			gameLoadTxtLoader.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, gameLoadTxtComplete);
			gameLoadTxtLoader.addEventListener(DispatchEvent.EVENT_XML_SECURITY_ERROR, XMLSecurityError);
			//gameLoadTxtLoader.loadfile(GameIni.GAMELOADTXT);
			gameLoadTxtLoader.loadfile(loadhttp + "localres/gameload.txt?ver=" + Math.random());
		}

		private function gameLoadTxtComplete(e:DispatchEvent):void
		{
			gameLoadTxtLoader.removeEventListener(DispatchEvent.EVENT_IO_ERROR, gameLoadTxtIOErrorEvent);
			gameLoadTxtLoader.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, gameLoadTxtComplete);
			gameLoadTxtLoader.removeEventListener(DispatchEvent.EVENT_XML_SECURITY_ERROR, XMLSecurityError);
			var arr:String=e.getInfo;
			var xml:XML=XML(arr);
			xml.appendChild(<info url="../game_main.swf" ver="201201010101"/>);
			GameIni.GAMELOADXML=xml;
			Object["Loadxmldata"]=xml;
			GameIni.MAP_VER=xml.Map[0].@LoadVersion;
			GameIni.LOCAL_RES_VER=xml.info[0].@ver;
			var url:Array=[];
			var Ran:String="";
			//var loadhttp:String=GameIni.GAMEDATAXML.LoadServer[0].@loadhttp;
			for (var s in xml[0].info)
			{
				if (GameIni.ver.length < 3)
				{
					GameIni.ver=xml.info[s].@ver;
				}
				url.push(loadhttp + xml.info[s].@url + "?ver=" + xml.info[s].@ver + Ran);
			}
			//fux 延迟加载ui_index等
			for (var s in xml[0].info0)
			{
				Loadres.info0.push(loadhttp + xml.info0[s].@url + "?ver=" + xml.info0[s].@ver + Ran);
			}
			if (0 == Loadres.info1.length)
			{
				for (var s in xml[0].info1)
				{
					Loadres.info1.push(loadhttp + xml.info1[s].@url + "?ver=" + xml.info1[s].@ver + Ran);
				}
			}
			//andy game_index拆分
			for (var s in xml[0].info2)
			{
				Loadres.info2.push(loadhttp + xml.info2[s].@url + "?ver=" + xml.info2[s].@ver + Ran);
			}
//			for (var s in xml[0].info3)
//			{
//				Loadres.info3.push(loadhttp + xml.info3[s].@url + "?ver=" + xml.info3[s].@ver + Ran);
//			}
			Loadres.info3_suffix=xml.info3_suffix[0].@value;
			// 侦听资源加载
			loadres=new Loadres();
			loadres.addEventListener(DispatchEvent.EVENT_LOAD_PROGRESS, loadProgress);
			loadres.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadComplete);
			loadres.addEventListener(DispatchEvent.EVENT_SECURITY_ERROR, SecurityError);
			loadres.addEventListener(DispatchEvent.EVENT_IO_ERROR, loadIOError);
			//
			//LoadBar["desc"].text="Loading: 准备加载资源" + url.length;
			LoadBar["desc"].text="Loading: " + langval["ready_load_resouce"] + url.length;
			loadres.load(url);
		}

		private function loadIOError(e:DispatchEvent):void
		{
			trace(e.type + ",loading 加载错误")
		}

		private function loadProgress(e:DispatchEvent):void
		{
			var arr:Array=e.getInfo as Array;
			if (arr.length > 0)
			{
				// LoadBar["bar"].scaleX=int(arr[1])/100;
				var b1:int=parseInt(arr[1]);
				//Debug.instance.traceMsg("b1:" + b1);
				if (0 == b1)
				{
					b1=1;
				}
				LoadBar["bar"].scaleX=1;
				LoadBar["bar"].gotoAndStop(b1);
				b1=b1 > 100 ? 100 : b1;
				//LoadBar["desc"].text="正在读入数据,请稍候...(" + String(arr[1]) + "%)";
				LoadBar["desc"].text=langval["reading_data_please_wait"] + "..." + b1 + "%";
				if (0 == bar2Mode)
				{
					var b2:int=parseInt(arr[0]);
					//Debug.instance.traceMsg("b2:" + b2);
					if (0 == b2)
					{
						b2=1;
					}
						//LoadBar["bar2"].gotoAndStop(b2);
						//LoadBar["desc2"].text = "Now Loading(" + String(arr[4]) + "/" + String(arr[5]) + ")..." + String(arr[0]) + "%";
						//LoadBar["desc2"].text = "Now Loading..." + String(arr[0]) + "%";
				}
				else if (1 == bar2Mode)
				{
					timerByBar2();
				} //end if
			}
		}

		private function loadComplete(e:DispatchEvent):void
		{
			//test
			//return;
			if (1 == bar2Mode)
			{
				timerByBar2();
				this._timerByBar2.reset();
				this._timerByBar2.removeEventListener(TimerEvent.TIMER, timerByBar2TimerHandler);
				this._timerByBar2=null;
					//100
					//LoadBar["bar2"].gotoAndStop(100);
					//LoadBar["desc2"].text = "Now Loading...100%";
			}
			loadres.removeEventListener(DispatchEvent.EVENT_SECURITY_ERROR, SecurityError);
			loadres.removeEventListener(DispatchEvent.EVENT_LOAD_PROGRESS, loadProgress);
			loadres.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadComplete);
			//
			this.removeEventListener(Event.ADDED_TO_STAGE, addtoStageHandler);
			//test
			//return;
			//
			if (this.countadd <= 5)
			{
				this.countadd=5;
				resizeHandler();
			}
			this.removeEventListener(Event.ENTER_FRAME, resizeHandler);
			//LoadBar["desc"].text = "配置完成！ 正在初始化游戏...请稍候... ...";
			LoadBar["desc"].text=langval["config_complete_init_game_now"] + "..." + langval["wait"] + "... ...";
			//LoadBar["desc2"].text = "";
			//test
			//return;
			//LoadBar.visible=false;
			//LoadBg.visible=false;
			//LoadPic.visible=false;
			setTimeout(function(_this:Loading):void
			{
				var loader:Loader=Loadres.resSWF["game_main"] as Loader;
				loader.name="game_main1";
				loader.content["setLoadBar"](_this["LoadBg"], _this["LoadBar"], _this["LoadPic"]);
				//_this.addChild(loader);
				_this.addChildAt(loader, 0);
				loader.content["setLoadingRes"](Loadres.resSWF, Loadres.resAPP, urlval);
//				while(this.numChildren)
//					this.removeChildAt(0)
			}, 100, this);
		}

		public function timerByBar2():Timer
		{
			if (null == _timerByBar2)
			{
				_timerByBar2=new Timer(200, 10);
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
			//LoadBar["bar2"].gotoAndStop(_timerByBar2.currentCount*10);
			//LoadBar["desc2"].text = "Now Loading..." + String(_timerByBar2.currentCount*10) + "%";
		}
		private var currFrame:int=1;

		private function gameLoadTxtIOErrorEvent(e:DispatchEvent):void
		{
			//LoadBar["desc"].text="Error：GameLoad.Txt加载失败,请检查相关配置";
			if (null != LoadBar)
			{
				LoadBar["desc"].text="正在加载资源,请稍候...... : )";
			}
			currFrame+=1;
			LoadBar["bar"].gotoAndStop(int(currFrame / 100));
			if (currFrame > 10000)
				currFrame=1;
			gameLoadTxtLoader.loadfile(loadhttp + "localres/gameload.txt?ver=" + Math.random());
		}

		private function loadloadinglangIOError(e:DispatchEvent):void
		{
			this.loadXmlErrorCount++;
			if (this.loadXmlErrorCount >= this.loadXmlMaxErrorCount)
			{
				if (null != LoadBar)
				{
					LoadBar["desc"].text="Load Language ERROR";
				}
			}
			else
			{
				loadloadinglangStart(this.loadhttp);
			}
		}

		private function loadloadinglangSecurityError(e:DispatchEvent):void
		{
			if (null != LoadBar)
			{
				LoadBar["desc"].text="Load Language SecurityError";
			}
		}

		private function XMLSecurityError(e:DispatchEvent):void
		{
			if (null != LoadBar)
			{
				//LoadBar["desc"].text="[xml]无法访问策略文件，请管理员检查服务器";
				LoadBar["desc"].text="SecurityError: Load crossdomain.xml failed";
			}
			gameLoadTxtLoader.loadfile(loadhttp + "localres/gameload.txt?ver=" + Math.random());
		}

		private function IO_ERROR(e:IOErrorEvent):void
		{
			if (null != LoadBar)
			{
				LoadBar["desc"].text="IO ERROR: " + e.type;
			}
		}

		private function SecurityError(e:DispatchEvent):void
		{
			loadres.removeEventListener(DispatchEvent.EVENT_SECURITY_ERROR, SecurityError);
			//LoadBar["desc"].text="无法访问资源策略文件，请检查服务器文件状态";
			if (null != LoadBar)
			{
				LoadBar["desc"].text=langval["can_not_access_securityDomainXml_please_check"];
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
	}
}

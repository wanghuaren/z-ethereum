package main
{
	import com.bellaxu.def.LayerDef;
	import com.xh.config.Global;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.SelfConf;
	import common.config.XmlConfig;
	import common.config.xmlres.Loadxml;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.load.Loadres;
	import engine.utils.Debug;
	import engine.utils.compress.ZipDCoder;
	import engine.utils.compress.ZipEvent;
	import engine.utils.compress.ZipFile;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import netc.DataKey;
	
	import nets.packets.PacketSCPlayerData;
	import nets.packets.PacketSCPlayerDataMore;
	
	import scene.display.NowLoading;
	import scene.load.ReadMapData;
	import scene.manager.ParsePathrFile;
	
	import ui.base.login.Login;
	import ui.base.login.NewRole_new;
	import ui.base.login.SelectRole;
	import ui.base.mainStage.UI_index;
	
	import world.WorldDispatcher;
	import world.WorldEvent;
	import world.WorldState;

	public class Main extends Sprite
	{
		//private var _dicLoadXML:Dictionary=new Dictionary(true);

		//-----------------------------  Layer  begin -----------------------------------------------------

		public var Layer0:Sprite=new Sprite();

		public var AlertUI:Sprite=new Sprite();

		public var AlertUI2:Sprite=new Sprite();

		public var Layer5:Sprite=new Sprite();

		public var LoadUI:Sprite=new Sprite();

		public var cartoon:Sprite=new Sprite();

//		public var LoadTopUI:Sprite=new Sprite();

		//----------------------------- Layer  end -----------------------------------------------------

		public var isload:Boolean;
		private static var _instance:Main=null;

		public static var LOAD_COMPLETE:Boolean=false;
		public static var ROLE_MOVIE_LOADED:Boolean=false;

		public static var MAIN_LOADED:String="MAIN_TEST_LOAD_COMPLETE";
		public static var LOCAL_RES_LOADED:String="LOCAL_RES_LOAD_COMPLETE";

		public function Main():void
		{
			this.name="Main_as";
			Security.allowDomain("*");
			Debug.instance.traceMsg("游戏启动");
			this.mouseEnabled=false;
		}

		public static function instance(value:DisplayObject=null):Main
		{
			if (_instance == null)
			{
				_instance=new Main();
			}
			else if (value != null)
			{
				_instance.Layer0=value as Sprite;
				PubData.mainUI=_instance;
				_instance.addChild(_instance.Layer0);
			}
			return _instance;
		}

		public function mainInit():void
		{
			if (this.parent.parent != null)
			{
				LoadStart();
			}
		}

		public function refreshData():void
		{
			//PubData.socket.send("SRoleDetail", "CRoleDetail", CRoleDetail, {userid:PubData.roleID});
		}

		public function CRoleDetail(e:DispatchEvent):void
		{
			//CtrlFactory.getPubData().refresh(e.getInfo[0]);
			//PubData.socket.dispatchEvent(new DispatchEvent(EventACT.REFRESH));
		}

		public function setLoadingRes(resSWF:Dictionary, resAPP:Dictionary, urlval:Object=null):void
		{
			Loadres.resSWF=resSWF;
			Loadres.resAPP=resAPP;

			// 配置设定
			var xml:XML=XML(Object["Loadxmldata"]);

			GameIni.GAMELOADXML=xml;
			GameIni.MAP_VER=xml.Map[0].@LoadVersion;

			GameIni.LOCAL_RES_VER=xml.info[0].@ver;

//			GameIni.wangzhi=String(GameIni.GAMEDATAXML.WangZhi[0].@link);
//
//			// 安全配置文件请求地址AR
//			GameIni.HTTP_IP0=GameIni.GAMEDATAXML.LoadServer[0].@loadhttp;
			if (xml.hasOwnProperty("Refpage"))
				GameIni.canRefreshPage=int(xml.Refpage[0].@f5);
			if (xml.hasOwnProperty("Test"))
			{
				GameIni.packageRun=int(xml.Test[0].@runTime);
				GameIni.packageSleep=int(xml.Test[0].@sleepTime);
			}

			// 传参设定
			if (urlval.ResAddressMax != null)
			{
				GameIni.wangzhi=urlval.LogAddress;

				// 安全配置文件请求地址
				GameIni.HTTP_IP0=urlval.ResAddressMax;
				Global.ASSET_URL_SUFFIX=urlval.ResAddressMax.replace("GameRes/", "");

				GameIni.urlval=urlval;
//				PubData.loginStyle=urlval.login_style;

				if (urlval.hasOwnProperty("PlayerVersion"))
					GameIni.thisPlayerVersion="PlayerVersion:" + urlval["PlayerVersion"];
				if (urlval.hasOwnProperty("rmb"))
					GameIni.url_pay=urlval["rmb"].replace(/\|\|/g, "&");
				if (urlval.hasOwnProperty("vip"))
					GameIni.url_vip=urlval["vip"].replace(/\|\|/g, "&");
				if (urlval.hasOwnProperty("VipService"))
					GameIni.url_VipService=urlval["VipService"].replace(/\|\|/g, "&");
				if (urlval.hasOwnProperty("authorized"))
					GameIni.url_authorized=urlval["authorized"].replace(/\|\|/g, "&");
				if (urlval.hasOwnProperty("bbs"))
					GameIni.url_bbs=urlval["bbs"].replace(/\|\|/g, "&");
				if (urlval.hasOwnProperty("CardPage"))
					GameIni.url_CardPage=urlval["CardPage"].replace(/\|\|/g, "&");
				if (urlval.hasOwnProperty("home"))
					GameIni.url_home=urlval["home"].replace(/\|\|/g, "&");
				if (urlval.hasOwnProperty("weiduan"))
					GameIni.url_weiduan=urlval["weiduan"].replace(/\|\|/g, "&");
				if (urlval.hasOwnProperty("qq"))
					GameIni.url_qq=urlval["qq"];
				if (urlval.hasOwnProperty("tel"))
					GameIni.url_tel=urlval["tel"];
				if (urlval.hasOwnProperty("refpage"))
					GameIni.canRefreshPage=urlval["refpage"];
			}
			else
			{
				GameIni.wangzhi=SelfConf.wangzhi;

				// 安全配置文件请求地址
				GameIni.HTTP_IP0=SelfConf.httpIP;
			}
			// addtoStageHandler(null);
			// LoadHumanStart();
		}

		public function addtoStageHandler(e:Event):void
		{
			// 禁止本地打开================================================================>>>
			// if((this.loaderInfo.loaderURL.indexOf("///")!=-1)&&(this.loaderInfo.loaderURL.indexOf("★")==-1)) {
			// this.visible=false;
			// while (this.numChildren)this.removeChildAt(0);
			// return;
			// }
			// ==========================================================================>>>
			if (e == null)
			{
				//now use stat()
				//var FPS : FPSShow = new FPSShow();
				//stage.addChild(FPS);
			}

			this.x=0;
			this.y=0;

			PubData.mainUI=this;

			//登陆使用
			this.addChild(this.Layer0);
			this.Layer0.mouseEnabled = false;

			//窗体层
			PubData.AlertUI=this.AlertUI;
			this.addChild(AlertUI);
			AlertUI.mouseEnabled = false;

			//Alert窗口层
			PubData.AlertUI2=this.AlertUI2;
			this.addChild(AlertUI2);
			AlertUI2.mouseEnabled = false;

			//文字层
			//文字层不需要鼠标事件
			Layer5.mouseEnabled=Layer5.mouseChildren=false;
			this.addChild(Layer5);

			//切换地图遮罩，由stage addChild
			this.LoadUI.mouseEnabled=true; //注意这里是true
			this.LoadUI.mouseChildren=true;
			PubData.LoadUI=this.LoadUI;
			this.addChild(LoadUI);

			//剧情动画层
			PubData.StoryCartoon=cartoon;
			this.addChild(cartoon);



			// 检测服务器状态
			this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			// 全局IO错误
			// 程序调试

			var PT:Sprite=GamelibS.getswflink("game_login", "PT") as Sprite;

			//var currmc:DisplayObject = GamelibS.getswf("game_login") as DisplayObject;
			//new ProgramTest(currmc["PT"]);
			new ProgramTest(PT);

			// 初始化登录模块
//			ShowLoginUI();


			// 初始化音效模块
			//		GameMusic.playMusic("denglu.mp3");
			Debug.instance.traceMsg(GameIni.CONNECT_IP);
			Debug.instance.traceMsg(GameIni.CONNECT_PORT);
			Debug.instance.traceMsg(GameIni.GAMESERVERS);


		}

		private function ioErrorHandler(e:IOErrorEvent):void
		{
			Debug.instance.traceMsg("加载错误：" + e);
		}

		/**
		 * 显示登陆截面
		 *
		 */
		public function ShowLoginUI():void
		{
			// new Longin();
			// fux_map
			Login.instance.init();
			Layer0.addChild(Login.instance);
			NowLoading.getInstance().show(true);
			GameIni.currentState=WorldState.login;
			this.parent.stage.dispatchEvent(new Event(Event.RESIZE));

			// this.removeChild(currmc);
		}

		public function ShowSelectRoleUI():void
		{
			NowLoading.getInstance().hide();
			SelectRole.getInstance().addEventListener(Event.ADDED_TO_STAGE, _SelectRoleAddHandler);
			Layer0.addChild(SelectRole.getInstance());
			SelectRole.getInstance().init();
			GameIni.currentState=WorldState.selectRole;
			this.parent.stage.dispatchEvent(new Event(Event.RESIZE));     
		}
		
		private function _SelectRoleAddHandler(e:Event):void
		{
			SelectRole.getInstance().removeEventListener(Event.ADDED_TO_STAGE, _SelectRoleAddHandler);
			if (Login.instance.parent != null)
			{
				Login.instance.parent.removeChild(Login.instance);
			}
			if(NewRole_new.instance && NewRole_new.instance.parent)
			{
				NewRole_new.instance.parent.removeChild(NewRole_new.instance);
			}
		}
		
		public function ShowNewplayerUI():void
		{
			//===whr==加载创建界面后才把加载进度界面删除=
			NowLoading.getInstance().hide();
			NewRole_new.instance.addEventListener(Event.ADDED_TO_STAGE, newRoleAddHandler);
			//=========
			Layer0.addChild(NewRole_new.instance);
			NewRole_new.instance.init();
			GameIni.currentState=WorldState.role;
			this.parent.stage.dispatchEvent(new Event(Event.RESIZE));    
		}

		private function newRoleAddHandler(e:Event):void
		{
			NewRole_new.instance.removeEventListener(Event.ADDED_TO_STAGE, newRoleAddHandler);
//			Layer0.removeChild(Login.instance);
			if (Login.instance.parent != null)
			{
				Login.instance.parent.removeChild(Login.instance);
			}
			if(SelectRole.getInstance() && SelectRole.getInstance().parent)
			{
				SelectRole.getInstance().parent.removeChild(SelectRole.getInstance());
			}
		}

		public function ShowIndexUI():void
		{
			DataKey.instance.removeByPID(PacketSCPlayerDataMore.id);
			DataKey.instance.removeByPID(PacketSCPlayerData.id);

			UI_index.instance.open(true, false);
			UI_index.instance.init2();

			if (Layer0 == Login.instance.parent)
			{
				Layer0.removeChild(Login.instance);
			}

			if (Layer0 == NewRole_new.instance.parent)
			{
				Layer0.removeChild(NewRole_new.instance);
			}
			// fux_map
			GameIni.currentState=WorldState.ground;
			this.parent.stage.dispatchEvent(new Event(Event.RESIZE));

		}

		private function removeLayerChild(n:int):void
		{
			var layer:Object=this["Layer" + n];
			if (layer != null)
			{
				while (layer.numChildren)
				{
					layer.removeChildAt(0);
				}
			}
		}

		// ============================本地测试用 开始====================================
		/**
		 *	加载gameload.xml
		 */
		private function LoadStart():void
		{
			if (null == GameIni.GAMELOADXML && null == GameIni.GAMEDATAXML)
			{
				var gameLoadTxt:Loadxml=new Loadxml();
				gameLoadTxt.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, gameLoadTxtComplete);
//				gameLoadTxt.loadfile(GameIni.GAMELOADTXT);
				var s:String = SelfConf.httpIP
				gameLoadTxt.loadfile(SelfConf.httpIP + "localres/gameload.txt");

			}
			else
			{
				ReadGameLoadTxt();
			}
		}

		private function gameLoadTxtComplete(e:DispatchEvent):void
		{
			e.target.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, gameLoadTxtComplete);

			var xml:XML=new XML(e.getInfo);

			GameIni.GAMELOADXML=xml;

			gameDataTxtComplete();
		}

		private function gameDataTxtComplete(e:DispatchEvent=null):void
		{
			GameIni.CONNECT_IP=SelfConf.serverIP.split(":")[0];
			GameIni.CONNECT_PORT=SelfConf.serverIP.split(":")[1];

			GameIni.wangzhi=SelfConf.wangzhi;

			var loadhttp:String=SelfConf.httpIP;
			var loadhttp1:String=SelfConf.httpIP;

			Global.ASSET_URL_SUFFIX=loadhttp.replace("GameRes/", "");

			GameIni.HTTP_IP0=loadhttp;
			GameIni.HTTP_IP1=loadhttp1;

			GameIni.HTTP_IP0=loadhttp;
			GameIni.HTTP_IP1=loadhttp1;

			ReadGameLoadTxt();
		}

		private function ReadGameLoadTxt():void
		{
			var xml:XML=GameIni.GAMELOADXML;

			//--------------------------------------------------------------------		

			Object["Loadxmldata"]=xml;

			GameIni.MAP_VER=xml.Map[0].@LoadVersion;

			GameIni.LOCAL_RES_VER=xml.info[0].@ver;

			var loadhttp:String=SelfConf.httpIP;

			var url:Array=[];
			var s:String;
			var Ran:String="";
			for (s in xml[0].info)
			{
				url.push(loadhttp + xml.info[s].@url + "?ver=" + xml.info[s].@ver + Ran);
			}

			for (s in xml[0].info0)
			{
				Loadres.info0.push(loadhttp + xml.info0[s].@url + "?ver=" + xml.info0[s].@ver + Ran);
			}

			//fux 延迟加载game_index
			if (0 == Loadres.info1.length)
			{
				for (s in xml[0].info1)
				{
					Loadres.info1.push(loadhttp + xml.info1[s].@url + "?ver=" + xml.info1[s].@ver + Ran);
				}
			}

			// andy game_index拆分
			//for (var s in xml[0].info1) {
			for (s in xml[0].info2)
			{
				Loadres.info2.push(loadhttp + xml.info2[s].@url + "?ver=" + xml.info2[s].@ver + Ran);
			}

			Loadres.info3_suffix=xml.info3_suffix[0].@value;
			var loadres:Loadres=Loadres.getInstance().getItem;
			loadres.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadComplete);
			loadres.addEventListener(DispatchEvent.EVENT_IO_ERROR, loadIOError);
			loadres.load(url);

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.LOAD_RES, loadres));
		}

		private function loadIOError(e:DispatchEvent):void
		{
			trace(e.type + ",Main 加载错误")
		}

		private function loadComplete(e:DispatchEvent):void
		{
			var loadres:Loadres=e.getInfo;

			if (null != loadres)
			{
				loadres.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadComplete);
			}

			loadMsgXml();
		}

		// ============================本地测试用 结束====================================

		//本地测试和网页共同调用

		/**
		 *	加载服务端消息xml
		 */
		private var msgXml:Loadxml;

		private function loadMsgXml():void
		{
			msgXml=new Loadxml();
			msgXml.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadMsgXmlComplete);

			//var descStr:String = "Load SEVER MSG";//(msg.xml)
			var langval:Object=GameIni.langval;
			//var descStr:String = null == langval? "Load SEVER MSG":langval["load_server_msg"];

			var descStr:String=null == langval ? "加载服务器消息文件" : langval["load_server_msg"];

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));


			msgXml.addEventListener(DispatchEvent.EVENT_XML_LOAD_PER, loadMsgXmlPer);
			//加载服务器消息资源包id->msg
			msgXml.loadfile(GameIni.GAMESERVERS + XmlConfig.MsgXmlPath);
		}

		private function loadMsgXmlPer(e:DispatchEvent):void
		{
			var langval:Object=GameIni.langval;
			//var descStr:String = null == langval? "Load SEVER MSG":langval["load_server_msg"];

			var descStr:String=null == langval ? "加载服务器消息文件" : langval["load_server_msg"];

			descStr=descStr + " " + e.getInfo + "%";

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));


			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.BAR_PERCENT, e.getInfo));
		}

		private function loadMsgXmlComplete(e:DispatchEvent):void
		{
			if (null != msgXml)
			{
				msgXml.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadMsgXmlComplete);
				msgXml.removeEventListener(DispatchEvent.EVENT_XML_LOAD_PER, loadMsgXmlPer);
			}

			XmlConfig.MSGXML=XML(e.getInfo);

			//加载语言包
			loadLangXml();
		}

		private var langXml:Loadxml;

		private function loadLangXml():void
		{

			langXml=new Loadxml();

			langXml.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadLangXmlComplete);
			langXml.addEventListener(DispatchEvent.EVENT_XML_LOAD_PER, loadLangXmlPer);

			//var descStr:String = "Load LANG";//(lang.xml)
			var langval:Object=GameIni.langval;
			//var descStr:String = null == langval? "Load LANG":langval["load_game_main_lang"];

			var descStr:String=null == langval ? "加载语言包" : langval["load_game_main_lang"];

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));

			langXml.addEventListener(DispatchEvent.EVENT_XML_LOAD_PER, loadLangXmlPer);
			langXml.loadfile(GameIni.GAMESERVERS + XmlConfig.LangXmlPath);

		}

		private function loadLangXmlPer(e:DispatchEvent):void
		{
			var langval:Object=GameIni.langval;
			//var descStr:String = null == langval? "Load LANG":langval["load_game_main_lang"];

			var descStr:String=null == langval ? "加载语言包" : langval["load_game_main_lang"];


			descStr=descStr + " " + e.getInfo + "%";

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.BAR_PERCENT, e.getInfo));
		}


		private function loadLangXmlComplete(e:DispatchEvent):void
		{
			if (null != langXml)
			{
				langXml.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadLangXmlComplete);
				langXml.removeEventListener(DispatchEvent.EVENT_XML_LOAD_PER, loadLangXmlPer);
			}

			XmlConfig.LANGXML=XML(e.getInfo);

			/**
			 *	进入角色主界面
			 */
			this.dispatchEvent(new DispatchEvent(Main.MAIN_LOADED));
		}
		
		
		//--------  专门加载 Pub_Skill_Data.swf ----------
//		private var m_PSDLoader:Loader = null;
//		public function load_Pub_Skill_Data(e:DispatchEvent=null):void
//		{
//			if(null == m_PSDLoader)
//			{
//				m_PSDLoader = new Loader();
//				m_PSDLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,_onPSDComplete);
//				m_PSDLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onPSDError);
//			}
//			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, "正在加载技能数据..."));
//			var _url:String = XmlConfig.swfPSDFullName;
//			m_PSDLoader.load(new URLRequest(_url), new LoaderContext(false, ApplicationDomain.currentDomain));
//		}
		
		private function _onPSDComplete(e:Event=null):void
		{
			var _name:String = "Pub_Skill_DataXml1";
			var _clazz:* = (e.target as LoaderInfo).applicationDomain.getDefinition(_name);
			
			
//			var _data:Array = XmlConfig.getPSDInstanceByName(_name);
//			LoadLocalResStart();
		}
		
		private function _onPSDError(e:Event=null):void
		{
			trace("_onPSDError");
		}
		
		
		//---------------------------------------------

		private var libLoader:Loader;
		/**
		 *	加载本地化资源xml打包后的lib.swf
		 */
		public function LoadLocalResStart(e:DispatchEvent=null):void
		{
			trace("LoadLocalResStart---------lib.swf", getTimer());
			if (libLoader == null)
			{
				libLoader=XmlConfig.xmlLibLoader;
				libLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, xmlLibComplete);
				libLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, xmlLibError);
				libLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, xmlLibProgress);
			}
			//var descStr:String = "Load DB File";//(db.zip)
			var langval:Object=GameIni.langval;
			//var descStr:String = null == langval? "Load DB File":langval["load_db_zip"];
			//load db for what?
			var descStr:String=null == langval ? "加载DB文件" : langval["load_db_zip"];

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));
			libLoader.load(new URLRequest(XmlConfig.swfXmlLibFullName), new LoaderContext(false, ApplicationDomain.currentDomain));

		}

		private function xmlLibProgress(e:ProgressEvent):void
		{
			
			var langval:Object=GameIni.langval;
			//var descStr:String = null == langval? "Load DB File":langval["load_db_zip"];
			var descStr:String=null == langval ? "加载DB文件" : langval["load_db_zip"];

			var cent:int=int(e.bytesLoaded / e.bytesTotal * 100);

			descStr=descStr + " " + cent.toString() + "%";

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.BAR_PERCENT, cent));

					}

		private function xmlLibError(e:Event=null):void
		{
			//WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, "db.zip decompressing files failed！"));

			var langval:Object=GameIni.langval;

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO,
				//null == langval ? "db.zip decompressing files failed!":langval["load_db_decompress_failed"]
				null == langval ? "lib.swf文件不存在" : langval["load_db_decompress_failed"]

				));
			libLoader.load(new URLRequest(XmlConfig.swfXmlLibFullName), new LoaderContext(false, ApplicationDomain.currentDomain));
		}

		private function xmlLibComplete(e:Event=null):void
		{
			trace("xmlLibComplete---------lib.swf", getTimer());
			libLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, xmlLibComplete);
			libLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, xmlLibError);
			libLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, xmlLibProgress);
			libLoader=null;
			Loadxml.localres_complete=true;

			this.dispatchEvent(new DispatchEvent(Main.LOCAL_RES_LOADED));
			
			Game_main.instance.libLoadedCall();
			//---whr-------
			ShowLoginUI();
		}


		public function loadInfo1():void
		{
			var game_indexLD:Loadres=Loadres.getInstance().getItem;

			game_indexLD.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadInfo1Complete);

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.LOAD_RES, game_indexLD));

			game_indexLD.loading_remain1();
		}

		private function loadInfo1Complete(e:DispatchEvent):void
		{
			LOAD_COMPLETE=true;

			var game_indexLD:Loadres=e.getInfo;

			if (null != game_indexLD)
			{
				game_indexLD.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, loadInfo1Complete);
			}
		}
		// ================================================================测试用
	}
}

package ui.base.login
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.SelfConf;
	import common.config.xmlres.XmlRes;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.load.Loadres;
	import engine.support.IPacket;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import main.Main;
	
	import netc.DataKey;
	import netc.packets2.StructDCRoleList2;
	
	import nets.packets.PacketCDRoleDelete;
	import nets.packets.PacketCDRoleList;
	import nets.packets.PacketCGRoleLogin;
	import nets.packets.PacketDCRoleDelete;
	import nets.packets.PacketDCRoleList;
	import nets.packets.PacketGCRoleLogin;
	import nets.packets.StructDCRoleList;
	
	import scene.king.SkinByWin;
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.frame.UIMovieClip;
	import ui.layout.GameLayout;
	import ui.view.view6.GameAlertNotTiShi;
	import ui.view.view8.CheatChecker;
	
	import world.FileManager;
	import world.WorldDispatcher;
	import world.WorldEvent;
	import world.model.file.BeingFilePath;

	/**
	 *  玩家登陆
	 *	2011-12-13 整理
	 */
	public class Login extends UIMovieClip
	{
		private var _loadBar:MovieClip=null;
		private var _loadPic:Loader=null;
		private var checkIntervalId:uint;

		public function get LoadPic():Loader
		{
			if (null == _loadPic)
			{
				_loadPic=new Loader();
				_loadPic.contentLoaderInfo.addEventListener(Event.COMPLETE, picComplete);
				_loadPic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, picIOError);
			}
			return _loadPic;
		}

		public function get LoadBar():MovieClip
		{
			if (null == _loadBar)
			{
				_loadBar=gamelib.getswflink("game_login", "LoginLoading") as MovieClip;
			}
			return _loadBar;
		}
		//
		private static var _instance:Login=null;

		public static function get instance():Login
		{
			if (null == _instance)
			{
				_instance=new Login();
			}
			return _instance;
		}

		public function Login()
		{
		}

		public function HideLoadBarUI(e:Event=null):void
		{
			this.removeEventListener(Event.ENTER_FRAME, ShowLoadBarUI);
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
		}

		public function ShowLoadBarUI(e:Event=null):void
		{
			if (null == this.stage)
			{
				return;
			}
			var w:int=Main.instance().stage.stageWidth;
			var h:int=Main.instance().stage.stageHeight;
			var needAdd:Boolean=false;
			if (null != this.LoadPic)
			{
				if (null == this.LoadPic.parent && null != this.LoadPic.content)
				{
					needAdd=true;
				}
			}
			if (null != this.LoadBar)
			{
				if (null == LoadBar.parent)
				{
					needAdd=true;
				}
			}
			//-------------------------------------   begin    -------------------------------------
			//x,y
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
					this.LoadBar.x=this.LoadBar.x - GameLayout.LOGIN_FLA_DOC.LoadBarWidth_ / 2;
					this.LoadBar.y=h - GameLayout.LOGIN_FLA_DOC.LoadBarHeight_;
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
			//add
			if (needAdd)
			{
				if (null != LoadPic && null != LoadPic.content)
				{
					this.addChild(LoadPic);
				}
				this.addChild(LoadBar);
			}
		}

		public function init():void
		{
			//var descStr:String = "正在连接服务器，请稍候。。。";
			var langval:Object=GameIni.langval;
			//var descStr:String = null == langval? "Connect game server ,Please wait":langval["connect_server_please_wait"];
			var descStr:String=null == langval ? "正在连接服务器，请稍候。。。" : langval["connect_server_please_wait"];
			LoadBar["Downtxt"].text="";
			LoadBar["Loadtxt"].text=descStr;
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));
			//			var pic_num:int=(int(Math.random() * 2) + 1);
//
//			if (pic_num >= 3)
//			{
//				pic_num=2;
//			}
//
//			var picUrl:String=GameIni.GAMESERVERS + "Icon/Load_" + pic_num.toString() + ".jpg";
			var picUrl:String=GameIni.GAMESERVERS + "Icon/Load_1.jpg";
			LoadPic.load(new URLRequest(picUrl), new LoaderContext(true));
			//mcLogin["uil"].source = GameIni.GAMESERVERS +"Icon/Load_" + pic_num.toString() + ".jpg";
			//在程序压力大的情况下,半秒可能不准，触发时间晚,加上100毫秒监听	
//			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND, readlyLogin2);
//			GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND100, readlyLogin2);
			this.addEventListener(Event.REMOVED_FROM_STAGE, REMOVED_FROM_STAGE);
			DataKey.instance.register(PacketGCRoleLogin.id, GCRoleLogin);
			//连接socket服务器
			DataKey.instance.connect();
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "0 - 连接游戏服务器"));
//this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}

//		private function onRemoved(e:Event):void{
//		}
		public function picComplete(e:Event):void
		{
		}

		public function picIOError(e:Event):void
		{
		}

		public function readlyLogin2(e:WorldEvent=null):void
		{
			if (DataKey.instance.connected())
			{
				//var descStr:String = "正在验证帐号，请稍候。。。";
				var langval:Object=GameIni.langval;
				//var descStr:String = null == langval? "Check account,Please wait":langval["vali_account_please_wait"];
				var descStr:String=null == langval ? "正在验证帐号，请稍候。。。" : langval["vali_account_please_wait"];
				LoadBar["Loadtxt"].text=descStr;
				WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));
				//
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_HALF_OF_SECOND, readlyLogin2);
				GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND100, readlyLogin2);
				var userName:String="";
				var userPass:String="";
//				PubData.passwowd=CtrlFactory.getUICtrl().md5(userPass);
				var urlval:Object=GameIni.urlval;
				if (urlval == null)
				{
					userName=SelfConf.uname;
					PubData.account=userName;
					var p:PacketCGRoleLogin=new PacketCGRoleLogin();
					//p.custom_param="pf=qzone";
					//	p.custom_param="pf=3366";
					p.username=PubData.account;
					//988943 , 988963
					p.qqyellowvip="";
					p.custom_param="";
					p.password="";
					p.isfcm=1;
					p.login_state="0";
					p.login_time="1414166869";
					p.p_id=SelfConf.p_id;
					p.server=SelfConf.server;
					p.sign="6d34daadcee27b26b33c00031f84f450";
					p.userip="";
					//p.login_type = 1;  //表示从微端登录
					p.login_type=0;
					DataKey.instance.send(p);
				}
				else
				{
					GameIni.raffleSelf=urlval.payaction;
					PubData.goldTick=urlval.gold;
					GameIni.url_pay=urlval.rmb.replace(/\|\|/g, "&");
					GameIni.url_task_status=urlval.task_status;
					userName=urlval.login_account;
					PubData.account=userName;
					PubData.isYellowServer=urlval.pay_type == "0" ? false : true;
					var p2:PacketCGRoleLogin=new PacketCGRoleLogin();
					p2.username=PubData.account;
					p2.password="";
					p2.isfcm=urlval.isfcm;
					p2.login_state=urlval.login_state;
					p2.login_time=urlval.login_time;
					p2.p_id=urlval.p_id;
					p2.server=urlval.serve;
					p2.sign=urlval.sign;
					p2.userip="";
					p2.login_type=urlval.login_type;
					p2.parent_id=urlval.parent_openid == null ? "" : urlval.parent_openid;
					p2.custom_param=urlval.data == null ? "" : urlval.data;
					if (urlval.yellow_vip == null)
						urlval.yellow_vip="";
					p2.qqyellowvip=urlval.yellow_vip;
					DataKey.instance.send(p2);
					WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "1 - 角色登陆"));
				}
			}
		}

		/**
		 * 加载角色列表
		 *
		 */
		private function checkNeedLoadNewRoleSwf():void
		{
			DataKey.instance.register(PacketDCRoleList.id, CRoleList);
			var svrList:PacketCDRoleList=new PacketCDRoleList();
			svrList.accountID=PubData.accountID;
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "3 - 请求角色列表"));
			DataKey.instance.send(svrList);
//			GameMusic.playMusic(WaveURL.login, 3);
		}

		private function _onSelectRole(e:MouseEvent=null):void
		{
			var _name:String=e.target.name;
			switch (_name)
			{
				case "btnCreateRole":
					var arr:Vector.<StructDCRoleList2>=m_PacketDCRoleList.arrItemroleList
					if (null != arr && arr.length >= SelectRole.ROLE_MAX_NUM)
					{
						alert.ShowMsg(Lang.getLabel("40098_SelectRole_btnCreateRole"), 2);
					}
					else
					{
						loadRes_NewRoleCreate();
					}
					break;
				case "btnEnter":
					Main.instance().loadInfo1();
					//有时候 game_index 加载未完成  造成黑屏进不去游戏
					var p_ui_index:Sprite=GamelibS.getswflink("game_index", "ui_index") as Sprite;
					var createNewRoleHandler:Function=function(e:Event):void
					{
						if (p_ui_index == null)
						{
							p_ui_index=GamelibS.getswflink("game_index", "ui_index") as Sprite;
							return;
						}
						else
						{
							instance.removeEventListener(Event.ENTER_FRAME, createNewRoleHandler);
							initSelectRoleData(SelectRole.getInstance().getCurrSelected());
							SelectRole.getInstance().close();
						}
					}
					if (this.hasEventListener(Event.ENTER_FRAME) == false)
					{
						this.addEventListener(Event.ENTER_FRAME, createNewRoleHandler);
					}
					break;
				case "btnDeleteRole":
					alert.ShowMsg(Lang.getLabel("40098_SelectRole_btnDeleteRole"), 4, null, function():void
					{
						_delRole(SelectRole.getInstance().getCurrSelected());
					});
					break;
				default:
					break;
			}
		}

		private function _loadRes_RoleSelected(rolelist:Vector.<StructDCRoleList2>):void
		{
			SelectRole.getInstance().setRoleList(rolelist);
			SelectRole.getInstance().addEventListener(MouseEvent.MOUSE_UP, _onSelectRole);
			var ld:Loadres=Loadres.getInstance().getItem;
			ld.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, _on_loadRes_RoleSelected);
			ld.loading_selectRole();
		}

		//选择角色资源加载
		private function _on_loadRes_RoleSelected(e:DispatchEvent):void
		{
			trace("选择角色资源加载 成功 ... ...");
			PubData.mainUI.ShowSelectRoleUI();
			var ld:Loadres=e.target as Loadres;
			ld.removeEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, _on_loadRes_RoleSelected);
			//控制住必须加载完info0后再加载info1 停留10秒自动加载主场景资源
			setTimeout(Main.instance().loadInfo1,10000);
//			Main.instance().loadInfo1();
		}

//		private function tHandler(e:TimerEvent):void
		private function loadRes_NewRoleCreate():void
		{
//			if (null != GameIni.GAMELOADXML)
//			{
//				t.stop();
//				_t.removeEventListener(TimerEvent.TIMER, tHandler);
			var ld:Loadres=Loadres.getInstance().getItem;
			ld.addEventListener(DispatchEvent.EVENT_LOAD_COMPLETE, startNewPlayer);
			ld.loading_remain0();
//			}
		}

		private function _delRole(idx:int):void
		{
			var _arr:Vector.<StructDCRoleList2>=m_PacketDCRoleList.arrItemroleList;
			if (_arr.length == 0)
				return;
			var _sdc:StructDCRoleList=_arr[idx] as StructDCRoleList;
			if (null == _sdc)
			{
				return;
			}
			DataKey.instance.register(PacketDCRoleDelete.id, _on_DCRoleDelete);
			var vo:PacketCDRoleDelete=new PacketCDRoleDelete();
			vo.accountID=PubData.accountID;
			vo.roleid=_sdc.userid;
			DataKey.instance.send(vo);
		}

		private function _on_DCRoleDelete(p:IPacket):void
		{
			//SelectRole.getInstance().init()
			var value:PacketDCRoleDelete=p as PacketDCRoleDelete;
			if (value.tag == 0)
			{
				DataKey.instance.register(PacketDCRoleList.id, CRoleList);
				var svrList:PacketCDRoleList=new PacketCDRoleList();
				svrList.accountID=PubData.accountID;
				//WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "3 - 请求角色列表"));
				DataKey.instance.send(svrList);
			}
		}

		//初始化选择的角色信息
		public function initSelectRoleData(idx:int):void
		{
			var _arr:Vector.<StructDCRoleList2>=m_PacketDCRoleList.arrItemroleList;
			if (_arr.length < idx - 1)
			{
				return;
			}
			var _sdc:StructDCRoleList=_arr[idx] as StructDCRoleList;
			//出现异常了
			if (null == _sdc)
			{
				return;
			}
			//--------------------------------------------
			PubData.roleID=_sdc.userid;
			PubData.ico=_sdc.king_icon;
			//PubData.card = sdc.player_mini;
			PubData.level=_sdc.king_level;
			PubData.jobNO=_sdc.king_metier;
			PubData.uname=_sdc.king_name;
			PubData.job=XmlRes.GetJobNameById(_sdc.king_metier);
			PubData.s0=_sdc.s0;
			PubData.s1=_sdc.s1;
			PubData.s2=_sdc.s2;
			PubData.s3=_sdc.s3;
			PubData.metier=_sdc.king_metier;
			PubData.sex=_sdc.king_sex;
			//PubData.data=sdc.data;
			if (_sdc.create_date > 20110101)
			{
				PubData.createDate=_sdc.create_date;
			}
			//初始化高清极速配置信息
			GameIni.setQualityData(_sdc.data.para1);
			GameIni.MAP_ID=_sdc.mapid;
			//初始话 Alert 窗口是否需要再提示
			GameAlertNotTiShi.instance.setConfig(_sdc.data.para2);
			NewRole_new.sysSet=_sdc.sys_config;
			//--------------------------------------------
			//setTimeout(startNewPlayer2,500);
			startNewPlayer2();
		}
		private var m_PacketDCRoleList:PacketDCRoleList=null;

		private function CRoleList(p:IPacket):void
		{
			DataKey.instance.removeByFunc(CRoleList);
			//
			m_PacketDCRoleList=p as PacketDCRoleList;
			var arr:Vector.<StructDCRoleList2>=m_PacketDCRoleList.arrItemroleList; //StructDCRoleList
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "4 - 角色列表返回,数量：" + arr.length.toString()));
			//已经有角色了
			if (arr.length > 0)
			{
				_loadRes_RoleSelected(arr);
			}
			else
			{
SelectRole.getInstance().m_rolelist=new Vector.<StructDCRoleList2>();
				loadRes_NewRoleCreate();
			}
		}
		public static var role_skin:SkinByWin=null;
		public static var role_skin_timeOut:int;

		public static function chkRoleMovie(e:WorldEvent):void
		{
			if (Main.LOAD_COMPLETE)
			{
				if (Main.ROLE_MOVIE_LOADED)
				{
					NewRole_new.instance.beginGame(true);
					GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND200, chkRoleMovie);
				}
				else if (null == role_skin)
				{
					role_skin=new SkinByWin();
					//只加载主皮肤，否则等待时间太长
					//会引起其它问题，还是全加载
					var path:BeingFilePath=FileManager.instance.getMainByHumanId(PubData.s0, PubData.s1, PubData.s2, PubData.s3, PubData.sex);
					path.rightHand=FileManager.instance.getRightHand(PubData.metier);
					role_skin.addEventListener(Event.COMPLETE, role_skin_complete);
					role_skin.addEventListener(WorldEvent.PROGRESS_HAND, role_skin_progress);
					var langval:Object=GameIni.langval;
					var descStr:String=null == langval ? "加载角色形象" : langval["load_role_movie"];
					WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));
					role_skin_timeOut=setTimeout(role_skin_complete, 9000);
					role_skin.setSkin(path);
					role_skin.setAction('F1');
				}
			}
		}

		public static function role_skin_progress(e:WorldEvent):void
		{
						var langval:Object=GameIni.langval;
			var descStr:String=null == langval ? "加载角色形象" : langval["load_role_movie"];
			var Layer:String=null == langval ? "皮肤" : langval["role_skin"];
			//descStr = descStr + "-" + "Layer" + e.data["layer"]  +" " + e.data["data"][1] + "%";
			descStr=descStr + Layer + e.data["layer"] + " " + e.data["data"][1] + "%";
			var num:int=e.data["data"][1];
			if (0 == num)
			{
				num=1;
			}
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.BAR_PERCENT, num));
		}

		public static function role_skin_complete(e:Event=null):void
		{
			clearTimeout(role_skin_timeOut);
			Main.ROLE_MOVIE_LOADED=true;
			role_skin.removeEventListener(Event.COMPLETE, role_skin_complete);
			role_skin.removeEventListener(WorldEvent.PROGRESS_HAND, role_skin_progress);
			role_skin.unload();
		}

		private function startNewPlayer2():void
		{
			//有角色直接进
//			PubData.mainUI.ShowNewplayerUI();
//			NewRole_new.instance.beginGame(true);
			//要求加载完主角皮肤再进
			GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND200, chkRoleMovie);
		}

		private function startNewPlayer(e:DispatchEvent):void
		{
			PubData.mainUI.ShowNewplayerUI();
			//控制住必须加载完info0后再加载info1
			Main.instance().loadInfo1();
		}

		private function GCRoleLogin(p:IPacket):void
		{
			var value:PacketGCRoleLogin=p as PacketGCRoleLogin;
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO3, "2-验证账号"));
			if (value.tag == 0)
			{
				PubData.accountID=int(value.accountid);
				//var descStr:String = "Load Role List";//"帐号验证通过!查询角色中...";
				var langval:Object=GameIni.langval;
				//var descStr:String = null == langval? "Load Role List":langval["load_role_list"];
				var descStr:String=null == langval ? "帐号验证通过!查询角色中..." : langval["load_role_list"];
				LoadBar["Loadtxt"].text=descStr;
				WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, descStr));
				checkNeedLoadNewRoleSwf();
			}
			else
			{
				// 登录失败，主动断开
				PubData.account=null;
//				PubData.passwowd=null;
				DataKey.instance.socket.disConnect();
				alert.ShowMsg(Lang.getServerMsg(value.tag).msg, 2);
				WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.LOGINERROR));
			}
		}

		private function REMOVED_FROM_STAGE(e:Event):void
		{
			//timer=null;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_HALF_OF_SECOND, readlyLogin2);
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND100, readlyLogin2);
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, REMOVED_FROM_STAGE);
			HideLoadBarUI();
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

		/**
		 * 加速检测
		 */
		public function checkSpeed(isOpen:Boolean=true):void
		{
			if (isOpen)
			{
				CheatChecker.init();
				clearInterval(checkIntervalId);
				checkIntervalId=setInterval(CheatChecker.check, CheatChecker.CHECK_DELAY);
			}
			else
			{
				clearInterval(checkIntervalId);
			}
		}

		public function disConnect():void
		{
			PubData.account=null;
//			PubData.passwowd=null;
			DataKey.instance.socket.disConnect();
			DataKey.instance.socket.DispatEventSocketMsg("\n与服务器连接断开连接");
			clearInterval(checkIntervalId);
		}
	}
}

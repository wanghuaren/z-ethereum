package com.bellaxu.mgr
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.AlertDef;
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.def.ResPriorityDef;
	import com.bellaxu.def.StateDef;
	import com.bellaxu.display.Alert;
	import com.bellaxu.display.FubenTips;
	import com.bellaxu.display.MapLoading;
	import com.bellaxu.lang.GameLang;
	import com.bellaxu.lang.LoadLang;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.StageUtil;
	import com.bellaxu.view.FullScreenView;
	
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.support.IPacket;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import main.game_main;
	
	import netc.DataKey;
	import netc.packets2.StructDCRoleList2;
	import netc.process.PacketSCPlayerDataMoreProcess;
	import netc.process.PacketSCPlayerDataProcess;
	
	import nets.packets.PacketCDRoleDelete;
	import nets.packets.PacketCDRoleList;
	import nets.packets.PacketCGRoleLogin;
	import nets.packets.PacketDCRoleDelete;
	import nets.packets.PacketDCRoleList;
	import nets.packets.PacketGCRoleLogin;
	import nets.packets.PacketSCGetFirstPaymentInfo;
	import nets.packets.PacketSCPlayerData;
	import nets.packets.PacketSCPlayerDataMore;
	import nets.packets.StructDCRoleList;
	
	import ui.frame.UIActMap;
	import ui.base.mainStage.UI_index;
	import ui.base.beibao.BeiBaoMenu;
	import ui.view.view2.other.ControlButton;
	import ui.base.vip.ShouChong;
	import ui.view.view4.yunying.HuoDongZhengHe;
	import ui.view.view8.CheatChecker;
	import ui.base.login.NewRole_new;
	import ui.base.login.SelectRole;
	
	import world.WorldEvent;

	/**
	 * 主控制
	 * @author BellaXu
	 */
	public class GameMgr
	{
		public static var loadUi:FullScreenView = null; //加载条
		
		public static var main:game_main = null; //主文件
		
		public static function connect():void
		{
			updateDesc1(LoadLang.get("connect_server_please_wait"));
			
			DataKey.instance.register(PacketGCRoleLogin.id, GCRoleLogin);
			DataKey.instance.connect();
		}
		
		public static function login():void
		{
			if (DataKey.instance.connected())
			{
				updateDesc1(LoadLang.get("vali_account_please_wait"));
				
				var userName:String = "";
				var userPass:String = "";
				
				var urlval:Object = GameData.urlval;
				if(GameData.isDebug)
				{
					userName=GameData.username;
					userPass=GameData.password;
					
					var p:PacketCGRoleLogin = new PacketCGRoleLogin();
					//p.custom_param="pf=qzone";
					//	p.custom_param="pf=3366";
					p.username=userName;
					//988943 , 988963
					p.qqyellowvip="988943";
					p.custom_param="pf=qzone";
					p.password="";
					p.isfcm=1;
					p.login_state="1234567890123456";
					p.login_time="2013-05-20 09:54:03";
					p.p_id='10001';
					p.server='1';
					p.sign="661ac8b404507724563394ab4c1d0f3b";
					p.userip="";
					//p.login_type = 1;  //表示从微端登录
					p.login_type=0;
					p.sign=CtrlFactory.getUICtrl().md5(p.p_id + p.username + p.login_time + p.login_state + p.server + p.qqyellowvip + '111111');
					DataKey.instance.send(p);
				}
				else
				{
					GameData.url_pay=urlval.rmb.replace(/\|\|/g, "&");
					GameData.url_task_status=urlval.task_status;
					userName=urlval.login_account;
					var p2:PacketCGRoleLogin=new PacketCGRoleLogin();
					p2.username=userName;
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
				}
			}
		}
		
		private static var checkIntervalId:uint;
		
		public static  function logout():void
		{
			DataKey.instance.socket.disConnect();
			DataKey.instance.socket.DispatEventSocketMsg("\n与服务器连接断开连接");
			clearInterval(checkIntervalId);
		}
		
		public static function checkSpeed(isOpen:Boolean=true):void
		{
			if (isOpen)
			{
				CheatChecker.init();
				clearInterval(checkIntervalId);
				checkIntervalId = setInterval(CheatChecker.check, CheatChecker.CHECK_DELAY);
			}
			else
			{
				clearInterval(checkIntervalId);
			}
		}
		
		private static function GCRoleLogin(p:IPacket):void
		{
			var value:PacketGCRoleLogin = p as PacketGCRoleLogin;
			if (value.tag == 0)
			{
				updateDesc1(LoadLang.get("load_role_list"));
				
				GameData.accountId = int(value.accountid);
				
				DataKey.instance.register(PacketDCRoleList.id, CRoleList);
				var svrList:PacketCDRoleList = new PacketCDRoleList();
				svrList.accountID = GameData.accountId;
				DataKey.instance.send(svrList);
//				GameMusic.playMusic(WaveURL.login,3);
			}
			else
			{
				updateDesc1("验证账号失败，原因【" + value.tag + "】，请重新登录！");
				// 登录失败，主动断开
				DataKey.instance.socket.disConnect();
				Alert.show(AlertDef.CONFIRM, 0, Lang.getServerMsg(value.tag).msg, 0, null, null, null, StageUtil.stage);
			}
		}
		
		public static function loadSelectRole2():void
		{
			if(m_PacketDCRoleList && m_PacketDCRoleList.arrItemroleList && m_PacketDCRoleList.arrItemroleList.length > 0)
				loadSelectRole(m_PacketDCRoleList.arrItemroleList);
		}
		
		private static var m_PacketDCRoleList:PacketDCRoleList = null;
		
		private static function CRoleList(p:IPacket):void
		{
			DataKey.instance.removeByFunc(CRoleList);
			
			m_PacketDCRoleList = p as PacketDCRoleList;
			var arr:Vector.<StructDCRoleList2> = m_PacketDCRoleList.arrItemroleList;
			
			//已经有角色了
			arr.length > 0 ? loadSelectRole(arr) : loadCreateRole();
		}
		
		private static function loadSelectRole(rolelist:Vector.<StructDCRoleList2>):void
		{
			updateDesc1("正在加载选择角色界面，请稍后");
			SelectRole.getInstance().setRoleList(rolelist);
			SelectRole.getInstance().addEventListener(MouseEvent.MOUSE_UP, _onSelectRole);
			ResTool.load(ResPathDef.GAME_SELECT_ROLE, onLoadedSelectRole, loadSelectRoleProgress, null, ApplicationDomain.currentDomain, ResPriorityDef.HIGH);
		}
		
		private static function loadSelectRoleProgress(bytesLoaded:uint, bytesTotal:uint):void
		{
			updateDesc1("正在加载选择角色界面，当前进度：" + int(100 * bytesLoaded / bytesTotal) + "%");
		}
		
		private static function onLoadedSelectRole(url:String):void
		{
			SelectRole.getInstance().init();
			SelectRole.getInstance().show();
			NewRole_new.instance.hide();
			ResTool.continuePreLoad();
		}
		
		private static function loadCreateRole():void
		{
			updateDesc1("正在加载创建角色界面，请稍后");
			ResTool.load(ResPathDef.GAME_NEW_ROLE, onLoadedNewRole, loadCreateRoleProgress, null, ApplicationDomain.currentDomain, ResPriorityDef.HIGH);
		}
		
		private static function loadCreateRoleProgress(bytesLoaded:uint, bytesTotal:uint):void
		{
			updateDesc1("正在加载创建角色界面，当前进度：" + int(100 * bytesLoaded / bytesTotal) + "%");
		}
		
		private static function onLoadedNewRole(url:String):void
		{
			NewRole_new.instance.init(m_PacketDCRoleList.arrItemroleList.length > 0);
			NewRole_new.instance.show();
			SelectRole.getInstance().hide();
			ResTool.continuePreLoad();
		}
		
		private static function _onSelectRole(e:MouseEvent=null):void
		{
			var _name:String = e.target.name;
			switch (_name)
			{
				case "btnCreateRole":
					var arr:Vector.<StructDCRoleList2>=m_PacketDCRoleList.arrItemroleList;
					if (null != arr && arr.length >= SelectRole.ROLE_MAX_NUM)
						Alert.show(AlertDef.CONFIRM, 0, Lang.getLabel("40098_SelectRole_btnCreateRole"), 0, null, null, null, StageUtil.stage);
					else
						loadCreateRole();
					break;
				case "btnEnter":
					initSelectRoleData(SelectRole.getInstance().getCurrSelected());
					SelectRole.getInstance().close();
					break;
				case "btnDeleteRole":
					Alert.show(AlertDef.CONFIRM_CANCEL, 0, Lang.getLabel("40098_SelectRole_btnDeleteRole"), 0, function():void {
						_delRole(SelectRole.getInstance().getCurrSelected());
					}, null, null, StageUtil.stage);
					break;
				default:
					break;
			}
		}
		
		private static function _delRole(idx:int):void
		{
			var _arr:Vector.<StructDCRoleList2>=m_PacketDCRoleList.arrItemroleList;
			if (_arr.length == 0)
				return;
			var _sdc:StructDCRoleList=_arr[idx] as StructDCRoleList;
			
			if (null == _sdc)
				return;
			
			DataKey.instance.register(PacketDCRoleDelete.id, _on_DCRoleDelete);
			
			var vo:PacketCDRoleDelete = new PacketCDRoleDelete();
			vo.accountID=GameData.accountId;
			vo.roleid=_sdc.userid;
			DataKey.instance.send(vo);
		}
		
		private static function _on_DCRoleDelete(p:IPacket):void
		{
			var value:PacketDCRoleDelete = p as PacketDCRoleDelete;
			if (value.tag == 0)
			{
				DataKey.instance.register(PacketDCRoleList.id, CRoleList);
				var svrList:PacketCDRoleList=new PacketCDRoleList();
				svrList.accountID=GameData.accountId;
				DataKey.instance.send(svrList);
			}
		}
		
		//初始化选择的角色信息
		private static function initSelectRoleData(idx:int):void
		{
			var _arr:Vector.<StructDCRoleList2> = m_PacketDCRoleList.arrItemroleList;
			if (_arr.length < idx - 1)
				return;
			var _sdc:StructDCRoleList =_arr[idx] as StructDCRoleList;
			
			//出现异常了
			if (null == _sdc)
				return;
			
			GameData.roleId=_sdc.userid;
			//PubData.card = sdc.player_mini;
			
			//PubData.data=sdc.data;
			
			if (_sdc.create_date > 20110101)
				GameData.createDate = _sdc.create_date;
			
			//初始化高清极速配置信息
//			GameData.setQualityData(_sdc.data.para1);
			
			//初始话 Alert 窗口是否需要再提示
			Alert.serverConfig = _sdc.data.para2;
			NewRole_new.sysSet=_sdc.sys_config;
			NewRole_new.instance.beginGame();
		}
		
		public static function initGame():void
		{
			UI_index.instance.open(true, false);
			UI_index.instance.init2();
			
			DataKey.instance.removeByPID(PacketSCPlayerDataMore.id);
			DataKey.instance.removeByPID(PacketSCPlayerData.id);
			
			NewRole_new.instance.hide();
			SelectRole.getInstance().hide();
			
			MapLoading.getInstance().loadUi = ResTool.getMc(ResPathDef.GAME_INDEX, "loading_scene");
			updateDesc1("正在进入场景，请稍后...");
			
			TimerMgr.getInstance().add(33, updateEnterPercent);
			TimerMgr.getInstance().add(3000, preload, 1);
			
			GameData.state = StateDef.IN_SCENE;
		}
		
		private static var enterPer:uint = 90;
		
		private static function updateEnterPercent():void
		{
			enterPer += 1;
			if(enterPer > 100)
				enterPer = 100;
			updatePercent(enterPer);
			if(enterPer >= 100)
			{
				TimerMgr.getInstance().remove(updateEnterPercent);
				loadUi.hide();
				loadUi = null;
			}
		}
		
		public static function preload():void
		{
			var ary:Array = [
				ResPathDef.DA_TU_BIAO,
				ResPathDef.TONG_YONG,
				ResPathDef.GAME_LOGIN_1,
				ResPathDef.GAME_CONTENT,
				ResPathDef.LIB_FACE,
				ResPathDef.GAME_INDEX_3,
				ResPathDef.GAME_INDEX_1,
				ResPathDef.GAME_LOGIN,
				ResPathDef.TE_XIAO_CONTENT,
				ResPathDef.TE_XIAO_INDEX_1,
				ResPathDef.GAME_INDEX_2
			];
			for each(var url:String in ary)
			{
				ResTool.load(url, onLoadedPreLoadItem, null, null, ApplicationDomain.currentDomain, ResPriorityDef.NORMAL);
			}
		}
		
		private static function onLoadedPreLoadItem(url:String):void
		{
			switch(url)
			{
				case ResPathDef.DA_TU_BIAO:
					UI_index.instance.initMcButtonArr();
					UIActMap.zaiXianLiBao_Instance.getOnlineTime();
					while(UI_index.arrDelayAction.length > 0)
					{
						var arr:Array = UI_index.arrDelayAction.pop();
						ControlButton.getInstance().checkStartTime(arr[0], arr[1]);
					}
					DataKey.instance.register(PacketSCGetSharePrizeList.id, SCGetSharePrizeList);
					if (Data.myKing.level >= CBParam.ArrYaoQing_On_Lvl)
						InviteFriendWindow.getInstance().CSGetSharePrizeList();
					break;
				case ResPathDef.GAME_LOGIN:
					break;
				case ResPathDef.GAME_LOGIN_1:
					BeiBaoMenu.getInstance().initTip();
					break;
				case ResPathDef.GAME_INDEX_2:
//					HuoDongZhengHe.getInstance().open(true);
					break;
				case ResPathDef.GAME_INDEX_3:
					UI_index.instance.initIndex3();
					break;
			}
		}
		
		private static function SCGetSharePrizeList(p:PacketSCGetSharePrizeList):void
		{
			if(GameData.isLianYun)
				return;
			ControlButton.getInstance().setVisible(CornerButtonDef.YAO_QING, p.state < 2, p.state < 2);
		}
		
		private static function updatePercent(per:uint):void
		{
			loadUi["updatePercent2"](per);
		}
		
		private static function updateDesc1(str:String):void
		{
			loadUi["updateDesc1"](str);
		}
		
		private static function updateDesc2(str:String):void
		{
			loadUi["updateDesc2"](str);
		}
	}
}
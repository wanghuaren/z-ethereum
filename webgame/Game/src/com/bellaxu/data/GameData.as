package com.bellaxu.data
{
	import com.bellaxu.debug.Debug;
	import com.xh.config.Global;
	
	import common.config.GameIni;
	import common.utils.AsToJs;
	
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSClientDataSet;

	/**
	 * 游戏数据都在这拿
	 * @author BellaXu
	 */
	public class GameData
	{
		//==================================全局常量=====================================//
		public static const FPS_HIGH:int = 60;//高帧频 其实实际是60
		public static const FPS_LOW:int = 30;//低帧频
		
		public static const KEYDOWNDELAY:int = 100;//按钮延时
		public static const ALERTDELAY:int = 500;//弹框延时
		public static const SUFFIX:String = ".amd";// 加载文件后缀名
		
		public static const PF_QZONE:String = "qzone";//QQ 空间
		public static const PF_PENGYOU:String = "pengyou";//朋友网
		public static const PF_QPLUS:String = "qplus";//Q+
		public static const PF_TAPP:String = "tapp";//微博
		public static const PF_QQGAME:String = "qqgame";//QQ Game
		public static const PF_3366:String = "3366";//3366
		//=================================全局控制参数====================================//
		public static var openPrint:Boolean = false;//打开ProgramTest的print
		public static var openMonitor:Boolean = false;//打开监视器
		public static var showSocktetAll:Boolean = false;//显示ProgramTest的全部Socket
		public static var showSocket:Boolean = false;//显示ProgramTest的Socket
		public static var autoRefresh:int = 1;//是否启动断线自动重连
		public static var lastAlertTime:Number = 0;// 警告打印时间标
		public static var lastAlertMsg:String = "";// 警告内容
		public static var curFps:int = FPS_HIGH;//FPS_HIGH; 新项目用低频
//		public static var curFps:int = FPS_LOW;//FPS_HIGH; 新项目用低频
		//=================================玩家基本参数====================================//
		public static var accountId:int;
		public static var roleId:int;
		public static var createDate:int = 20120801;
		public static var mergeServerDay:int = 0;
		public static var username:String = "xhfans";
		public static var password:String = "";
		public static var serverPort:int = 8099;
		public static var serverIp:String = "194.168.0.3";
		public static var serverUrl:String = "www.xhgame.com";
		public static var wangzhi:String = "http://x1.677.com/api/clientlog.aspx";
//		public static var HTTP_0:String = "http://203.195.136.208:8083/GameRes/";
//		public static var HTTP_1:String = "http://203.195.136.208:8083/GameRes/";
//		public static var HTTP_0:String = "http://194.168.0.5/bin/client_dev/Client/GameRes/";
//		public static var HTTP_1:String = "http://194.168.0.5/bin/client_dev/Client/GameRes/";
//		public static var HTTP_0:String = "http://jzzy.xhgame.com/szww0724/GameRes/";
//		public static var HTTP_1:String = "http://jzzy.xhgame.com/szww0724/GameRes/";
		public static var HTTP_0:String = "GameRes/";
		public static var HTTP_1:String = "GameRes/";
		
		public static var urlval:Object = null;
		public static var thisPlayerVersion:String = "";
		public static var platform:String = PF_QZONE;
		public static var startday:String = "2014-4-10";
		public static var url_pay:String = "";
		public static var url_bbs:String = "";
		public static var url_vip:String = "";
		public static var url_VipService:String = "";
		public static var url_home:String = "";
		public static var url_weiduan:String = "";
		public static var url_qq:String = "";
		public static var url_tel:String = "";
		public static var url_authorized:String = "";
		public static var url_CardPage:String = "http://www.xhgame.com";
		public static var url_loginuser:String = "";
		public static var url_task_status:String = "";//任务集市状态 0 没有任务，1，有任务,2任务完成时间小于12小时
		//=================================玩家动态参数====================================//
		public static var state:uint = 0;
		//=================================动态调度方法====================================//
		public static function get isDebug():Boolean
		{
			return !GameData.urlval || !GameData.urlval.ServerAddress || !GameData.urlval.Port;
		}
		
		public static function get isLianYun():Boolean
		{
			return !isDebug && !platform && platform != PF_QZONE;
		}
		
		public static function set transferParams(value:Object):void
		{
			// 传参设定
			urlval = value;
			if(value)
			{
				if (value.hasOwnProperty("loginuser"))
					url_loginuser = value["loginuser"];
				if (value.hasOwnProperty("ServerAddress"))
					serverIp = value["ServerAddress"];
				if (value.hasOwnProperty("Port"))
					serverPort = value["Port"];
				if (value.hasOwnProperty("LogAddress"))
					wangzhi = value["LogAddress"];
				if (value.hasOwnProperty("ResAddressMax"))
					HTTP_0 = HTTP_1 = value["ResAddressMax"];
				if (value.hasOwnProperty("PlayerVersion"))
					thisPlayerVersion = "PlayerVersion:" + value["PlayerVersion"];
				if (value.hasOwnProperty("rmb"))
					url_pay = value["rmb"].replace(/\|\|/g, "&");
				if (value.hasOwnProperty("vip"))
					url_vip = value["vip"].replace(/\|\|/g, "&");
				if (value.hasOwnProperty("VipService"))
					url_VipService = value["VipService"].replace(/\|\|/g, "&");
				if (value.hasOwnProperty("authorized"))
					url_authorized = value["authorized"].replace(/\|\|/g, "&");
				if (value.hasOwnProperty("bbs"))
					url_bbs = value["bbs"].replace(/\|\|/g, "&");
				if (value.hasOwnProperty("CardPage"))
					url_CardPage = value["CardPage"].replace(/\|\|/g, "&");
				if (value.hasOwnProperty("home"))
					url_home = value["home"].replace(/\|\|/g, "&");
				if (value.hasOwnProperty("weiduan"))
					url_weiduan = value["weiduan"].replace(/\|\|/g, "&");
				if (value.hasOwnProperty("qq"))
					url_qq = value["qq"];
				if (value.hasOwnProperty("tel"))
					url_tel = value["tel"];
				if (value.hasOwnProperty("refpage"))
					autoRefresh = value["refpage"];
				if (value.hasOwnProperty("pf"))
					platform = value["pf"];
				if (value.hasOwnProperty("startday"))
					startday = value["startday"];
			}
			Global.ASSET_URL_SUFFIX = GAMESERVERS.replace("GameRes/", "");
		}
		
		public static function get GAMESERVERS():String
		{
			return GameIni._http0;
		}
	}
}
package common.config
{
	import common.utils.AsToJs;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;

	public class GameIni
	{
		public static function get currentState():String
		{
			return _currentState;
		}

		public static function set currentState(value:String):void
		{
			_currentState=value;
		}

		/**
		 * 当前选择的游戏类型
		 */
		public static function get SELECT_GAME_TYPE():String
		{
			return GAME_TYPE_TW;
		}
		/**
		 * 玄仙
		 */
		public static const GAME_TYPE_SWORD:String="Sword";
		/**
		 * 台湾玄仙
		 */
		public static const GAME_TYPE_TW:String="TW";
		/**
		 * QQ
		 */
		public static const GAME_TYPE_QQ:String="QQ";
		//
		public static var canRefreshPage:int=1;
		/**
		 * 定义图像画面品质  -- 未知品质
		 */
		public static const QUALITY_NULL:int=-1;
		/**
		 * 定义图像画面品质  -- 高品质
		 */
		public static const QUALITY_HIGH:int=0;
		/**
		 * 定义图像画面品质  -- 低品质
		 */
		public static const QUALITY_LOW:int=1;
		private static var m_quality:int=GameIni.QUALITY_HIGH;
		/**
		 * 取gameLoad.txt info结点的第一个,ver属性
		 */
		public static var LOCAL_RES_VER:String;
		public static var MAP_ID:int;
		// 地图宽高最大值 warren
		public static var MAP_SIZE_W:int=1000;
		public static var MAP_SIZE_H:int=600;
		// UI拖动区域
		public static var UI_DRAG_BOUNDS:Rectangle=new Rectangle(0, 0, MAP_SIZE_W, MAP_SIZE_H);
		public static var MAP_VER:String;
		//0 - 人物为中心移动地图 1- 人物不为中心，超过EDGE*2矩形才移动地图
		public static var MAP_MOVE_MODE:int=1;
		public static var MAP_MOVE_EDGE_X:int=35; //地图格子是35像素一格，因此把从50改成70
		public static var MAP_MOVE_EDGE_Y:int=7;
		//人物移动路径只发出发点和终点
		public static var CUT_PLAYER_PATH:Boolean=false;
		// fux_map
		private static var _currentState:String;
		// AMF编码格式
		public static const AMF:int=0;
		// 版本编号显示
		public static var ClientVersion:String="";
		public static var ServerVersion:String="";
		public static var ReadTime:int=0;
		public static var ReadCount:int=0;
		public static var PingTime:int=0;
		// 安全沙箱端口
		public static var POLICYS_IP:int=0;
		public static var POLICYS_PORT:int=0;
		// 游戏连接端口
		public static var CONNECT_PORT:int=5099;
		// 外部测试服务器
		public static var CONNECT_IP:String="";
		// 幻灯片数量
		public static var Picture:int=0;
		// XML
		public static var GAMELOADXML:XML=null;
		public static var GAMEDATAXML:XML=null;
		//收包运行时间
		public static var packageRun:int;
		//收包间隔时间
		public static var packageSleep:int;
		/**
		 * 系统额定fps
		 */
		public static var FPS:int=30;
		/**
		 * 系统当前fps
		 */
		public static var currentFps:int=30;
		/**
		 * 调试面板总开关
		 * 信息输出
		 */
		public static var MsgPrintOpen:Boolean=false;
		/**
		 * 调试面板指令统计信息
		 */
		public static var MonitorOpen:Boolean=false;
		/**
		 * 公司自己充值返利时间
		 */
		public static var raffleSelf:String="";
		// HTTP服务地址
		//public static var GAMESERVERS:String=null;
		public static var _http0:String=null;
		public static var _http1:String=null;

		// XML 文件地址
		public static function get GAMELOADTXT():String
		{
			return "data/gameLoad.txt?ver=" + getTimer();
		}

		public static function get GAMEDATATXT():String
		{
			return "data/gamedata.txt?ver=" + getTimer();
		}
		// 面板点击间隔时间
		public static var CLICKDELAY:int=250; //500;
		// 按键点击间隔时间
		public static const KEYDOWNDELAY:int=100;
		// 毫秒
		// 警告打印间隔
		public static const ALERTDELAY:int=500;
		// 毫秒
		// 警告打印时间标
		public static var ALERTMARK:Number=0;
		// 警告内容
		public static var ALERTMSG:String="";
		// 删除物品时间标
		public static var DELMARK:Number=0;
		// 加载文件后缀名
		public static const suffix:String=".swf";
		// 网址
		public static var wangzhi:String="";
		//gameloading的语言包
		public static var langval:Object=null;

		// 设置HTTP_IP
		public static function set HTTP_IP0(http:String):void
		{
			if (GameIni._http0 != http)
			{
				GameIni._http0=http;
				GameIni.GAMESERVERS0=http;
			}
		}

		public static function set HTTP_IP1(http:String):void
		{
			if (GameIni._http1 != http)
			{
				GameIni._http1=http;
				GameIni.GAMESERVERS1=http;
			}
		}
		// 外部传参
		public static var urlval:Object=null;
		public static var thisPlayerVersion:String="";
		public static var url_pay:String="";
		public static var url_bbs:String="";
		public static var url_vip:String="";
		public static var url_VipService:String="";
		public static var url_home:String="";
		public static var url_weiduan:String="";
		public static var url_qq:String="";
		public static var url_tel:String="";
		public static var url_authorized:String="";
		public static var url_CardPage:String=null;
		public static var url_loginuser:String="";
		/**
		 * 任务集市状态 0 没有任务，1，有任务,2任务完成时间小于12小时
		 * */
		public static var url_task_status:String="";
		public static var ver:String="";

//		public static function pay():void{
//			AsToJs.callJS("payment",100);
////			flash.net.navigateToURL(new URLRequest(url_pay),"_blank");
//		}
		public static function bbs():void
		{
			flash.net.navigateToURL(new URLRequest(url_bbs), "_blank");
		}

		public static function vip():void
		{
			flash.net.navigateToURL(new URLRequest(url_vip), "_blank");
		}

		public static function authorized():void
		{
			flash.net.navigateToURL(new URLRequest(url_authorized), "_blank");
		}

		/**
		 * 贵宾服务
		 */
		public static function VipService():void
		{
			flash.net.navigateToURL(new URLRequest(url_VipService), "_blank");
		}

		/**
		 * 现在微端指令
		 *
		 */
		public static function downloadWeiduan():void
		{
			flash.net.navigateToURL(new URLRequest(url_weiduan), "_blank");
		}

		/**
		 *	保存游戏快捷方式到桌面
		 */
		public static function saveHomePage():void
		{
			if (urlval != null)
				flash.net.navigateToURL(new URLRequest(urlval.Server_Url + "/DownUrl.aspx"), "_blank");
		}

		/**
		 * 返回当前服务器的开服时间字符串
		 * @return
		 */
		public static function starServerTime():String
		{
//			var _stringTime:String = "1970-1-1";
			var _stringTime:String="2014-08-1";
			if (null != urlval)
			{
				_stringTime=urlval.startday;
			}
			return _stringTime;
		}
		private static var m_gameservers0:String;

		public static function set GAMESERVERS0(server:String):void
		{
			m_gameservers0=server;
		}

		/**
		 * 获得高清版的配置URL
		 * @param server
		 *
		 */
		public static function get GAMESERVERS0():String
		{
			return m_gameservers0;
		}
		private static var m_gameservers1:String;

		public static function set GAMESERVERS1(server:String):void
		{
			m_gameservers1=server;
		}

		/**
		 * 获得极速版的配置URL
		 * @return
		 *
		 */
		public static function get GAMESERVERS1():String
		{
			return m_gameservers1;
		}

		public static function get GAMESERVERS():String
		{
			var _ret:String=m_gameservers0;
			if (QUALITY_HIGH == m_quality)
			{
				_ret=GAMESERVERS0;
				return _ret;
			}
			else if (QUALITY_LOW == m_quality)
			{
				_ret=GAMESERVERS1;
				return _ret;
			}
			return _ret;
		}

		public static function setQuality(q:int):void
		{
			m_quality=q;
//			当切换游戏品质的时候不再更改动画帧速度  --  2012-6-28 王华仁通知修改
//			if(QUALITY_HIGH == m_quality)
//			{
//				Conf.instance.DRAWOUT=2;
//			}
//			else if(QUALITY_LOW == m_quality)
//			{
//				Conf.instance.DRAWOUT=3;
//			}
		}

		public static function getQuality():int
		{
			return m_quality;
		}

		public static function setQualityData(data:Object):void
		{
			//data   表示  0 表示未设置 ， 1 表示高品质  ，  2 表示低品质
			if (0 == data)
			{
				setQuality(QUALITY_HIGH);
			}
			else if (1 == data)
			{
				setQuality(QUALITY_HIGH);
			}
			else if (2 == data)
			{
				setQuality(QUALITY_LOW);
			}
		}

		/**
		 * 通过URL检查该资源属于什么类型
		 * @param url
		 * @return    未知，  高清 ， 极速
		 *
		 */
		public static function checkQualityByURL(url:String):int
		{
			var _ret:int=QUALITY_NULL;
			if (0 == url.indexOf(_http0))
			{
				_ret=QUALITY_HIGH;
			}
			else if (0 == url.indexOf(_http1))
			{
				_ret=QUALITY_LOW;
			}
			return _ret;
		}

		/**
		 * 新手卡领取地址
		 * @return
		 *
		 */
		public static function getCardPage():String
		{
			var _ret:String="http://www.xhgame.com";
			if (null != url_CardPage)
			{
				_ret=url_CardPage;
			}
			return _ret;
		}
		//QQ 空间
		public static const PF_QZONE:String="qzone";
		//朋友网
		public static const PF_PENGYOU:String="pengyou";
		//Q+
		public static const PF_QPLUS:String="qplus";
		//微博
		public static const PF_TAPP:String="tapp";
		//QQ Game
		public static const PF_QQGAME:String="qqgame";
		//3366
		public static const PF_3366:String="3366";

		/**
		 * 返回当前游戏接入的运营平台
		 * @return
		 *
		 */
		public static function pf():String
		{
			//var _pf:String = PF_3366;			
			var _pf:String=PF_QZONE;
			if (null != urlval)
			{
				_pf=urlval.pf;
			}
			return _pf;
		}
	}
}

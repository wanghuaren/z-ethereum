/**
 *@author  wanghuaren
 *@version 1.0   2010-3-26
 */
package common.config
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import main.Main;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSClientDataSet;
	
	import ui.view.view1.chat.MainChat;

	public final class PubData
	{
		public static var version:Number=0;
		public static var minVersion:Number=11.2;
		/**
		 * 进入游戏用哪种模式
		 * 0 腾讯模式(ARPG)
		 * 1 联运模式(传奇)
		 * */
//		public static var loginStyle:int=3;
		/**
		 * 窗口管理类型 0 全部并存模式 1 树形并存模式 2 树形竞争模式
		 */
		public static var winCtlType:int=1;
		/**
		 *@category 游戏容器
		 */
		public static var mainUI:Main=null;
		/**
		 *@category 弹窗界面
		 */
		public static var LoadUI:Sprite=null;
		public static var AlertUI:Sprite=null;
		public static var AlertUI2:Sprite=null;
		//剧情动画层
		public static var StoryCartoon:Sprite=null;
		/**
		 * 登陆消息往返记录
		 */
		public static var LoginRecordStatus:String="";

		/**
		 *@category 玩家职业编号
		 */
		public static function get jobNO():int
		{
			var temp:int=_jobNO;
			while (temp > 9)
			{
				temp=temp / 10;
			}
			return temp;
		}

		/**
		 *右键是否生效
		 */
		public static function get canRightKey():Boolean
		{
			return false;
//			return version >= minVersion;
		}

		public static function get jobNO_():int
		{
			return _jobNO;
		}

		/**
		 * @private
		 */
		public static function set jobNO(value:int):void
		{
			_jobNO=value;
		}
		// 关于玩家的信息 BEGIN#################
		/**
		 *@category 玩家ID
		 */
		public static var accountID:int;
		/**
		 *@category 玩家角色ID
		 */
		public static var roleID:int;
		/**
		 *@category 玩家角色ID
		 */
		public static var isRide:Boolean;
		/**
		 *@category 玩家名子
		 */
		public static var uname:String=null;
		/**
		 *@category 玩家头像
		 */
		public static var ico:int;
		/**
		 *@category 玩家等级
		 */
		public static var level:int;
		/**
		 * 角色创建日期
		 */
		public static var createDate:int=20120801;
		/**
		 *@category 玩家职业
		 */
		public static var job:String=null;
		private static var _jobNO:int=1;
		/**
		 * 面板打开延时时间[毫秒]
		 */
		public static var openWindowTime:int=300;
		// 关于玩家的信息 END#################
		/**
		 *@category 游戏聊天
		 */
		public static var chat:MainChat=null;
		/**
		 *控制Socket收发基本信息显示
		 */
		public static var sockRSShow:Boolean=false;
		/**
		 *控制Socket收发信息全部显示
		 */
		public static var sockRSShowALL:Boolean=false;
		/**
		 * 显示窗体名称
		 */
		public static var winNameShow:Boolean=false;
		/**
		 * 合服天数
		 */
		public static var mergeServerDay:int=0;
		/**
		 * 特殊功能
		 */
		public static var supicFunc:Boolean=false;
		/**
		 * 帐号?
		 */
		public static var account:String=null;
		/**
		 * 金券
		 */
		public static var goldTick:int=0;
		/**
		 * 线路名称
		 */
		public static var line:String=null;
		/**
		 * PK模式
		 */
		public static var mod:String=null;
		/**
		 * 是否激活剑灵
		 */
		public static var isActived:Boolean=false;
		/**
		 * 登录次数
		 */
		public static var logNum:int=0;
		/**
		 *世界聊天等级
		 */
		public static var world_level:int;
		/**
		 *场景聊天等级
		 */
		public static var map_level:int;
		/**
		 *交易聊天等级
		 */
		public static var camp_level:int;
		/**
		 *私人聊天等级
		 */
		public static var private_level:int;
		/**
		 *是否可以交易
		 */
		public static var isDeal:Boolean=false;
		/**
		 *是否显示金券图标
		 */
		public static var isShowGoldTick:Boolean=false;
		/**
		 *是否显示抽奖按钮
		 */
		public static var isShowReffla:Boolean=false;
		/**
		 *是否显示弹出广告按钮
		 */
		public static var isShowAD:Boolean=false;
		/**
		 *是否启动6.30金券大放送活动
		 */
		public static var isStartGoldFree1:Boolean=false;
		/**
		 *是否启动7.1金券大放送活动
		 */
		public static var isStartGoldFree2:Boolean=false;
		/**
		 *是否打开公司自己的充值返利
		 */
		public static var isRefflaSelf:Boolean=false;
		public static var dicTradeBtn:Dictionary=new Dictionary();

		public static function setTradeVisible(btn:DisplayObject):void
		{
			if (btn == null)
				return;
			if (dicTradeBtn[btn] == null)
				dicTradeBtn[btn]=btn.parent["mc_bg"].height;
			if (isDeal)
			{
				btn.visible=true;
				btn.parent["mc_bg"].height=dicTradeBtn[btn];
			}
			else
			{
				btn.visible=false;
				btn.parent["mc_bg"].height=dicTradeBtn[btn] - 30;
			}
		}
		/**
		 *是否是黄钻服
		 */
		public static var isYellowServer:Boolean;
		public static var s0:int=0;
		public static var s1:int=0;
		public static var s2:int=0;
		public static var s3:int=0;
		private static var _metier:int=0;

		/**
		 *	职业  1道士  3战士  4法师  6刺客
		 **/
		public static function set metier(value:int):void
		{
			_metier=value;
		}

		/**
		 *	职业  1道士  3战士  4法师  6刺客
		 **/
		public static function get metier():int
		{
			return _metier;
		}
		/**
		 *@category 玩家性别
		 */
		public static var sex:int=0;
		//public static var data:StructClientPara2;
		/**
		 * 参数数据
		 * 第一个是版本号，用来弹出更新公告
		 */
		private static var _para1:int=-1;

		public static function get para1():int
		{
			return _para1;
		}

		public static function set para1(value:int):void
		{
			_para1=value;
		}
		private static var _para2:int=-1;

		public static function get para2():int
		{
			return _para2;
		}

		public static function set para2(value:int):void
		{
			_para2=value;
		}
		private static var _para3:int=-1;

		public static function get para3():int
		{
			return _para3;
		}

		public static function set para3(value:int):void
		{
			_para3=value;
		}
		private static var _para4:int=-1;

		public static function get para4():int
		{
			return _para4;
		}

		public static function set para4(value:int):void
		{
			_para4=value;
		}

		public static function save(index:int, value:int):void
		{
			if (1 != index && 2 != index && 3 != index && 4 != index)
			{
				throw new Error("index range must 1 - 4");
				return;
			}
			if (-1 == value)
			{
				throw new Error("value range must 1 - FFFF");
				return;
			}
			if (1 == index)
			{
				para1=value;
			}
			if (2 == index)
			{
				para2=value;
			}
			if (3 == index)
			{
				para3=value;
			}
			if (4 == index)
			{
				para4=value;
			}
			var cs:PacketCSClientDataSet=new PacketCSClientDataSet();
			cs.data.para1=para1;
			cs.data.para2=para2;
			cs.data.para3=para3;
			cs.data.para4=para4;
			DataKey.instance.send(cs);
		}
		/**
		 * 跨服战IP
		 */
		public static var crossIP:String;
		/**
		 *跨服战PORT
		 */
		public static var crossPORT:int;
	}
}

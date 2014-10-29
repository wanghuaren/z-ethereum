package model.pkmatch
{
	import common.managers.Lang;
	import common.utils.Queue;
	import common.utils.Stats;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructPk_Player_List2;
	import netc.packets2.StructPk_Rank_Info2;
	import netc.packets2.StructPk_Rank_List2;
	
	import nets.packets.PacketCSGetPlayerPkInfo;
	import nets.packets.PacketCSPkReadyOk;
	import nets.packets.PacketCSPlayerLeavePk;
	import nets.packets.PacketCWGetCampRank;
	import nets.packets.PacketCWGetDayPkRank;
	import nets.packets.PacketCWGetPlayerPkList;
	import nets.packets.PacketCWGetWeekPkRank;
	import nets.packets.PacketCWJoinPk;
	import nets.packets.PacketCWSetPkUpdate;
	import nets.packets.PacketSCGetPlayerPkInfo;
	import nets.packets.PacketSCPkNewsUpdate;
	import nets.packets.PacketSCPkReadyStart;
	import nets.packets.PacketSCPlayerEntryInstanceMsg;
	import nets.packets.PacketSCPlayerLeaveInstanceMsg;
	import nets.packets.PacketSCPlayerPkInfoUpdate;
	import nets.packets.PacketWCCampNumUpdate;
	import nets.packets.PacketWCGetCampRank;
	import nets.packets.PacketWCGetDayPkRank;
	import nets.packets.PacketWCGetPlayerPkList;
	import nets.packets.PacketWCGetWeekPkRank;
	import nets.packets.PacketWCJoinLeftUpdate;
	import nets.packets.PacketWCJoinPk;
	import nets.packets.PacketWCPkStateUpdate;
	import scene.event.MapDataEvent;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import ui.base.mainStage.UI_index;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view2.other.ControlButton;
	import ui.base.shejiao.zhenying.ZhenYing;
	import ui.view.view4.pkmatch.PKMatchPeiDuiWindow;
	import ui.view.view4.pkmatch.PKMatchPlayerInfo;
	import ui.view.view4.pkmatch.PKMatchWindow;
	
	import world.WorldEvent;
	
	/**
	 * PK赛 主功能模块
	 * 
	 * 技术部-叶俊  2013.11.29 16:29:26
		    PlayerCamp_Taiyi = 2,//太乙教 正
		    PlayerCamp_Tongtian = 3,//通天教 邪
	 * 
	 * 
	 * 
	 * @author steven guo
	 * 
	 */	
	public class PKMatchModel extends EventDispatcher
	{
		private static const TEST:Boolean = false;
		
		//每页个数
		private static const TOTAL_PAGE_NUM:int = 12;
		
		/**
		 * 战报滚动条最大数量 
		 */		
		public static const SCROLL_LIST_MAX_NUM_ZHANBAO:int = 10;
		
		private static var m_instance:PKMatchModel;
		
		
		//副本活动总剩余时间(秒值)
		private var m_remainingTime:int;
		
		//通天总积分
		private var m_totalNumber_TT:int;
		
		//太乙总积分
		private var m_totalNumber_TY:int;
		
		//通天当前当页人员列表
		private var m_leftInfo:PacketWCGetPlayerPkList;
		
		//太乙当前当页人员列表   
		private var m_rightInfo:PacketWCGetPlayerPkList;
		
		//通天当前总参赛人数
		private var m_TTCurrentNumber:int;
		
		//太乙当前总参赛人数
		private var m_TYCurrentNumber:int;
		
		
		//个人信息   - 实力排名
		private var m_no:int = 0;
		
		//个人信息   - 当前连胜
		private var m_c_win:int = 0;
		
		//个人信息   - 实力积分
		private var m_rank:int = 0;
		
		//个人信息   - 最高连胜
		private var m_max_win:int = 0;
		
		//个人信息  - 获得声望
		private var m_renown:int = 0;
		
		
		//  全部战报列表
		private var m_allZhanBaoList:PKZhanBaoQueue = null;
		
		//  个人战报列表
		private var m_personalZhanBaoList:PKZhanBaoQueue = null;
		
		//当进入副本是否直接挂机状态
		private var m_isDirectGuaJi:Boolean;
		
		//是否处于“参战”状态，无论处于“战斗”，还是“等待战斗”
		private var m_isEntering:Boolean;
		
		//是否正式进入PK赛副本
		private var m_isEnterInstance:Boolean = false;
		
		//进入副本并开始战斗的时候是否直接挂机
		private var m_needGuaJi:Boolean = true;
		
		//每日PK排名
		private var m_dayPkRank:PacketWCGetDayPkRank = null;
		
		//每周PK排名
		private var m_weekPKRank:PacketWCGetWeekPkRank = null;
		
		//配对成功时对手信息
		private var m_makePairData:PacketSCPkReadyStart = null;
		
		
		public function PKMatchModel()
		{
			//初始化监听服务端消息
			DataKey.instance.register(PacketWCJoinPk.id,_responeEnterWar);                           // 监听服务器请求参加战斗 返回消息
			DataKey.instance.register(PacketWCGetCampRank.id,_responseTotalNumber);                  //获得阵营积分数据返回
			
			DataKey.instance.register(PacketSCGetPlayerPkInfo.id,_responsePersonalInfo);             //请求玩家个人信息的服务器返回
			DataKey.instance.register(PacketSCPlayerPkInfoUpdate.id,_notifyPersonalInfo);            //服务器主动推送玩家个人信息
			DataKey.instance.register(PacketSCPkNewsUpdate.id,_notifyWarInfo);                       //后台主动通知战报信息更新
			DataKey.instance.register(PacketWCGetDayPkRank.id,_responseGetDayPkRank);
			DataKey.instance.register(PacketWCGetWeekPkRank.id,_responseGetWeekPkRank);
			
			DataKey.instance.register(PacketWCGetPlayerPkList.id,_responseSoldiers);                 //当前参战列表
			
			DataKey.instance.register(PacketSCPlayerEntryInstanceMsg.id,_notifyPlayerEntryInstance); //进入副本
			DataKey.instance.register(PacketSCPlayerLeaveInstanceMsg.id,_notifyPlayerLeaveInstance); //离开副本
			
			DataKey.instance.register(PacketSCPkReadyStart.id,_notifyMakePair);                      //通知玩家配对成功，准备开始
			
			DataKey.instance.register(PacketWCCampNumUpdate.id,_notifyTotalNumber);                      //阵营总积分通知消息
			
			
			
			//玩家加入离开更新
			DataKey.instance.register(PacketWCJoinLeftUpdate.id,_notifyJoinLeft);
			
			//玩家Pk状态更新
			DataKey.instance.register(PacketWCPkStateUpdate.id,_notifyPkState);
			
			SceneManager.AddEventListener(WorldEvent.MapDataComplete, _onEntryInstanceComplete);        //完全进入某个地图
			
			
			m_allZhanBaoList = new PKZhanBaoQueue(SCROLL_LIST_MAX_NUM_ZHANBAO);
			m_personalZhanBaoList = new PKZhanBaoQueue(SCROLL_LIST_MAX_NUM_ZHANBAO);
			
		}
		
		public static function getInstance():PKMatchModel
		{
			if(null == m_instance)
			{
				m_instance = new PKMatchModel();
			}
			
			return m_instance;
		}
		
		/**
		 * 副本活动总剩余时间(秒值)
		 * @return 
		 * 
		 */		
		public function getRemainingTime():int
		{
			var _ctime:int =  getTimer();
			_ctime = (_ctime - m_responseAtTime)/1000;
			
			_ctime = m_remainingTime - _ctime;
			
			if(_ctime <= 0)
			{
				_ctime = 0;
			}
			
			return _ctime;
		}
		
		/**
		 * 通天总积分 
		 * @return 
		 * 
		 */		
		public function getTotalNumber_TT():int
		{
			return m_totalNumber_TT;
		}
		
		/**
		 * 太乙总积分 
		 * @return 
		 * 
		 */		
		public function getTotalNumber_TY():int
		{
			return m_totalNumber_TY;
		}
		
		/**
		 * 获得当前参赛的通天总人数 
		 * @return 
		 * 
		 */		
		public function getNumber_TT():int
		{
			return m_TTCurrentNumber;
		}
		
		/**
		 *  获得当前参赛的太乙总人数 
		 * @return 
		 * 
		 */		
		public function getNumber_TY():int
		{
			return m_TYCurrentNumber;
		}
		
		/**
		 * 获得左边 太乙 参赛队员列表 
		 * @return 
		 * 
		 */		
		public function getLeftInfo():PacketWCGetPlayerPkList
		{
			return m_leftInfo;
		}
		
		/**
		 * 获得右边 通天  参赛队员列表 
		 * @return 
		 * 
		 */	
		public function getRightInfo():PacketWCGetPlayerPkList
		{
			return m_rightInfo;
		}
		
		/**
		 * 获得全部战报 
		 * @return 
		 * 
		 */		
		public function getAllZhanBaoList():Array
		{
			//测试数据
			//m_allZhanBaoList.add(10001,"测试名字1", 10002,"测20001",20120,50,10002,10003);
			//m_allZhanBaoList.add(10002,"测试名字2", 10002,"测20002",20120,50,10002,10003);
			
			
			return m_allZhanBaoList.getList();
		}
		
		public function getPersonalZhanBaoList():Array
		{
			return m_personalZhanBaoList.getList();
		}
		
		/**
		 * 设置是否进入参战状态  
		 * @param b     true 表示进入参战状态，  false 表示退出参战状态
		 */		
		public function setEntering(b:Boolean):void
		{
			this.m_isEntering = b;
		}
		
		public function getEntering():Boolean
		{
			return this.m_isEntering;
		}
		
		
		/**
		 * 个人信息   - 实力排名
		 * @return 
		 * 
		 */		
		public function getNo():int
		{
			return m_no;
		}
		
		/**
		 * 个人信息   - 当前连胜 
		 * @return 
		 * 
		 */		
		public function getCWin():int
		{
			return m_c_win;
		}
		
		/**
		 * 个人信息   - 实力积分 
		 * @return 
		 * 
		 */		
		public function getRank():int
		{
			return m_rank;
		}
		
		/**
		 * 个人信息   - 最高连胜 
		 * @return 
		 * 
		 */		
		public function getMaxWin():int
		{
			return m_max_win;
		}
		
		/**
		 * 个人信息  - 获得声望 
		 * @return 
		 * 
		 */		
		public function getRenown():int
		{
			return m_renown;
		}
		
		/**
		 * 请求当前参战的人员列表。这个是个异步的过程，需要向服务器发送请求。
		 * @param group        3通天  ，  2 太乙
		 * @param pageIndex   
		 * 
		 */		
		public function requestSoldiers(group:int,pageIndex:int):void
		{
			var _p:PacketCWGetPlayerPkList = new PacketCWGetPlayerPkList();
			_p.camp = group;
			_p.page = pageIndex;
			
			if(!TEST)
			{
				DataKey.instance.send(_p);
			}
			else
			{
//				var _sp:PacketWCGetPlayerPkList = new PacketWCGetPlayerPkList();
//				
//				_sp.camp = group;
//				_sp.page = pageIndex;
//				_sp.total_page = 2;
//				
//				var _list:Vector.<StructPk_Player_List2> = new Vector.<StructPk_Player_List2>();
//				var _pl:StructPk_Player_List2 = new StructPk_Player_List2();
//				_pl.state = 1;
//				_pl.userid = 10000001;
//				if(1 == pageIndex)
//				{
//					_pl.username = "斗战神1";
//				}
//				else if(2 == pageIndex)
//				{
//					_pl.username = "斗战神2";
//				}
//				else
//				{
//					_pl.username = "无名氏";
//				}
//				
//				_list.push(_pl);
//				_sp.arrIteminfo_list  = _list;
//				
//				_responseSoldiers(_sp);
			}
			
			
		}
		
		/**
		 * 返回 当前参战的人员列表
		 * @param p
		 * 
		 */		
		private function _responseSoldiers(p:IPacket):void
		{
			var _p:PacketWCGetPlayerPkList   = p as PacketWCGetPlayerPkList;
			
			if(0 != _p.tag)
			{
				return ;
			}
			
			var _e:PKMatchEvent =  null;
			
			//太乙 参赛人员列表更新
			if(2 == _p.camp)
			{
				m_leftInfo =  _p;
				_e = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
				_e.sort = PKMatchEvent.PK_EVENT_LEFT_HERO_LIST;
			}
			//通天
			else if(3 == _p.camp)
			{
				
				m_rightInfo = _p;
				_e = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
				_e.sort = PKMatchEvent.PK_EVENT_RIGHT_HERO_LIST;
			}
			
			dispatchEvent(_e);
		}
		
		
		private function _notifyTotalNumber(p:IPacket):void
		{
			var _p:PacketWCCampNumUpdate = p as PacketWCCampNumUpdate;
			
			
			m_totalNumber_TY = _p.camp1;
			m_totalNumber_TT = _p.camp2;
			
			m_TYCurrentNumber = _p.camp1_man;
			m_TTCurrentNumber = _p.camp2_man;
			
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_SORT_TOTAL_NUMBER;
			dispatchEvent(_e);
		}
		
		/**
		 * 请求获得总计积分。 这个是个异步的过程，需要向服务器发送请求。
		 * 
		 */		
		public function requestTotalNumber():void
		{
			var _p:PacketCWGetCampRank = new PacketCWGetCampRank();
			
			
			if(!TEST)
			{
				DataKey.instance.send(_p);
			}
			else
			{
				var _sp:PacketWCGetCampRank = new PacketWCGetCampRank();
				_sp.camp1 = 100;
				_sp.camp2 = 101;
				_sp.left_time = 200;
				
				_responseTotalNumber(_sp);
			}
		}
		
		
		//该 消息返回时的时间 
		private var m_responseAtTime:int;
		private function _responseTotalNumber(p:IPacket):void
		{
			var _p:PacketWCGetCampRank = p as PacketWCGetCampRank;
			m_totalNumber_TY = _p.camp1;
			m_totalNumber_TT = _p.camp2;
			
			m_remainingTime = _p.left_time;
			m_responseAtTime = getTimer();
			
			m_TYCurrentNumber = _p.camp1_man;
			m_TTCurrentNumber = _p.camp2_man;
			
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_SORT_TOTAL_NUMBER;
			dispatchEvent(_e);
		}
		
		
		/**
		 * 请求获得个人信息。  这个是个异步的过程，需要向服务器发送请求。
		 * 
		 */		
		public function requestPersonalInfo():void
		{
			var _p:PacketCSGetPlayerPkInfo = new PacketCSGetPlayerPkInfo();
			DataKey.instance.send(_p);
		}
		
		private function _responsePersonalInfo(p:IPacket):void
		{
			var _p:PacketSCGetPlayerPkInfo = p as PacketSCGetPlayerPkInfo;
			
			//个人信息   - 实力排名
			m_no = _p.no;
			
			//个人信息   - 当前连胜
			m_c_win = _p.c_win;
			
			//个人信息   - 实力积分
			m_rank = _p.rank;
			
			//个人信息   - 最高连胜
			m_max_win = _p.max_win;
			
			//个人信息  - 获得声望
			m_renown = _p.renown;
			
			
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_SORT_PERSONAL_INFO;
			dispatchEvent(_e);
		}
		
		/**
		 * 获得pk日排行榜数据 
		 * @param pageIndex     请求第几页的数据 
		 * 
		 */		
		public function requestGetDayPkRank(pageIndex:int):void
		{
			var _p:PacketCWGetDayPkRank = new PacketCWGetDayPkRank();
			_p.page = pageIndex;
			
			if(!TEST)
			{
				DataKey.instance.send(_p);
			}
			else
			{
				var _sp:PacketWCGetDayPkRank = new PacketWCGetDayPkRank();
				_sp.page = pageIndex;
				_sp.total_page = 2;
				
				_sp.list_data = new StructPk_Rank_List2();
				_sp.list_data.arrItemrank_list = new Vector.<StructPk_Rank_Info2>();
				
				var _item:StructPk_Rank_Info2 = new StructPk_Rank_Info2();
				_item.camp = 2;
				_item.level = 35;
				_item.max_win = 20;
				_item.metier = 1;
				_item.name = Lang.getLabelArr("arrPKMatch")[17];
				_item.rank = 10 ;
				_item.userid = 10000;
				_item.rank_no = 10 * pageIndex;
				_sp.list_data.arrItemrank_list.push(_item);
				
				
				_responseGetDayPkRank(_sp);
			}
			
		}
		
		private function _responseGetDayPkRank(p:IPacket):void
		{
			var _p:PacketWCGetDayPkRank = p as PacketWCGetDayPkRank;
			
			m_dayPkRank = _p;
			
			//m_dayPkRank.total_page = 2;
			
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_SORT_DAY_PK_RANK;
			dispatchEvent(_e);
		}
		
		/**
		 * 获得pk周排行榜数据 
		 * @param pageIndex
		 * 
		 */		
		public function requestGetWeekPkRank(pageIndex:int):void
		{
			var _p:PacketCWGetWeekPkRank= new PacketCWGetWeekPkRank();
			_p.page = pageIndex;
			
			if(!TEST)
			{
				DataKey.instance.send(_p);
			}
			else
			{
				var _sp:PacketWCGetWeekPkRank = new PacketWCGetWeekPkRank();
				_sp.page = pageIndex;
				_sp.total_page = 2;
				
				_sp.list_data = new StructPk_Rank_List2();
				_sp.list_data.arrItemrank_list = new Vector.<StructPk_Rank_Info2>();
				
				var _item:StructPk_Rank_Info2 = new StructPk_Rank_Info2();
				_item.camp = 2;
				_item.level = 35;
				_item.max_win = 20;
				_item.metier = 1;
				_item.name = Lang.getLabelArr("arrPKMatch")[18];
				_item.rank = 10 ;
				_item.userid = 10000;
				_item.rank_no = 10 * pageIndex;
				_sp.list_data.arrItemrank_list.push(_item);
				
				_responseGetWeekPkRank(_sp);
			}
			
		}
		
		private function _responseGetWeekPkRank(p:IPacket):void
		{
			var _p:PacketWCGetWeekPkRank = p as PacketWCGetWeekPkRank;
			
			m_weekPKRank = _p;
			
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_SORT_WEEK_PK_RANK;
			dispatchEvent(_e);
		}
		
		/**
		 * 获得每周排行数据 
		 * @return 
		 * 
		 */		
		public function getDayPKRank():PacketWCGetDayPkRank
		{
			return m_dayPkRank;
		}
		
		/**
		 * 获得每周排行数据
		 * @return 
		 * 
		 */		
		public function getWeekPKRank():PacketWCGetWeekPkRank
		{
			return m_weekPKRank;
		}
		
		/**
		 * 配对成功获得PK对手信息 
		 * @return 
		 * 
		 */		
		public function getMakePairData():PacketSCPkReadyStart
		{
			return m_makePairData;
		}
		
		/**
		 * 设置一下是否需要直接挂机 
		 * @param b
		 * 
		 */		
		public function setNeedGuaJi(b:Boolean):void
		{
			m_needGuaJi = b;
		}
		
		public function getNeedGuaJi():Boolean
		{
			return m_needGuaJi;
		}
		
		/**
		 * 服务器推送玩家的个人信息 
		 * @param p
		 * 
		 */		
		private function _notifyPersonalInfo(p:IPacket):void
		{
			var _p:PacketSCPlayerPkInfoUpdate = p as PacketSCPlayerPkInfoUpdate;
			
			//个人信息   - 实力排名
			m_no = _p.no;
			
			//个人信息   - 当前连胜
			m_c_win = _p.c_win;
			
			//个人信息   - 实力积分
			m_rank = _p.rank;
			
			//个人信息   - 最高连胜
			m_max_win = _p.max_win;
			
			//个人信息  - 获得声望
			m_renown = _p.renown;
			
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_SORT_NOTIFY_PERSONAL_INFO;
			dispatchEvent(_e);
		}
		
		/**
		 * 向服务器设定玩家所需要接受的信息。该功能起到一个开关的作用，尽可能的减轻网络负载
		 * @param sort     接受信息的类型 1 玩家pk信息 战报信息 2 阵营积分信息 3 阵营报名信息
		 * @param value    设定是否接收信息 1 接收 2 关闭接收
		 * 
		 */		
		public function requestCWSetPkUpdate(sort:int,value:int):void
		{
			var _p:PacketCWSetPkUpdate = new PacketCWSetPkUpdate();
			_p.sort = sort;
			_p.value = value;
			
			if(!TEST)
			{
				DataKey.instance.send(_p);
			}

		}
		
		
		

		/**
		 * 后台主动通知战报信息更新
		 * @param p
		 * 
		 */		
		private function _notifyWarInfo(p:IPacket):void
		{
			var _p:PacketSCPkNewsUpdate = p as PacketSCPkNewsUpdate;
			
			//首先判断是否为个人战报
			if(Data.myKing.roleID == _p.userid)
			{
				m_personalZhanBaoList.add(_p.userid,_p.username, _p.oppid,_p.oppname,_p.coin,_p.renown,_p.msg_id,_p.win);
			}
			
			m_allZhanBaoList.add(_p.userid,_p.username, _p.oppid,_p.oppname,_p.coin,_p.renown,_p.msg_id,_p.win);
			
						
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_NOTIFY_WAR_INFO;
			dispatchEvent(_e);
			
		}
		
		/**
		 * 请求离开 
		 * 
		 */		
		public function requestCSPlayerLeavePk():void
		{
			var _p:PacketCSPlayerLeavePk = new PacketCSPlayerLeavePk();
			DataKey.instance.send(_p);
			
			//退出参战状态
			setEntering(false);
			
			
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_NOTIFY_LEAVE_WAR;
			dispatchEvent(_e);
			
			if(20100068 == SceneManager.instance.currentMapId)
			{
				
				if(PKMatchPeiDuiWindow.getInstance().isOpen)
				{
					PKMatchPeiDuiWindow.getInstance().winClose();
					
				}
			}
			
			
		}
		
		/**
		 * 请求参加战斗 。 这个是个异步的过程，需要向服务器发送请求。
		 * 
		 */		
		public function requestEnterWar():void
		{
			var _p:PacketCWJoinPk = new PacketCWJoinPk();
			DataKey.instance.send(_p);
		}
		
		private function _responeEnterWar(p:IPacket):void
		{
			var _p:PacketWCJoinPk = p as PacketWCJoinPk;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
			
			//进入参战状态
			setEntering(true);
			
			var _e:PKMatchEvent = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
			_e.sort = PKMatchEvent.PK_EVENT_NOTIFY_ENTER_WAR;
			dispatchEvent(_e);
			
			
			if(20100068 == SceneManager.instance.currentMapId)
			{
				
				if(!PKMatchPeiDuiWindow.getInstance().isOpen)
				{
					PKMatchPeiDuiWindow.getInstance().setType(1);
					PKMatchPeiDuiWindow.getInstance().open(true);
					
				}
				else
				{
					PKMatchPeiDuiWindow.getInstance().repaint(1);
				}
			}
		}
		
		/**
		 * 后台服务器通知前台配对成功 
		 * @param p
		 * 
		 */		
		private function _notifyMakePair(p:IPacket):void
		{
			var _p:PacketSCPkReadyStart = p as PacketSCPkReadyStart;
			
			m_makePairData = _p;
			
			if(!PKMatchPeiDuiWindow.getInstance().isOpen)
			{
				PKMatchPeiDuiWindow.getInstance().setType(2);
				PKMatchPeiDuiWindow.getInstance().open(true);
				
			}
			else
			{
				PKMatchPeiDuiWindow.getInstance().repaint(2);
			}
			
			
		}
		
		
		
		private function _isIn(list:Vector.<StructPk_Player_List2>,player:StructPk_Player_List2):Boolean
		{
			var _ret:Boolean = false;
			var _tempPlayer:StructPk_Player_List2 = null;
			
			if(null == list || null == player )
			{
				return false;
			}
			
			var _length:int = list.length;
			for(var i:int=0; i<_length ; ++i)
			{
				_tempPlayer = list[i];
				
				if(_tempPlayer.userid == player.userid)
				{
					_ret = true;
					break;
				}
			}
			
			
			return _ret;
		}
		
		/**
		 * 玩家加入离开更新
		 * @param p
		 * 
		 */		
		private function _notifyJoinLeft(p:IPacket):void
		{
			var _p:PacketWCJoinLeftUpdate = p as PacketWCJoinLeftUpdate;
			var _player:StructPk_Player_List2 = null;
			var _e:PKMatchEvent = null;
			
			//状态: 1 加入 2离开
			if(1 == _p.state)
			{
				_player = new StructPk_Player_List2();
				_player.state = 1;
				_player.userid = _p.userid;
				_player.username = _p.username;
				_player.level = _p.level;
				//太乙 正派
				if(2 == _p.camp)
				{
					if(null != m_leftInfo && m_leftInfo.arrIteminfo_list.length < TOTAL_PAGE_NUM)
					{
						if(!_isIn(m_leftInfo.arrIteminfo_list,_player))
						{
							m_leftInfo.arrIteminfo_list.push(_player);
						}
						
						_e = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
						_e.sort = PKMatchEvent.PK_EVENT_LEFT_HERO_LIST;
						dispatchEvent(_e);
					}
				}
				//通天 邪派
				else if(3 == _p.camp)
				{
					if(null != m_rightInfo && m_rightInfo.arrIteminfo_list.length < TOTAL_PAGE_NUM)
					{
						if(!_isIn(m_rightInfo.arrIteminfo_list,_player))
						{
							m_rightInfo.arrIteminfo_list.push(_player);
						}
						//m_rightInfo.arrIteminfo_list.push(_player);
						
						_e = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
						_e.sort = PKMatchEvent.PK_EVENT_RIGHT_HERO_LIST;
						dispatchEvent(_e);
					}
				}
				
			}
//			else if(2 == _p.state)
//			{
//				
//			}
			
		}
		
		/**
		 * 玩家Pk状态更新 
		 * @param p
		 * 
		 */		
		private function _notifyPkState(p:IPacket):void
		{
			var _p:PacketWCPkStateUpdate = p as PacketWCPkStateUpdate;
			var _e:PKMatchEvent = null;
			var _length:int = 0;
			var _player:StructPk_Player_List2 = null;
			if(null != m_leftInfo)
			{
				_length = m_leftInfo.arrIteminfo_list.length;
				for(var i:int = 0 ; i < _length ; ++i)
				{
					_player = m_leftInfo.arrIteminfo_list[i];
					if(_player.userid == _p.userid)
					{
						_player.state = _p.state;
												
						
						_e = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
						_e.sort = PKMatchEvent.PK_EVENT_LEFT_HERO_LIST;
						dispatchEvent(_e);
						break;
					}
				}
			}
			
			if(null != m_rightInfo)
			{
				_length = m_rightInfo.arrIteminfo_list.length;
				for(var n:int = 0 ; n < _length ; ++n)
				{
					_player = m_rightInfo.arrIteminfo_list[n];
					if(_player.userid == _p.userid)
					{
						_player.state = _p.state;
						_e = new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
						_e.sort = PKMatchEvent.PK_EVENT_RIGHT_HERO_LIST;
						dispatchEvent(_e);
						break;
					}
				}
			}
			
			
		}
		
		private var m_instance_type:int = 0;
		
		/**
		 * 玩家进入副本消息 
		 * @param p
		 * 
		 */		
		private function _notifyPlayerEntryInstance(p:IPacket):void
		{
			var _p:PacketSCPlayerEntryInstanceMsg = p as PacketSCPlayerEntryInstanceMsg;
			
			m_instance_type = _p.instance_type;
			
			
		}
		
		
		private function _onEntryInstanceComplete(we : WorldEvent):void
		{
//			地图 id ： 20210014 天界之巅 [正式PK区]
//			地图 id ： 20210087 天界之巅 [等待区] 
					
			//20210014
			
			if(20210014 == we.data)
			{
				m_isEnterInstance = true;
				
				UI_index.indexMC_mrt.visible = false;
				
				//PK赛副本
				if(4 == m_instance_type && m_isEnterInstance)
				{
					requestReady();
				}
			}else if(20100001 == we.data){
				//2012-01-18 秦阳城
				
			}
			else
			{
				m_isEnterInstance = false;
				
				UI_index.indexMC_mrt.visible = true;
			}
			
			if(20210087 == we.data)
			{
				if(!PKMatchWindow.getInstance().isOpen)
				{
//					ZhenYing.instance().requestCamp();
				}
				
				if(!PKMatchPeiDuiWindow.getInstance().isOpen)
				{
					PKMatchPeiDuiWindow.getInstance().setType(1);
					PKMatchPeiDuiWindow.getInstance().open(true);
					
				}
				else
				{
					PKMatchPeiDuiWindow.getInstance().repaint(1);
				}
			}
			
			if( (20210014 != we.data) && (20210087 != we.data))
			{
				//请求离开PK赛活动的时候，告诉服务器停止解释战报消息
				requestCWSetPkUpdate(1,2);
				
				setEntering(false);
			}

		}
		
		/**
		 * 玩家离开副本消息 
		 * @param p
		 * 
		 */		
		private function _notifyPlayerLeaveInstance(p:IPacket):void
		{
			var _p:PacketSCPlayerLeaveInstanceMsg = p as PacketSCPlayerLeaveInstanceMsg;
			
			//PK赛副本
			if(4 == _p.instance_type)
			{
				m_isEnterInstance = false;
				
				
				
			}
		}
		
		
		/**
		 * 告诉服务器已经做好战斗准备了
		 * 
		 */		
		public function requestReady():void
		{
			var _p:PacketCSPkReadyOk = new PacketCSPkReadyOk();
			DataKey.instance.send(_p);
			
			m_isEnterInstance = false;
			m_instance_type = 0;
			
					}

		
	}
	
	
}



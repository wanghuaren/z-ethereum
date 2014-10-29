package model.gerenpaiwei
{
	
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import engine.support.IPacket;
	
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.*;
	import nets.packets.PacketCSAddFightCount;
	import nets.packets.PacketCSGetNowSH;
	import nets.packets.PacketCSGetSHAllRank;
	import nets.packets.PacketCSGetSHFightCount;
	import nets.packets.PacketCSGetSHGroupInfo;
	import nets.packets.PacketCSGetSHJoinList;
	import nets.packets.PacketCSGetSHPrize;
	import nets.packets.PacketCSGetSHPrizeInfo;
	import nets.packets.PacketCSGetSHRank;
	import nets.packets.PacketCSGetSignSH;
	import nets.packets.PacketCSModifySignSH;
	import nets.packets.PacketCSQuitSH;
	import nets.packets.PacketCSSignSH;
	import nets.packets.PacketSCAddFightCount;
	import nets.packets.PacketSCEntrySH;
	import nets.packets.PacketSCGetNowSH;
	import nets.packets.PacketSCGetNowSHUpdate;
	import nets.packets.PacketSCGetSHAllRank;
	import nets.packets.PacketSCGetSHFightCount;
	import nets.packets.PacketSCGetSHFightCountUpdate;
	import nets.packets.PacketSCGetSHGroupInfo;
	import nets.packets.PacketSCGetSHJoinList;
	import nets.packets.PacketSCGetSHPrize;
	import nets.packets.PacketSCGetSHPrizeInfo;
	import nets.packets.PacketSCGetSHRank;
	import nets.packets.PacketSCGetSignSH;
	import nets.packets.PacketSCModifySignSH;
	import nets.packets.PacketSCQuitSH;
	import nets.packets.PacketSCReadyEntrySH;
	import nets.packets.PacketSCSHAllFightMsg;
	import nets.packets.PacketSCSHFightManInfo;
	import nets.packets.PacketSCSHMatchUpdate;
	import nets.packets.PacketSCSHRankupdate;
	import nets.packets.PacketSCSHSelfFightMsg;
	import nets.packets.PacketSCSHServerNextMatchTime;
	import nets.packets.StructActCampPoint;
	import nets.packets.StructSHGroupMemberInfo;
	
	import scene.manager.SceneManager;
	
	import ui.base.mainStage.UI_index;
	import ui.view.gerenpaiwei.GRPW_CountDown_wait;
	import ui.view.gerenpaiwei.GRPW_KaiShi_ZhanDou;
	import ui.view.gerenpaiwei.GRPW_Main;
	import ui.view.gerenpaiwei.GRPW_fighting_wait;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view2.other.ControlButton;
	
	import world.WorldEvent;
	
	public class GRPW_Model  extends EventDispatcher
	{
		private static var instance:GRPW_Model;
		
		//			策划部_威震天(王东) 10:14:38
		//			20200186	战船	
		//			20200187	准备大厅
		public static const MAP_ID_ZHAN_CHUAN:int = 20200186;
		public static const MAP_ID_ZHUN_BEI:int = 20200187;
		
		
		public function GRPW_Model()
		{
			
			DataKey.instance.register(PacketSCGetSHRank.id, _responseSCGetSHRank);
			DataKey.instance.register(PacketSCSHRankupdate.id, _responseSCSHRankupdate);
			DataKey.instance.register(PacketSCAddFightCount.id, _responseSCAddFightCount);
			DataKey.instance.register(PacketSCGetSHFightCount.id, _responseSCGetSHFightCount);
			DataKey.instance.register(PacketSCGetSHFightCountUpdate.id, _responseSCGetSHFightCountUpdate);
			DataKey.instance.register(PacketSCGetNowSH.id, _responseSCGetNowSH);
			DataKey.instance.register(PacketSCGetNowSHUpdate.id, _responseSCGetNowSHUpdate);
			DataKey.instance.register(PacketSCModifySignSH.id, _responseSCModifySignSH);   
			DataKey.instance.register(PacketSCGetSHAllRank.id, _responseSCGetSHAllRank);   
			DataKey.instance.register(PacketSCEntrySH.id, _responseSCEntrySH);   
			DataKey.instance.register(PacketSCReadyEntrySH.id, _responseSCReadyEntrySH);   
			
			DataKey.instance.register(PacketSCGetSHPrizeInfo.id, _responseSCGetSHPrizeInfo);
			
			DataKey.instance.register(PacketSCSHFightManInfo.id, _responseSCSHFightManInfo);
			DataKey.instance.register(PacketSCGetSHJoinList.id, _responseSCGetSHJoinList);
			DataKey.instance.register(PacketSCSHSelfFightMsg.id, _responseSCSHSelfFightMsg);
			DataKey.instance.register(PacketSCSHAllFightMsg.id, _responseSCSHAllFightMsg);
			DataKey.instance.register(PacketSCSHMatchUpdate.id, _responseSCSHMatchUpdate);
			DataKey.instance.register(PacketSCGetSHPrize.id, _responseSCGetSHPrize);
			DataKey.instance.register(PacketSCSHServerNextMatchTime.id, _responseSCSHServerNextMatchTime);
			DataKey.instance.register(PacketSCGetSHGroupInfo.id, _responseSCGetSHGroupInfo);
			DataKey.instance.register(PacketSCGetSignSH.id, requestSCGetSignSH);
			
			
			DataKey.instance.register(PacketSCQuitSH.id, _responseSCQuitSH);
//			DataKey.instance.register(PacketSCSHQuitTeam.id, _responseSCQuitTeamSH);
			
			
			
			SceneManager.AddEventListener(WorldEvent.MapDataComplete, _onEntryInstanceComplete);
			
			
			
			///GameClock.instance.addEventListener(WorldEvent.CLOCK_FIVE_SECOND,_onClockFiveSecond);
		}
		
		private var m_testFMsg:int = 0;

	

		public function get duiwu():Vector.<StructSHGroupMemberInfo2>
		{
			return m_duiwu;
		}

		public function set duiwu(value:Vector.<StructSHGroupMemberInfo2>):void
		{
			m_duiwu = value;
		}

		/**是否已经报名参赛*/
		public function get isBaoMing():Boolean
		{
			return m_isBaoMing;
		}

		/**
		 * @private
		 */
		public function set isBaoMing(value:Boolean):void
		{
			m_isBaoMing = value;
			var _e:GRPW_Event=null;
			_e=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_IS_CANSAI;
			dispatchEvent(_e);
		}

		private function _onClockFiveSecond(e:WorldEvent = null):void
		{
			var _p:PacketSCSHAllFightMsg = new PacketSCSHAllFightMsg();
			++m_testFMsg;
			_p.msg = m_testFMsg + " 测试数据~~";
			_responseSCSHAllFightMsg(_p);     
		}
		
		private function _onEntryInstanceComplete(we : WorldEvent):void
		{
			if(MAP_ID_ZHUN_BEI == SceneManager.instance.currentMapId)
			{
				if(!GRPW_fighting_wait.getInstance().isOpen)
				{
					//GRPW_fighting_wait.getInstance().open(true);
				}
//				
				if(!GRPW_CountDown_wait.getInstance().isOpen)
				{
					if(getNextMatchTime() > 0)
					{
						GRPW_CountDown_wait.getInstance().open();
					}
				}
			}
			else 
			{
				if(GRPW_fighting_wait.getInstance().isOpen)
				{
					GRPW_fighting_wait.getInstance().winClose();
				}
				
				if(GRPW_CountDown_wait.getInstance().isOpen)
				{
					GRPW_CountDown_wait.getInstance().winClose();
				}
				
				if(GRPW_KaiShi_ZhanDou.getInstance().isOpen)
				{
					GRPW_KaiShi_ZhanDou.getInstance().winClose();
				}
			}
			
			if(MAP_ID_ZHUN_BEI == SceneManager.instance.currentMapId)
			{
				GRPW_Main.getInstance().open(true);
			
				GameTip.removeIconByActionId(20058);
			}
			else
			{
				GRPW_Main.getInstance().winClose();
			}
			
			if(MAP_ID_ZHAN_CHUAN == SceneManager.instance.currentMapId)
			{
				UI_index.indexMC_menuHead.y = 23 + 30;
			}
			else
			{
				UI_index.indexMC_menuHead.y = 23;
			}
		}
		
		
		public static function getInstance():GRPW_Model
		{
			if(null == instance)
			{
				instance = new GRPW_Model();
			}
			
			return instance;
		}
		
		////活动状态 0 结束 1 开始
		private var m_state:int = 0;
		public function getState():int
		{
			return m_state;
		}
		
		public function setState(s:int):void
		{
			m_state = s;
		}
		
		/**
		 * 根据积分计算段位 
		 * @param jifen
		 * @return 
		 * 
		 */		
		public function conutDuanWei(jifen:int):String
		{
			var _ret:String = "无";
			
			if(jifen >= _duanwei_0 && jifen <= _duanwei_200)
			{
				_ret = Lang.getLabelArr("arrGRPW_DuanWei")[0];
			}
			else if(jifen >= _duanwei_200+1 && jifen <= _duanwei_400)
			{
				_ret = Lang.getLabelArr("arrGRPW_DuanWei")[1];
			}
			else if(jifen >= _duanwei_400+1 && jifen <= _duanwei_600)
			{
				_ret = Lang.getLabelArr("arrGRPW_DuanWei")[2];
			}
			else if(jifen >= _duanwei_600+1)
			{
				_ret = Lang.getLabelArr("arrGRPW_DuanWei")[3];
			}
			
			
			return _ret;
		}
		//段位 分段
		private static const _duanwei_0 :int = 0;
		private static const _duanwei_200 :int = 200;
		private static const _duanwei_400 :int = 400;
		private static const _duanwei_600 :int = 600;
		/**
		 * 根据积分计算段位 
		 * @param jifen
		 * @return 
		 * 
		 */		
		public function conutDuanWei_(jifen:int):int
		{
			var _ret:int = 0;
			
			if(jifen >= _duanwei_0 && jifen <= _duanwei_200)
			{
				_ret = 0;
			}
			else if(jifen >= _duanwei_200+1 && jifen <= _duanwei_400)
			{
				_ret = 1;
			}
			else if(jifen >= _duanwei_400+1 && jifen <= _duanwei_600)
			{
				_ret = 2;
			}
			else if(jifen >= _duanwei_600+1)
			{
				_ret = 3;
			}
			
			
			return _ret;
		}
		
		//---------------------------是否报名------------------------------------------------------------
		public function requestCSGetSignSH():void
		{
			var _p:PacketCSGetSignSH=new PacketCSGetSignSH();
			DataKey.instance.send(_p);
		}
		private function requestSCGetSignSH(p:IPacket):void
		{
			var _p:PacketSCGetSignSH = p as PacketSCGetSignSH;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			var baom:int = _p.sign;
			if(baom==0){
				isBaoMing = false;
			}else{
				isBaoMing = true;
			}
			
//			var _e:GRPW_Event=null;
//			_e=new GRPW_Event(GRPW_Event.GRPW_EVENT);
//			_e.sort = GRPW_Event.GRPW_EVENT_SORT_SHRank;
//			dispatchEvent(_e);
		}
		//---------------------  个人赛排名情况   --------------------------
		public function requestCSGetSHRank():void
		{
			var _p:PacketCSGetSHRank=new PacketCSGetSHRank();
			DataKey.instance.send(_p);
		}
	
		private function _responseSCGetSHRank(p:IPacket):void
		{
			var _p:PacketSCGetSHRank = p as PacketSCGetSHRank;
			m_arrItemrank_info = _p.arrItemrank_info;
			m_selfNo = _p.no;
			
			var _e:GRPW_Event=null;
			_e=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_SHRank;
			dispatchEvent(_e);
		}
		
		private function _responseSCSHRankupdate(p:IPacket):void
		{
			var _p:PacketSCSHRankupdate = p as PacketSCSHRankupdate;
			m_arrItemrank_info = _p.arrItemrank_info;
			m_selfNo = _p.no;
			

			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_SHRank;
			dispatchEvent(_e);
			
		}
		
		private var m_arrItemrank_info:Vector.<StructSHRankInfo2> = null;
		public function getArrItemrank_info():Vector.<StructSHRankInfo2>
		{
			return m_arrItemrank_info;
		}
		
		private var m_selfNo:int = 0;
		public function getSelfNo():String
		{
			if(m_selfNo==0){
				return Lang.getLabel("40062_bang_shang_wu_ming");
			}
			return String(m_selfNo);
		}
		
		//--------------------- -------------- --------------------------
		
		
		//---------------------  今日个人赛比赛结果   --------------------------
		
		public function requestCSGetNowSH():void
		{
			var _p:PacketCSGetNowSH=new PacketCSGetNowSH();
			DataKey.instance.send(_p);
		}
		
		
		private function _responseSCGetNowSH(p:IPacket):void
		{
			var _p:PacketSCGetNowSH = p as PacketSCGetNowSH;
			m_win = _p.win;
			m_winmax = _p.winmax;
			m_lost = _p.lost;
			m_coin = _p.coin;
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_TODAY;
			dispatchEvent(_e);
		}
		
		private function _responseSCGetNowSHUpdate(p:IPacket):void
		{
			var _p:PacketSCGetNowSHUpdate = p as PacketSCGetNowSHUpdate;
			m_win = _p.win;
			m_winmax = _p.winmax;
			m_lost = _p.lost;
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_TODAY;
			dispatchEvent(_e);
		}
		
		/** 
		 *胜利场次
		 */
		private var m_win:int;
		public function getWin():int
		{
			return m_win;
		}
		
		/** 
		 *失败场次
		 */
		private var m_lost:int;
		public function getLost():int
		{
			return m_lost;
		}
		
		/** 
		 *最大连胜次数
		 */
		private var m_winmax:int;
		public function getWinMax():int
		{
			return m_winmax;
		}
		
		/**
		 * 当前积分 
		 */		
		private var m_coin:int;
		public function getCoin():int
		{
			return m_coin;
		}
		
		
		/**
		 * 称号(根据策划案子中的积分算出来)
		 * @return 
		 * 
		 */		
		public function getChengHao():String
		{
			var _ret:String = conutDuanWei(m_coin);
			return _ret;
		}
		
		
		/**
		 * 距离下一个等级还需要多少积分 
		 * @return 
		 * 
		 */		
		public function getNeedCoin_NextLevel():String
		{
			var _ret:int = 0;
			var _retStr:String = "";
			
			if(m_coin >= _duanwei_0 && m_coin <= _duanwei_200)
			{
				_ret = (_duanwei_200+1 - m_coin);
				_retStr = Lang.getLabel("40097_GRPW_DuanWei_0",[_ret,Lang.getLabelArr("arrGRPW_DuanWei")[1]]);
			}
			else if(m_coin >= _duanwei_200+1 && m_coin <= _duanwei_400)
			{
				_ret = (_duanwei_400+1 - m_coin);
				_retStr = Lang.getLabel("40097_GRPW_DuanWei_0",[_ret,Lang.getLabelArr("arrGRPW_DuanWei")[2]]);
			}
			else if(m_coin >= _duanwei_400+1 && m_coin <= _duanwei_600)
			{
				_ret = (_duanwei_600+1 - m_coin);
				_retStr = Lang.getLabel("40097_GRPW_DuanWei_0",[_ret,Lang.getLabelArr("arrGRPW_DuanWei")[3]]);
			}
			else if(m_coin >= _duanwei_600+1)
			{
				_ret = 0;
				_retStr = "";
			}
			
			
			return _retStr;
		}
		
		
		

		//--------------------- -------------- --------------------------

		
		//- --------------------- 增加         个人赛比赛次数    ---------------------
		
		public function requestCSAddFightCount():void
		{
			var _p:PacketCSAddFightCount=new PacketCSAddFightCount();
			DataKey.instance.send(_p);
		}
		
		
		private function _responseSCAddFightCount(p:IPacket):void
		{
			var _p:PacketSCAddFightCount = p as PacketSCAddFightCount;
			
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			
			requestCSGetSHFightCount();
			
		}
		
		
		//获得个人赛比赛次数
		public function requestCSGetSHFightCount():void
		{
			var _p:PacketCSGetSHFightCount=new PacketCSGetSHFightCount();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCGetSHFightCount(p:IPacket):void
		{
			var _p:PacketSCGetSHFightCount = p as PacketSCGetSHFightCount;
			
			m_remainder = _p.num;
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_FIGHT_COUNT;
			dispatchEvent(_e);
		}
		
		private function _responseSCGetSHFightCountUpdate(p:IPacket):void
		{
			var _p:PacketSCGetSHFightCountUpdate = p as PacketSCGetSHFightCountUpdate;
			
			m_remainder = _p.num;	
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_FIGHT_COUNT;
			dispatchEvent(_e);
			
		}
		
		private var m_remainder:int = 0;
		//获得个人赛比赛次数
		public function getRemainder():int
		{
			return m_remainder;
		}
		
		
		//--------------------- -------------- --------------------------
		
		
		//-----------------------------  修改报名方式 ---------//这个协议没用了---------------------
		public function requestCSModifySignSH():void
		{
			
			var _p:PacketCSModifySignSH=new PacketCSModifySignSH();
			DataKey.instance.send(_p);
		}
		
		
		private function _responseSCModifySignSH(p:IPacket):void
		{
			var _p:PacketSCModifySignSH = p as PacketSCModifySignSH;
			
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
		}
		//--------------------------------------------------------------------
		
		
		/***
		 * 
  <packet id="53014" name="SCSHSelfFightMsg" desc="个人战报信息" sort="2"> 	
		<prop name="msg" type="7" length="256" desc="信息"/>
  </packet>
 
  <packet id="53015" name="SCSHAllFightMsg" desc="全体战报信息" sort="2">  	
		<prop name="msg" type="7" length="256" desc="信息"/>
  </packet>
		 * 
		 * 
		 * 
		 * 
		 * */
		
		//-----------------------  个人战报信息 , 全体战报信息  ----------------------
		
		//个人 ，全部 最大条数
		private static const m_max:int = 50;
		
		private var m_selfList:Vector.<String> = null;
		public function getSelfList():Vector.<String>
		{
			return m_selfList;
		}
		
		
		//个人
		private function _responseSCSHSelfFightMsg(p:IPacket):void
		{
			var _p:PacketSCSHSelfFightMsg = p as PacketSCSHSelfFightMsg;
			if(null == m_selfList)
			{
				m_selfList = new Vector.<String>();
			}
			
			if(m_selfList.length > m_max)
			{
				m_selfList.shift();
			}
			
			m_selfList.push(_p.msg);
			
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_ZHANBAO_SELF;
			dispatchEvent(_e);
		}
		
		private var m_allList:Vector.<String> = null;
		public function getAllList():Vector.<String>
		{
			return m_allList;
		}
		
		
		//全部
		private function _responseSCSHAllFightMsg(p:IPacket):void
		{
			var _p:PacketSCSHAllFightMsg = p as PacketSCSHAllFightMsg;
			
			if(null == m_allList)
			{
				m_allList = new Vector.<String>();
			}
			
			if(m_allList.length > m_max)
			{
				m_allList.shift();
			}
			
			m_allList.push(_p.msg);
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_ZHANBAO_ALL;
			dispatchEvent(_e);

		}

		//------------------------------------------------------------------
		
		
		//------------------------------个人赛参赛列表  (参赛过程中....)--------------------------------
		
		//参赛过程中....
		
		
		/*
		<packet id="53009" name="CSGetSHJoinList" desc="请求个人赛参赛列表" sort="1"> 	  	
  	
			</packet>    
			
			<packet id="53010" name="SCGetSHJoinList" desc="请求个人赛参赛列表返回" sort="2">
			  <prop name="total_num" type="3" length="0" desc="总人数"/>
			  <prop name="joinlist" type="4226" length="20" desc="参赛列表"/>		
			</packet>
		   
			<packet id="53011" name="SCAddSHJoinList" desc="个人赛参赛列表增加" sort="2">
			  <prop name="total_num" type="3" length="0" desc="总人数"/>
			  <prop name="joinlist" type="4226" length="0" desc="参赛列表"/>		
			</packet>
		
		*/
		//------------------------------个人赛参赛列表  (参赛过程中....)--------------------------------
		public function requestCSGetSHJoinList():void
		{
			var _p:PacketCSGetSHJoinList=new PacketCSGetSHJoinList();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCGetSHJoinList(p:IPacket):void
		{
			var _p:PacketSCGetSHJoinList = p as PacketSCGetSHJoinList;
			m_arrItemjoinlist = _p.arrItemjoinlist;
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_FIGHT_Rank;
			dispatchEvent(_e);
		}
		
		
		private var m_arrItemjoinlist:Vector.<StructSHJoinInfo2> = null;
		public function getArrItemjoinlist():Vector.<StructSHJoinInfo2>
		{
			return m_arrItemjoinlist;
		}
		
		
		/**
		 *  
		 * @param zy   职业
		 * @param dw   段位
		 * @return 
		 * 
		 */		
		public function getArrItemjoinlistFilter(zy:int,dw:int):Vector.<StructSHJoinInfo2>
		{
			var _ret:Vector.<StructSHJoinInfo2> = new Vector.<StructSHJoinInfo2>();
			
			if(null == m_arrItemjoinlist)
			{
				return _ret;
			}
			
			var _d:StructSHJoinInfo2 = null;
			for(var i:int = 0 ;i < m_arrItemjoinlist.length ; ++i)
			{
				_d = m_arrItemjoinlist[i]; 
				
//				if(conutDuanWei_(_d.jifen))
//				{
//					
//				}
				
				if( (zy < 0 || zy == _d.metier)  && (dw < 0) )
				{
					_ret.push(_d);
				}
			}
			
			return _ret;
		}
			
		
		
		//------------------------------个人赛参赛列表  (非参赛过程中....)------------------------------
		//非参赛过程中
		
		/*
		
		<packet id="53025" name="CSGetSHAllRank" desc="获得个人赛比赛排名数据" sort="1"> 	
		<prop name="page" type="3" length="0" desc="请求的页数 1 开始"/>  	 	  	 	
		</packet>
		
		<packet id="53026" name="SCGetSHAllRank" desc="获得个人赛比赛排名数据返回" sort="2">  	
		<prop name="page" type="3" length="0" desc="请求的页数 1 开始"/>  	 	  	 	
		<prop name="total" type="3" length="0" desc="总人数"/>  	 	  	 	
		<prop name="userinfo" type="4228" length="20" desc="用户信息"/>
		</packet> 
		*/	
		
		/**
		 * 获得个人赛比赛排名数据
		 * 
		 */		
		public function requestCSGetSHAllRank():void
		{
			var _p:PacketCSGetSHAllRank=new PacketCSGetSHAllRank();
			//_p.page = page;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCGetSHAllRank(p:IPacket):void
		{
			var _p:PacketSCGetSHAllRank = p as PacketSCGetSHAllRank;   
			
			arrItemuserinfo = _p.arrItemuserinfo;
			
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_AllRank;
			dispatchEvent(_e);
		}
		
		
		/** 
		 *用户信息
		 */
		private var arrItemuserinfo:Vector.<StructSHTotalUserInfo2> = null;//非参赛过程中的排名
		
		/**
		 *  
		 * @param zy   职业
		 * @param dw   段位
		 * @return 
		 * 
		 */		
		public function getArrItemuserinfo(zy:int , dw:int):Vector.<StructSHTotalUserInfo2>
		{
			var _ret:Vector.<StructSHTotalUserInfo2> = new Vector.<StructSHTotalUserInfo2>();
			
			var _dw:int = -1;
			
			for each(var item:StructSHTotalUserInfo2 in arrItemuserinfo)
			{
				if( zy > 0 && item.metier != zy)
				{
					continue;
				}
				
				_dw =  conutDuanWei_(item.coin) ;
				if( dw >= 0 && _dw != dw)
				{
					continue;
				}
				
				_ret.push(item);
			}
			
			return _ret;
		}
		
		//------------------------- 
		
		
		////-------------------------  获得个人赛比赛奖励  -------------------------
		//1 每日连胜 2 每日参与 3 连续参与
		public function requestCSGetSHPrize(t:int):void
		{
			var _p:PacketCSGetSHPrize = new PacketCSGetSHPrize();
			_p.index = t;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCGetSHPrize(p:IPacket):void
		{
			var _p:PacketSCGetSHPrize = p as PacketSCGetSHPrize;    
		
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			
			requestCSGetSHPrizeInfo();
		
		}
		
		//------------------------------------------------------------------
		
		
		/*
		
		<packet id="53027" name="CSGetSHPrizeInfo" desc="获得个人赛比赛奖励信息" sort="1"> 	  		  	 	
		</packet>
		
		<packet id="53028" name="SCGetSHPrizeInfo" desc="获得个人赛比赛奖励信息返回" sort="2">  	
		<prop name="prize1" type="3" length="0" desc="每日连胜奖励 0不能领取 1 可以领取 2 已经领取"/>  	 	  	 	
		<prop name="prize2" type="3" length="0" desc="每日参与奖励 0不能领取 1 可以领取 2 已经领取"/>  	 	  	 	
		<prop name="prize3" type="3" length="0" desc="连续参与奖励 0不能领取 1 可以领取 2 已经领取"/>  	 	  	 	
		</packet> 
		
		<packet id="53029" name="CSGetSHPrize" desc="获得个人赛比赛奖励" sort="1"> 	
		<prop name="type" type="3" length="0" desc="1 每日连胜 2 每日参与 3 连续参与"/>  	 	  	 	
		</packet>
		
		<packet id="53030" name="SCGetSHPrize" desc="获得个人赛比赛奖励返回" sort="2">  	
		<prop name="tag" type="3" length="0" desc="结果"/>
		<prop name="msg" type="7" length="256" desc="信息"/>
		</packet> 
		
		*/
		
		/*<packet id="52902" name="CSQuitSH" desc="是否已经报名参赛" sort="1">
  </packet>
  <packet id="52903" name="SCQuitSH" desc="是否已经报名参赛返回" sort="2">
  	<prop name="sign"type="3" length="0" desc="参赛状态，0 未参赛，1 已参赛"/>
    <prop name="tag" type="3" length="0" desc="结果"/>
  </packet>*/
		/**是否已经报名参赛 */
		public function requestCSQuitTeam():void
		{
//			var _p:PacketCSSHQuitTeam = new PacketCSSHQuitTeam();
//			DataKey.instance.send(_p);
		}
		private function _responseSCQuitTeamSH(p:IPacket):void
		{
//			var _p:PacketSCSHQuitTeam = p as PacketSCSHQuitTeam;
//			
//			if (0 != _p.tag)
//			{
//				Lang.showResult(_p);
//				return;
//			}
		
		}
		/**是否已经报名参赛 */
		private var m_isBaoMing:Boolean;
	//---------------------------------------------------------------
		/**退出参赛 */
		public function requestCSQuitSH():void
		{
			var _p:PacketCSQuitSH = new PacketCSQuitSH();
			DataKey.instance.send(_p);
		}
		private function _responseSCQuitSH(p:IPacket):void
		{
			var _p:PacketSCQuitSH = p as PacketSCQuitSH;
			
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
//			isBaoMing = false;
		}
	
		//--------------------获得个人赛队伍数据---------------------------
		private var m_duiwu:Vector.<StructSHGroupMemberInfo2>;
		public function requestCSGetSHGroupInfo():void
		{
			var _p:PacketCSGetSHGroupInfo = new PacketCSGetSHGroupInfo();
			DataKey.instance.send(_p);
		}
		private function _responseSCGetSHGroupInfo(p:IPacket):void
		{
			var _p:PacketSCGetSHGroupInfo = p as PacketSCGetSHGroupInfo;   
			
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			 duiwu = _p.arrItemgroupmemberinfo;
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_DUI_WU;
			dispatchEvent(_e);
		}
		//-----------------------------  获得个人赛比赛奖励信息  -----------------------------
		public function requestCSGetSHPrizeInfo():void
		{
			var _p:PacketCSGetSHPrizeInfo = new PacketCSGetSHPrizeInfo();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCGetSHPrizeInfo(p:IPacket):void
		{
			var _p:PacketSCGetSHPrizeInfo = p as PacketSCGetSHPrizeInfo;   
//			m_prize1 = _p.prize1;
//			m_prize2 = _p.prize2;
//			m_prize3 = _p.prize3;
			m_prize = _p.prize;
			today_win = _p.today_win;
			today_join = _p.today_join;
			
			cur_week_win = _p.cur_week_win;
			cur_week_join = _p.cur_week_join;
			last_week_no = _p.last_week_no;
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_PRIZE;
			dispatchEvent(_e);
		}
		public var today_win:int;
		public var today_join:int;
		public var cur_week_win:int;
		public var cur_week_join:int;
		public var last_week_no:int;

		
		/** 
		 *每日连胜奖励 0未领取 1 已领取 
		 */
		public var m_prize:int;
		
		
		
		//--------------------------------------------------------------------------------
		
		
		
		/*
		
		<packet id="53000" name="CSSignSH" desc="报名server hero" sort="1"> 	
		<prop name="join_type" type="3" length="0" desc="参与类型 低位第1位 单人匹配 低位第2位 2人匹配 低位第3位 3人匹配"/> 	
		</packet>    
		
		<packet id="53001" name="SCEntrySH" desc="报名server hero返回" sort="2">
		<prop name="tag" type="3" length="0" desc="结果"/>
		<prop name="msg" type="7" length="256" desc="信息"/>
		</packet>
		
		*/
		
		//-----------------------------  报名参赛 -----------------------------------
		
		
		public function requestCSSignSH():void
		{
			
			var _p:PacketCSSignSH = new PacketCSSignSH();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCEntrySH(p:IPacket):void
		{
			var _p:PacketSCEntrySH = p as PacketSCEntrySH;   
			
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
//			this.isBaoMing = true;
		}
		
		
		//-------------------------------------------------------------------------
		
		//---------------------------   准备开始战斗   ----------------------------
		
		private function _responseSCSHMatchUpdate(p:IPacket):void
		{
			var _p:PacketSCSHMatchUpdate = p as PacketSCSHMatchUpdate;
			
			if(!GRPW_KaiShi_ZhanDou.getInstance().isOpen)
			{
				GRPW_KaiShi_ZhanDou.getInstance().open(true);
			}
			
			GRPW_KaiShi_ZhanDou.getInstance().setData(_p.arrItemself_team,_p.arrItemtaget_team);  
			
			if(GRPW_CountDown_wait.getInstance().isOpen)
			{
				GRPW_CountDown_wait.getInstance().winClose();
			}
			
			if(!GRPW_fighting_wait.getInstance().isOpen)
			{
				GRPW_fighting_wait.getInstance().open(true,false);
			}
			
			m_fightingTeam_1 = null;
			m_fightingTeam_2 = null;    
			
		}
		//-----------------------------------------------------------------
		
		
		
		//------------------------------比赛马上开始 ，跳出 感叹号 ---------------------------
		
		
		private function _responseSCReadyEntrySH(p:IPacket):void
		{
			var _p:PacketSCReadyEntrySH = p as PacketSCReadyEntrySH;
			
			if(Data.myKing.level<60)return;
			GameTip.addTipButton(function(param:int):void
			{
				if(param == 1)
				{
					GRPW_Main.getInstance().open();
				}
			}, 3, Lang.getLabel("40097_GRPW_GanTanHao"), 1, _p.action_id);
			
		}
		
		
		
		//---------------------------- 在比赛的过程中 显示 双方的战斗情况 ，----------------------
		
		private function _responseSCSHFightManInfo(p:IPacket):void
		{
			var _p:PacketSCSHFightManInfo = p as PacketSCSHFightManInfo;
			
			m_fightingTeam_1 = _p.arrItemteam1;
			m_fightingTeam_2 = _p.arrItemteam2;
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_FIGHTING;
			dispatchEvent(_e);
		}
		
		
		private var m_fightingTeam_1:Vector.<StructSHFightUserInfo2> = null;
		public function getFightingTeam_1():Vector.<StructSHFightUserInfo2>
		{
			return m_fightingTeam_1;
		}
		
		private var m_fightingTeam_2:Vector.<StructSHFightUserInfo2> = null;
		public function getFightingTeam_2():Vector.<StructSHFightUserInfo2>
		{
			return m_fightingTeam_2;
		}
		
		//-----------------------------------------------------------------
		
		
		
		//---------------------------- 下一场比赛的开始时间更新   --------------------
		private var _nextMatchTime:Number = 0;
		private var _nextMatchTimeLast:Boolean = false;
		public function getNextMatchTime():Number
		{
			return _nextMatchTime;
		}
		
		public function isLastMatch():Boolean
		{
			return _nextMatchTimeLast;
		}
		
		private function _responseSCSHServerNextMatchTime(p:IPacket):void
		{
			var _p:PacketSCSHServerNextMatchTime = p as PacketSCSHServerNextMatchTime;
			_nextMatchTime = _p.time * 1000;
			
			//最后一场
			if(1 == _p.last)
			{
				_nextMatchTimeLast = true;
			}
			else
			{
				_nextMatchTimeLast = false;
			}
			
			
			var _e:GRPW_Event=new GRPW_Event(GRPW_Event.GRPW_EVENT);
			_e.sort = GRPW_Event.GRPW_EVENT_SORT_NEXT_MATCH_TIME;
			dispatchEvent(_e);
			
			if(MAP_ID_ZHUN_BEI == SceneManager.instance.currentMapId)
			{
				if(!GRPW_CountDown_wait.getInstance().isOpen)
				{
					if(getNextMatchTime() > 0)
					{
						GRPW_CountDown_wait.getInstance().open();
					}
				}
			}
			else
			{
				if(GRPW_CountDown_wait.getInstance().isOpen)
				{
					GRPW_CountDown_wait.getInstance().winClose();
				}
			}
			
		}
		
		
		
		//-----------------------------------------------------------------
		
		
	}
	
	
}






 
 




 
 
 
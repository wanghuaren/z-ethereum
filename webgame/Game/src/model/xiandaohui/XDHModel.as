package model.xiandaohui
{
	import flash.events.EventDispatcher;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCEntryServerTower2;
	import netc.packets2.PacketSCEntryServerTowerNext2;
	import netc.packets2.PacketSCGetServerPKAllGamble2;
	import netc.packets2.PacketSCGetServerPKCost2;
	import netc.packets2.PacketSCGetServerPKResult2;
	import netc.packets2.PacketSCGetServerPKSelfInfo2;
	import netc.packets2.StructServerPlayerPkInfo2;
	
	import engine.support.IPacket;
	import nets.packets.PacketCSGetServerPKAllGamble;
	import nets.packets.PacketCSGetServerPKCamble;
	import nets.packets.PacketCSGetServerPKCost;
	import nets.packets.PacketCSGetServerPKResult;
	import nets.packets.PacketCSGetServerPKSelfInfo;
	import nets.packets.PacketCSServerPKCamble;
	import nets.packets.PacketCWCurServerPkInfo;
	import nets.packets.PacketSCEntryServerTower;
	import nets.packets.PacketSCEntryServerTowerNext;
	import nets.packets.PacketSCGetServerPKAllGamble;
	import nets.packets.PacketSCGetServerPKCamble;
	import nets.packets.PacketSCGetServerPKCost;
	import nets.packets.PacketSCGetServerPKResult;
	import nets.packets.PacketSCGetServerPKSelfInfo;
	import nets.packets.PacketSCServerPKCamble;
	import nets.packets.PacketWCCurServerPkInfo;
	import nets.packets.StructServerPlayerPkInfo;
	
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import ui.view.view4.xiandaohui.XDHZhiChi;
	
	import common.managers.Lang;

	/**
	 * 仙道会模块
	 * @author steven guo
	 * 
	 */	
	public class XDHModel extends EventDispatcher
	{
		//单例模式
		private static var m_instance:XDHModel = null;
		
		//节点数据
		private var m_nodes_all:Array = null;

		
		//原始数据
		private var m_arrItemman_list:Vector.<StructServerPlayerPkInfo2> = null;
		//按照 "序号" 索引 参赛玩家
		private var m_players_no:Array = null;
		//按照 "玩家ID" 索引 参赛玩家
		private var m_players_userid:Array = null;
		//按照 "accountid" 索引 参赛玩家
		private var m_players_accountid:Array = null;
		
		public static const XDH_MATCH_32:int = 32;  
		public static const XDH_MATCH_16:int = 16;
		public static const XDH_MATCH_8:int = 8;
		public static const XDH_MATCH_4:int = 4;
		public static const XDH_MATCH_2:int = 2;
		public static const XDH_MATCH_1:int = 1;
		
		// 当前游戏的阶段,5个主要阶段
		public static const TIMESTEP_MAIN_1:int = 1;     //第一场 争夺16强 
		public static const TIMESTEP_MAIN_2:int = 2;     //第二场 争夺8强
		public static const TIMESTEP_MAIN_3:int = 3;     //第三场 争夺4强
		public static const TIMESTEP_MAIN_4:int = 4;     //第四场 半决赛
		public static const TIMESTEP_MAIN_5:int = 5;     //第五场 决赛
		public static const TIMESTEP_MAIN_6:int = 6;     //整个比赛都结束了，冠军也出来了
		// 每个主阶段中3个小阶段
		public static const TIMESTEP_SUB_1:int = 1;      //比赛前
		public static const TIMESTEP_SUB_2:int = 2;      //比赛中
		public static const TIMESTEP_SUB_3:int = 3;      //比赛后
		
		//主要阶段
		private var m_timestep_main:int =  TIMESTEP_MAIN_1;
		//小阶段
		private var m_timestep_sub:int =  TIMESTEP_SUB_1;
		
	    //每个阶段的比赛胜利数据
		private var m_hasMatch_1:int;         //第一场 争夺16强  胜利者数据
		private var m_hasMatch_2:int;         //第二场 争夺8强     胜利者数据
		private var m_hasMatch_3:int;         //第三场 争夺4强     胜利者数据
		private var m_hasMatch_4:int;         //第四场 半决赛       胜利者数据
		private var m_hasMatch_5:int;         //第五场 决赛            胜利者数据
		
		//用于保存自己的最好成绩
		private var m_myWinNode:XDHStructNode = null;
		
		//是否已经支持过
		private var m_hasPKCamble:Boolean = false;
		
		//当前是第几届
		private var m_cur_no:int = 0;
		
		public function XDHModel()
		{
			//获得当前pk服务器信息
			DataKey.instance.register(PacketWCCurServerPkInfo.id,_responsePacketWCCurServerPkInfo);    
			
			DataKey.instance.register(PacketSCGetServerPKCamble.id,_responseSCGetServerPKCamble);    
			
			
			//获得玩家押注返回
			DataKey.instance.register(PacketSCServerPKCamble.id,_responsePacketSCServerPKCamble); 
			
			//战报,获得玩家比赛结果返回
			DataKey.instance.register(PacketSCGetServerPKResult.id,_responsePKResult);
			
			//获得玩家身价信息返回
			DataKey.instance.register(PacketSCGetServerPKCost.id,_responsePKCost);
			
			//获得玩家所有押注信息返回
			DataKey.instance.register(PacketSCGetServerPKAllGamble.id,_responsePKAllGamble);
			
			//获得玩家战绩信息
			DataKey.instance.register(PacketSCGetServerPKSelfInfo.id,_responsePKSelfInfo);
			
			

			_init();
		}
		
		public static function getInstance():XDHModel
		{
			if(null == m_instance)
			{
				m_instance = new XDHModel();
			}
			return m_instance;
		}
		
		private function _init():void
		{
			if(null == m_nodes_all)
			{
				m_nodes_all = [];
				_constructNode(32,m_nodes_all);
			}
		}
		
		public function getNodes():Array
		{
			return m_nodes_all;
		}
		
		/**
		 * 获得自己的最好成绩,如果为null的话，说明自己根本没有参加比赛 
		 * @return 
		 * 
		 */		
		public function getMyWinNode():XDHStructNode
		{
			return m_myWinNode;
		}
		
		private var m_level:int = 0;
		private function _constructNode(max:int , nodesAll:Array):void
		{
			if(null == nodesAll || nodesAll.length >= max)
			{
				return ;
			}
			var _node:XDHStructNode = null;
			var _nodeChild:XDHStructNode = null;
			var _length:int = nodesAll.length;
			
			if(_length <= 0)
			{
				_node = new XDHStructNode();
				_node.index = 0;
				_node.level = 0;
				nodesAll.push(_node);
			}
			
			++m_level;
			_length = nodesAll.length;
			for(var i:int = 0; i < _length; ++i)
			{
				_node = nodesAll[i];
				if(null == _node || null != _node.child0 || null != _node.child1)
				{
					continue;
				}
				
				_nodeChild = new XDHStructNode(); 
				_node.child0 = _nodeChild;
				_nodeChild.parent = _node;
				_nodeChild.index = nodesAll.length;
				_nodeChild.level = m_level;
				nodesAll.push(_nodeChild);
				
				
				_nodeChild = new XDHStructNode(); 
				_node.child1 = _nodeChild;
				_nodeChild.parent = _node;
				_nodeChild.index = nodesAll.length;
				_nodeChild.level = m_level;
				nodesAll.push(_nodeChild);
			}
			
			_constructNode(max,nodesAll);
		}
		
		/**
		 * 获得冠军节点 
		 * @return 
		 * 
		 */		
		public function getGoldWinnerNode():XDHStructNode
		{
			return m_nodes_all[0];
		}
		
		/**
		 * 获得原始数据 
		 * @return 
		 * 
		 */		
		public function getArrItemmanList():Vector.<StructServerPlayerPkInfo2>
		{
			return m_arrItemman_list;
		}
		
		/**
		 * 通过 序号 获得参赛玩家信息 
		 * @param no
		 * @return 
		 * 
		 */		
		public function getPlayerPkInfo_no(no:int):StructServerPlayerPkInfo2
		{
			return m_players_no[no];
		}
		
		/**
		 * 通过 userid 获得参赛玩家信息 
		 * @param userid
		 * @return 
		 * 
		 */		
		public function getPlayerPkInfo_userid(userid:int):StructServerPlayerPkInfo2
		{
			return m_players_userid[userid];
		}
		
		
		public function getTimeStepMain():int
		{
			return m_timestep_main;
		}
		
		public function getTimeStepSub():int
		{
			return m_timestep_sub;
		}
		
		/**
		 * 当前是 第几届  
		 * @return 
		 * 
		 */		
		public function getCurNo():int
		{
			return m_cur_no;
		}

		public static function changeToNameString(stepMainID:int):String
		{
			return (Lang.getLabelArr("arrXDH_Step_Main_Name"))[stepMainID];
		}
		
		// --------------------------   网络协议处理  开始  -----------------------
		public function requestPacketCWCurServerPkInfo():void
		{
			var _p:PacketCWCurServerPkInfo = new PacketCWCurServerPkInfo();
			DataKey.instance.send(_p);
			
			//测试数据
			
			/*
			var _testPacket:PacketWCCurServerPkInfo = null;
			var _testPlayer:StructServerPlayerPkInfo2 = null;
				
			_testPacket =new PacketWCCurServerPkInfo();
			_testPacket.cur_step = TIMESTEP_MAIN_2;
			_testPacket.cur_state = TIMESTEP_SUB_1;
			_testPacket.no_1 = 25;
			_testPacket.no_2 = 0;
			
			_testPacket.arrItemman_list = new Vector.<StructServerPlayerPkInfo2>();
			
			_testPlayer = new StructServerPlayerPkInfo2();
			_testPlayer.no = 1;
			_testPlayer.level = 11;
			_testPlayer.fight_value = 42546;
			_testPlayer.name = "T1";
			_testPacket.arrItemman_list.push(_testPlayer);
			
			_testPlayer = new StructServerPlayerPkInfo2();
			_testPlayer.no = 2;
			_testPlayer.level = 22;
			_testPlayer.fight_value = 42546;
			_testPlayer.name = "T2";
			_testPacket.arrItemman_list.push(_testPlayer);
			
			_testPlayer = new StructServerPlayerPkInfo2();
			_testPlayer.no = 3;
			_testPlayer.level = 40;
			_testPlayer.fight_value = 42546;
			_testPlayer.name = "T3";
			_testPacket.arrItemman_list.push(_testPlayer);
			
			_testPlayer = new StructServerPlayerPkInfo2();
			_testPlayer.no = 4;
			_testPlayer.level = 13;
			_testPlayer.fight_value = 42546;
			_testPlayer.name = "T4";
			_testPacket.arrItemman_list.push(_testPlayer);
			
			_testPlayer = new StructServerPlayerPkInfo2();
			_testPlayer.no = 5;
			_testPlayer.level = 12;
			_testPlayer.fight_value = 42546;
			_testPlayer.name = Data.myKing.name;
			_testPlayer.userid = Data.myKing.roleID;
			_testPacket.arrItemman_list.push(_testPlayer);
			
			_testPlayer = new StructServerPlayerPkInfo2();
			_testPlayer.no = 6;
			_testPlayer.level = 11;
			_testPlayer.fight_value = 42546;
			_testPlayer.name = "T6"
			_testPacket.arrItemman_list.push(_testPlayer);
			
			_responsePacketWCCurServerPkInfo(_testPacket);
			
			*/
		}
		
		
		private function _responsePacketWCCurServerPkInfo(p:IPacket):void
		{
			var _p:PacketWCCurServerPkInfo = p as PacketWCCurServerPkInfo;
			m_myWinNode = null;
			//每个阶段的比赛胜利数据
			m_hasMatch_1 = _p.no_1;       //第一场 争夺16强  胜利者数据
			m_hasMatch_2 = _p.no_2;       //第二场 争夺8强     胜利者数据
			m_hasMatch_3 = _p.no_3;       //第三场 争夺4强     胜利者数据
			m_hasMatch_4 = _p.no_4;       //第四场 半决赛       胜利者数据
			m_hasMatch_5 = _p.no_5;       //第五场 决赛           胜利者数据
			
			//当前比赛 主要  阶段
			m_timestep_main = _p.cur_step;
			
			//当前比赛 子 阶段
			m_timestep_sub = _p.cur_state;
			
			//当前第几届
			m_cur_no = _p.cur_no;
			
			//建立数据索引
			_constructDataIndex(_p.arrItemman_list);

			//向应用交互层发送消息
			var _e:XDHEvent =  null;
			_e = new XDHEvent(XDHEvent.XDH_EVENT);
			dispatchEvent(_e);
		}
		
		private function _constructDataIndex(list:Vector.<StructServerPlayerPkInfo2>):void
		{
			var _length:int = list.length;
			
			
			for(var i:int = 0; i < _length ; ++i)
			{
				_findByOneNode(list[i] as StructServerPlayerPkInfo2);
			}
		}
		
		private function _findByOneNode(player:StructServerPlayerPkInfo2):void
		{
			var _nodeIndex:int = 0;
			var _node:XDHStructNode = null;
			var _win:int;
			var _winLorR:int;
			
			//32强
			_nodeIndex = Math.pow(2,5) - 1 + int((player.no - 1)/1);
			_node = m_nodes_all[_nodeIndex];
			_node.winner = player;
			var _myUserID:int = Data.myKing.roleID;
			if(_myUserID == player.userid)
			{
				m_myWinNode = _node;
			}
			
			//16强
			_winLorR = (_nodeIndex - 1)%2;
			_nodeIndex = Math.pow(2,4) - 1 + int((player.no - 1)/2);
			_node = m_nodes_all[_nodeIndex];
			_win = BitUtil.getOneToOne(m_hasMatch_1,player.no,player.no);
			if(0 == _win)
			{
				return ;
			}
			_node.winner = player;
			_node.winLorR = _winLorR;
			if(_myUserID == player.userid)
			{
				m_myWinNode = _node;
			}
			
			//8强
			_winLorR = (_nodeIndex - 1)%2;
			_nodeIndex = Math.pow(2,3) - 1 + int((player.no - 1)/4);
			_node = m_nodes_all[_nodeIndex];
			_win = BitUtil.getOneToOne(m_hasMatch_2,player.no,player.no);
			if(0 == _win)
			{
				return ;
			}
			_node.winner = player;
			_node.winLorR = _winLorR;
			if(_myUserID == player.userid)
			{
				m_myWinNode = _node;
			}
			
			//4强
			_winLorR = (_nodeIndex - 1)%2;
			_nodeIndex = Math.pow(2,2) - 1 + int((player.no - 1)/8);
			_node = m_nodes_all[_nodeIndex];
			_win = BitUtil.getOneToOne(m_hasMatch_3,player.no,player.no);
			if(0 == _win)
			{
				return ;
			}
			_node.winner = player;
			_node.winLorR = _winLorR;
			if(_myUserID == player.userid)
			{
				m_myWinNode = _node;
			}
			
			//半决赛
			_winLorR = (_nodeIndex - 1)%2;
			_nodeIndex = Math.pow(2,1) - 1 + int((player.no - 1)/16);
			_node = m_nodes_all[_nodeIndex];
			_win = BitUtil.getOneToOne(m_hasMatch_4,player.no,player.no);
			if(0 == _win)
			{
				return ;
			}
			_node.winner = player;
			_node.winLorR = _winLorR;
			if(_myUserID == player.userid)
			{
				m_myWinNode = _node;
			}
			
			//决赛
			_winLorR = (_nodeIndex - 1)%2;
			_nodeIndex = 0;
			_node = m_nodes_all[_nodeIndex];
			_win = BitUtil.getOneToOne(m_hasMatch_5,player.no,player.no);
			if(0 == _win)
			{
				return ;
			}
			_node.winner = player;
			_node.winLorR = _winLorR;
			if(_myUserID == player.userid)
			{
				m_myWinNode = _node;
			}

		}

		public function requestPacketCSServerPKCamble(no:int):void
		{
			var cs:PacketCSServerPKCamble = new PacketCSServerPKCamble();
			cs.no = no;
			DataKey.instance.send(cs);	
		}
		
		private function _responsePacketSCServerPKCamble(p:IPacket):void
		{
			var _p:PacketSCServerPKCamble = p as PacketSCServerPKCamble;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
			
			//向应用交互层发送消息
			var _e:XDHEvent =  null;
			_e = new XDHEvent(XDHEvent.XDH_EVENT);
			_e.sort = XDHEvent.XDH_EVENT_SORT_ZHICHI;
			dispatchEvent(_e);
		}
		
		/**
		 * 向服务器请求该玩家是否押注了 
		 * @param no
		 * 
		 */		
		public function requestCSGetServerPKCamble(no:int):void
		{
			var cs:PacketCSGetServerPKCamble = new PacketCSGetServerPKCamble();
			cs.no = no;
			cs.step = m_timestep_main;
			DataKey.instance.send(cs);	
		}
		
		private function _responseSCGetServerPKCamble(p:IPacket):void
		{
			var _p:PacketSCGetServerPKCamble = p as PacketSCGetServerPKCamble;
			
			var _e:XDHEvent =  null;
			_e = new XDHEvent(XDHEvent.XDH_EVENT);
			_e.sort = XDHEvent.XDH_EVENT_SORT_YAZHU;
			_e.data = _p;
			dispatchEvent(_e);
		}
		
		/**
		 * 战报,获得玩家比赛结果返回
		 */ 
		public function requestPKResult(no:int,step:int):void
		{
			
			var cs:PacketCSGetServerPKResult = new PacketCSGetServerPKResult();

			cs.no  = no;
			cs.step = step;
			
			DataKey.instance.send(cs);
			
		}
		
		/**
		 * 战报,获得玩家比赛结果
		 */ 
		public var PKResult2:PacketSCGetServerPKResult2;
		
		private function _responsePKResult(p:PacketSCGetServerPKResult2):void
		{
			PKResult2 = p;
			
			var _e:XDHEvent = new XDHEvent(XDHEvent.XDH_EVENT);
			
			_e.sort = XDHEvent.XDH_EVENT_SORT_PK_RESULT;
			
			this.dispatchEvent(_e);
			
		}		
		
				
		/**
		 * 获得玩家身价信息
		 */ 
		public function requestPKCost():void
		{
			
			var cs:PacketCSGetServerPKCost = new PacketCSGetServerPKCost();
			
			DataKey.instance.send(cs);	
			
		
		}
		
		/**
		 * 玩家身价信息
		 */ 
		public var PKCost2:PacketSCGetServerPKCost2;
		
		private function _responsePKCost(p:PacketSCGetServerPKCost2):void
		{
			PKCost2 = p;
			
			var _e:XDHEvent = new XDHEvent(XDHEvent.XDH_EVENT);
			
			_e.sort = XDHEvent.XDH_EVENT_SORT_PK_COST;
			
			this.dispatchEvent(_e);
		}
		
		/**
		 * 获得玩家所有押注信息返回
		 * 
		 */ 
		public function requestPKAllGamble():void
		{
			var cs:PacketCSGetServerPKAllGamble = new PacketCSGetServerPKAllGamble();
			
			DataKey.instance.send(cs);	
		}
		
		/**
		 * 支持列表,玩家所有押注信息
		 */ 
		public var PKAllGamble2:PacketSCGetServerPKAllGamble2;
		
		private function _responsePKAllGamble(p:PacketSCGetServerPKAllGamble2):void
		{
			PKAllGamble2 = p;
			
			var _e:XDHEvent = new XDHEvent(XDHEvent.XDH_EVENT);
			
			_e.sort = XDHEvent.XDH_EVENT_SORT_PK_ALL_GAMBLE;
			
			this.dispatchEvent(_e);
		}		
		
		/**
		 * 获得玩家战绩信息
		 */ 
		public function requestPKSelfInfo():void
		{
			
			var cs:PacketCSGetServerPKSelfInfo = new PacketCSGetServerPKSelfInfo();
			
			DataKey.instance.send(cs);	
		
		}
		
		/**
		 * 玩家战绩信息
		 */ 
		public var PKSelfInfo2:PacketSCGetServerPKSelfInfo2;
		
		private function _responsePKSelfInfo(p:PacketSCGetServerPKSelfInfo2):void
		{
			PKSelfInfo2 = p;
			
			var _e:XDHEvent = new XDHEvent(XDHEvent.XDH_EVENT);
			
			_e.sort = XDHEvent.XDH_EVENT_SORT_PK_SELF_INFO;
			
			this.dispatchEvent(_e);
		}	
		
		
		
		
		
		// --------------------------   网络协议处理  结束  -----------------------

		
	}
	
	
}



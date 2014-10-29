package model.guest
{
	
	import common.config.GameIni;
	import common.utils.bit.BitUtil;
	
	import engine.support.IPacket;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketCSNewStepSet2;
	import netc.packets2.PacketSCNewStepGetRet2;
	import netc.packets2.StructNewStepInfo2;
	
	import nets.packets.PacketCSNewStepGet;
	import nets.packets.PacketSCNewStepGetRet;
	import nets.packets.PacketSCNewStepSetRet;
	
	import ui.base.huodong.HuoDong;
	import ui.base.huodong.HuoDongEventDispatcher;
	
	import world.WorldEvent;
	
	/**
	 * 新手引导模块
	 * @author steven guo
	 * 
	 */	
	public class NewGuestModel
	{
		private static const MAX_GUEST_START:int = 1000;
		private static const MAX_GUEST_END:int = 1127;
		/**
		 * 处理函数集对象 
		 */		
		private var m_handler:NewGuestHandlers;
		
		/**
		 * 单例变量 
		 */		
		private static var instance:NewGuestModel;

		/**
		 * 新手引导列表 
		 */		
		private var m_guestList:Array = []; 
		
		/**
		 * 当前新手引导 id
		 */		
		private var m_currentId:int;
		
		/**
		 * 当前新手引导 步骤 
		 */		
		private var m_currentStep:int;
		
		
		public function NewGuestModel()
		{
			m_handler = new NewGuestHandlers();
			//从服务器获得新手引导进度值
			DataKey.instance.register(PacketSCNewStepGetRet.id,_responseSCNewStepGetRet);
			//向服务器写入新手引导进度值后服务器返回是否保存成功
			DataKey.instance.register(PacketSCNewStepSetRet.id,_responseSCNewStepSetRet);
			
			_initGuestList(m_guestList);
		}
		public static function getInstance():NewGuestModel
		{
			if(null == instance)
			{
				instance = new NewGuestModel();
			}
			
			return instance;
		}
		private function _initGuestList(list:Array):void
		{
			// [0 ,  0 , 0  , 0]  
			//第一位：引导编号    
			//第二位：引导步骤    
			//第三位：表示是否已经完成 (1表示完成  0 表示未完成)
			//第四位：表示该引导是否已经发起了 (1表示发起  0 表示未发起)
			for(var i:int = MAX_GUEST_START; i<=MAX_GUEST_END ; ++i)
			{
				m_guestList[i] = [i,0,0,0];
			}
		}
		
		/**
		 * 向服务器请求新手引导数据 
		 * 
		 */		
		public function requestCSNewStepGet():void
		{
			var _p:PacketCSNewStepGet = new PacketCSNewStepGet();
			DataKey.instance.send(_p);
		}

		/**
		 * 服务器返回新手引导数据 
		 * @param p
		 * 
		 */		
		private function _responseSCNewStepGetRet(p:IPacket):void
		{
			
			var _p:PacketSCNewStepGetRet2 = p as PacketSCNewStepGetRet2;
			
			var _data:StructNewStepInfo2 = _p.data;
			
			
			_decodeList(_data.data1,m_guestList,1000,1031);
			_decodeList(_data.data2,m_guestList,1032,1063);
			_decodeList(_data.data3,m_guestList,1064,1095);
			
			//新手指南界面       (境界  ，星魂，魔纹，升级，重铸 ，强化 ，底板 )
			_decodeList(_data.data4,m_guestList,1096,1127);
			
			
		}
		
		private function _decodeList( data:int , list:Array , star:int , end:int ):void
		{
			var _index:int;
			for(var i:int = star; i<= end ; ++i )
			{
				_index = i - 1000;
				_index = (_index+1) % 32;
				if(_index <= 0)
				{
					_index = 32;
				}
				
				list[i][2] = BitUtil.getOneToOne(data , _index , _index);
			}
		}
		
		/**
		 * 向服务器保存新手引导数据 
		 * 
		 */		
		public function requestCSNewStepSetRet():void
		{
			var _p:PacketCSNewStepSet2 = new PacketCSNewStepSet2();
			
			_p.data.data1 = _codeSpecList(m_guestList , 1000 , 1031 );
			_p.data.data2 = _codeSpecList(m_guestList , 1032 , 1063 );
			_p.data.data3 = _codeSpecList(m_guestList , 1064 , 1095 );
			_p.data.data4 = _codeSpecList(m_guestList , 1096 , 1127 );

			DataKey.instance.send(_p);
		}
		
		private function _codeSpecList(list:Array , star:int , end:int ):int
		{
			var _ret:int = 0;
			
			var _index:int = 0;
			
			for(var i:int = star ; i<=end ; ++i)
			{
				_index = i - 1000;
				_index = (_index+1) % 32;
				if(_index <= 0)
				{
					_index = 32;
				}
				
				if(1 == list[i][3]) //如果该引导已经触发，向服务器保存的时候直接保存为已经引导过了。
				{
					_ret = BitUtil.setIntToInt(1,_ret,_index,_index);
					
				}
				else
				{
					//按照实际情况保存
					_ret = BitUtil.setIntToInt(list[i][2],_ret,_index,_index);
					

				}
				
			}
			
			return _ret;
		}
		
		/**
		 * 服务器返回保存引导数据是否成功 
		 * @param p
		 * 
		 */		
		private function _responseSCNewStepSetRet(p:IPacket):void
		{

		}

		/**
		 * NPC 引导  
		 * @param object     
		 * @param open         true 开启 ， false 关闭
		 * 
		 */		
		public function handleNPCGuestEvent(object:Object,open:Boolean):void
		{
			m_handler.handleNPCGuestEvent(object,open);
		}
		
		
		/**
		 * 重复性的引导 
		 * @param eventID
		 * @param eventStepID
		 * @param object
		 * 
		 */		
		public function handleGuestEvent(eventID:int,eventStepID:int,object:Object):void
		{
			_doHandleFunctionComm(eventID,eventStepID,object);
		}
		
		private function _doHandleFunctionComm( eventID:int ,eventStepID:int ,object:Object):void
		{
			switch(eventID)
			{
				case 2001:
					m_handler.handle2001(eventStepID,object);
					break;
				default:
					break;
			}
		}
			
		
		/**
		 * 保存新手引导的进度。   一旦一个引导开始了，就保存到数据库  
		 * @param eventID             新手引导的id 
		 * @param eventStepID         该引导的步骤 
		 * @param object
		 * 
		 */		
		public function handleNewGuestEvent(eventID:int,eventStepID:int,object:Object):void
		{
			if(eventStepID == -1)
			{
				m_handler.removeTips();
			}
			
			if(eventID < MAX_GUEST_START || eventID > MAX_GUEST_END)
			{
				return ;
			}
		
			if( 1 == m_guestList[eventID][2])
			{
				if(GameIni.urlval!=null){
					//表示已经做过了，直接跳过
					buChongShiJian(eventID,eventStepID)
					return ;
				}else{	
					//测试时用
					if(m_currentId==1005)
					m_guestList[eventID][2]=0;
				}
			}
			
			if( -1 == eventStepID)
			{
				if(m_currentId == eventID)
				{
					m_guestList[eventID][2] = 1;
					m_currentId = 0;
					m_currentStep = 0;
					
					requestCSNewStepSetRet();
				}

				return ;
			}
			
			
			//新的一个引导来了，覆盖旧的
			if(0 == eventStepID)
			{
				if(eventID != m_currentId)
				{
					if(null != m_guestList[m_currentId])
					{
						m_guestList[m_currentId][2] = 1; //直接覆盖表示已经完成
					}					
					m_currentId = eventID;
					m_currentStep = eventStepID;
				}
				else
				{
					buChongShiJian(eventID,eventStepID)
					return ;
				}
				requestCSNewStepSetRet();
			}
			else
			{
				if(eventID != m_currentId || 1 != (eventStepID - m_currentStep))
				{
					buChongShiJian(eventID,eventStepID);
					return ;
				}
				else
				{
					buChongShiJian(eventID,eventStepID);
					m_currentStep = eventStepID;
					m_currentId = eventID;
					m_guestList[eventID][1] = eventStepID;

					requestCSNewStepSetRet();
				}
			}
			
			m_guestList[eventID][3] = 1;
			requestCSNewStepSetRet();
			
			_doHandleFunction(eventID,eventStepID,object);
		}
		private function buChongShiJian(eventID:int,eventStepID:int):void
		{
				if(eventID==1015&&eventStepID==0)
				{///////boss界面
					if (!HuoDong.instance().isOpen)
					{
						HuoDongEventDispatcher.getInstance().openHuoDongWindow();
					}else
					{
						HuoDong.instance().winClose();
					}
				}
		}
		
		private function _doHandleFunction( eventID:int ,eventStepID:int ,object:Object):void
		{
			
			switch(eventID)
			{
				case 1000:
					break;
				case 1001:  //引导结束  , 角色升到25级
					m_handler.handle1001(eventStepID,object);
					break;
				case 1002:
					m_handler.handle1002(eventStepID,object);
					break;
				case 1003:  //引导人物穿装备
					m_handler.handle1003(eventStepID,object);
					break;
				case 1004:  //第一次进入魔天万界
					m_handler.handle1004(eventStepID,object);
					break;
				case 1005:
					m_handler.handle1005(eventStepID,object);
					break;
				case 1006:
					m_handler.handle1006(eventStepID,object);
					break;
				case 1007:
					m_handler.handle1007(eventStepID,object);
					break;
				case 1008:
					m_handler.handle1008(eventStepID,object);
					break;
				case 1009:
					m_handler.handle1009(eventStepID,object);
					break;
				case 1010:
					m_handler.handle1010(eventStepID,object);
					break;
				case 1011:
					m_handler.handle1011(eventStepID,object);
					break;
				case 1012:
					m_handler.handle1012(eventStepID,object);
					break;
				case 1013:
					m_handler.handle1013(eventStepID,object);
					break;
				case 1014:   //人物礼包使用引导
					m_handler.handle1014(eventStepID,object);
					break;
				case 1015:
					m_handler.handle1015(eventStepID,object);
					break;
				case 1016:
					m_handler.handle1016(eventStepID,object);
					break;
				case 1017: 
					m_handler.handle1017(eventStepID,object);
					break;
				case 1018:
					m_handler.handle1018(eventStepID,object);
					break;
				case 1019:  //丹药引导
					m_handler.handle1019(eventStepID,object);
					break;
				case 1020:  //引导给伙伴穿装备
					m_handler.handle1020(eventStepID,object);
					break;
				case 1021:  //(十七)	魔纹新手引导
					m_handler.handle1021(eventStepID,object);
					break;
				case 1022:  //人物礼包使用引导
					m_handler.handle1022(eventStepID,object);
					break;
				case 1023:
					m_handler.handle1023(eventStepID,object);
					break;
				case 1024:
					//伙伴出战
					
					break;
				case 1025:
					//伙伴复活
					
					break;
				case 1026:   // 隐藏玩家引导  1   (必须在  20100001  地图出现);
					m_handler.handle1026(eventStepID,object);
					break;
				case 1027:   // 隐藏玩家引导  2   (必须在  20100002  地图出现);
					m_handler.handle1027(eventStepID,object);
					break;
				case 1028:   // 隐藏玩家引导  3   (必须在  20100003  地图出现);
					m_handler.handle1028(eventStepID,object);
					break;
				case 1029:   // 隐藏玩家引导  4   (必须在  20100004  地图出现);
					m_handler.handle1029(eventStepID,object);
					break;
				case 1030:   // 引导玩家选择游戏品质
					m_handler.handle1030(eventStepID,object);
					break;
				case 1031:   // 完成罪魁祸首【50100017】任务时，判断游戏画质是否为高清模式。
					m_handler.handle1031(eventStepID,object);
					break;
				case 1032:   // 引导第一个被动技能  ，当玩家第一次获得被动技能的时候引导
					m_handler.handle1032(eventStepID,object);
					break;
				case 1033:   // 第一次  装备升级引导
					m_handler.handle1033(eventStepID,object);
					break;
				case 1034:   // 全屏模式引导
					m_handler.handle1034(eventStepID,object);
					break;
				case　1035:  // 好友
					m_handler.handle1035(eventStepID,object);
					break;
				case　1036:  // 买药品
					m_handler.handle1036(eventStepID,object);
					break;
				case　1037:  // 买饰品
					m_handler.handle1037(eventStepID,object);
					break;
				case　1038:  // {传}
					m_handler.handle1038(eventStepID,object);
					break;
				case 1040:   // 副本引导
					m_handler.handle1040(eventStepID,object);
					break;
				case 1041:   // 星魂引导(完成星魂任务(ID:50200089)时)
					m_handler.handle1041(eventStepID,object);
					break;
				case 1042:   //伙伴穿装备
					m_handler.handle1042(eventStepID,object);
					break;
				case 1043:   // 第二次 装备升级引导
					m_handler.handle1043(eventStepID,object);
					break;
				case 1044:   // 购买 20级装备卷轴 引导
					m_handler.handle1044(eventStepID,object);
					break;
				case 1045:   //银两兑换
					m_handler.handle1045(eventStepID,object);
					break;
				case 1046:   //装备强化引导
					m_handler.handle1046(eventStepID,object);
					break;
				case 1047:   //装备强化引导
					m_handler.handle1047(eventStepID,object);
					break;
				case 1048:   //装备强化引导
					m_handler.handle1048(eventStepID,object);
					break;
				case 1049:   //阵法技能学习引导
					m_handler.handle1049(eventStepID,object);
					break;
				case 1050:   //家族功能开启引导
					m_handler.handle1050(eventStepID,object);
					break;
				case　1051:  // {传}
					m_handler.handle1051(eventStepID,object);
					break;
				case　1052:  // {传}
					m_handler.handle1052(eventStepID,object);
					break;
				case　1053:  // {传}
					m_handler.handle1053(eventStepID,object);
					break;
				case　1054:  // {传}
					m_handler.handle1054(eventStepID,object);
					break;
				case　1055:  // {传}
					m_handler.handle1055(eventStepID,object);
					break;
				case　1056:  // {传}
					m_handler.handle1056(eventStepID,object);
					break;
				case　1057:  // {传}
					m_handler.handle1057(eventStepID,object);
					break;
				case 1058:  // 魔天万界主UI引导
					m_handler.handle1058(eventStepID,object);
					break;
				case 1059:  // 魔天万界 成功或者失败引导
					m_handler.handle1059(eventStepID,object);
					break;
				case 1060:  
					//伙伴合体 2012-11-17
					m_handler.handle1060(eventStepID,object);
					break;
				// 新手UI指引
				//case 1096:   // 境界 
				//case 1097:   // 星魂
				//case 1098:   // 魔纹
				//case 1099:   // 升级
				//case 1100:   // 重铸
				//case 1101:   // 强化
				//	m_handler.handleNewUI(eventID);
				//	break;
				case 1062:  //开启 龙脉(经脉) 引导
					m_handler.handle1062(eventStepID,object);
					break;
				case 1063:  //开启 龙脉(经脉) 引导
					m_handler.handle1063(eventStepID,object);
					break;
				case 1064:  //vip 引导
					m_handler.handle1064(eventStepID,object);
					break;
				case 1065:  //锻造官印 引导
					m_handler.handle1065(eventStepID,object);
					break;
				case 1066:  // 引导
					m_handler.handle1066(eventStepID,object);
					break;
				default:
					break;
			}
		}
		
//			m_commList[1000] = [0,0,1000];        //创建角色 引导
//			m_commList[1001] = [1,0,1001];        //首次登录游戏欢迎界面
//			m_commList[1002] = [2,0,1002];        //引导接受任务
//			m_commList[1003] = [3,0,1003];        //第一次穿装备
//			m_commList[1004] = [4,0,1004];        //第一次杀怪
//			m_commList[1005] = [5,0,1005];        //第一次强化装备
//			m_commList[1006] = [6,0,1006];        //第一次选择技能
//			m_commList[1007] = [7,0,1007];        //第一次拾取物品
//			m_commList[1008] = [8,0,1008];        //第一次切换地图
//			m_commList[1009] = [9,0,1009];        //第一次看剧情动画
//			m_commList[1010] = [10,0,1010];       //第一次有伙伴(完成太乙红英50100046任务后)
//			m_commList[1011] = [11,0,1011];       //第一次炼骨(完成龙骨仙草50100032任务后，自动弹出炼骨界面)
//			//m_commList[1012] = [12,0,1012];       //第一次完成伙伴任务(花似非花50400024)
//			m_commList[1013] = [13,0,1013];       //第一次有坐骑
//			m_commList[1015] = [15,0,1015];       //第一次给装备重铸
//			m_commList[1016] = [16,0,1016];       //第一次玩星魂
//			m_commList[1017] = [17,0,1017];       //招募第二个伙伴
//			m_commList[1018] = [18,0,1018];       //第一次炼丹
//			m_commList[1019] = [19,0,1019];       //第一次吃丹药
//			m_commList[1020] = [20,0,1020];       //第一次玩魔天万界
//			m_commList[1021] = [21,0,1021];       //第一次合成魔纹
//			m_commList[1022] = [22,0,1022];       //第一次在装备上封印魔纹
//			m_commList[1023] = [23,0,1023];       //选择门派
//			
		
		
		
		
		//新手UI指引   (境界  ，星魂，魔纹，升级，重铸 ，强化 ，底板)
		//       //选择门派
//			
		/**
		 *	得到重铸指引的装备id 
		 * 	//11301407	破军剑 
			//11301408	御灵杖
			//11301409	射影弓
		 */
		public function getChongZhuItemId():int{
			var ret:int=0;
			switch(Data.myKing.metier){
				case 1:ret=11301407;break;
				case 2:ret=11301408;break;
				case 3:ret=11301409;break;
				default :break;
			}
			return ret;
		}
		
		/**
		 *	显示自动开启战斗 美女 
		 *  2012-11-01
		 */
		public function showGuideGirl():void{
//			m_handler.showGuideGirl();
		}
		
	}
	
	
	
}




















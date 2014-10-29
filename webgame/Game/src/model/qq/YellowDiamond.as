package model.qq
{

	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.lib.TablesLib;
	import common.config.xmlres.server.Pub_YellowResModel;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSActGetQQYellowPet;
	import nets.packets.PacketCSExchangeCDKey;
	import nets.packets.PacketCSQQYellowGift;
	import nets.packets.PacketCSQQYellowLevelGift;
	import nets.packets.PacketCSQQYellowLevelGiftState;
	import nets.packets.PacketSCActGetQQYellowPet;
	import nets.packets.PacketSCExchangeCDKey;
	import nets.packets.PacketSCQQYellowGift;
	import nets.packets.PacketSCQQYellowLevelGift;
	import nets.packets.PacketSCQQYellowLevelGiftState;
	
	import ui.view.view2.other.ControlButton;
	
	


	/**
	 * QQ 黄钻活动模块
	 * @author steven guo
	 *
	 */
	public class YellowDiamond extends EventDispatcher
	{
		private static var m_instance:YellowDiamond;
		
		//玩家自己的 黄钻，蓝钻信息
		private var m_qqyellowvip:int=0;
		
		public static const QQ_YELLOW_PET_ID:int=30200012;
		
		//非黄钻用户
		public static const QQ_YELLOW_NULL:int=0;
		
		//黄钻普通用户
		public static const QQ_YELLOW_COMMON:int=1;
		
		//黄钻年费用户
		public static const QQ_YELLOW_YEAR:int=2;
		
		//当前玩家的QQ黄钻类型
		private var m_qqYellowType:int=YellowDiamond.QQ_YELLOW_NULL;
		
		
		
		//当前玩家黄钻等级
		private var m_qqYellowLevel:int=1;
		
		//当前玩家 3366 包子等级
		private var m_3366Level:int=1;
		
		//当前玩家 3366 包子真正的等级
		private var m_3366RealLevel:int=1;
		
		//是否是从本游戏引导充值黄钻
		private var m_qqYellowVIP_FromGame:Boolean;
		
		//黄钻(蓝钻)新手礼包是否领取 (其中 0表示没有领取，1表示已经领取)
		private var m_giftsNew:int=1;
		
		//黄钻(蓝钻)普通礼包是否领取 (其中 0表示没有领取，1表示已经领取)
		private var m_giftsCommon:int=1;
		
		//黄钻(蓝钻)年费礼包是否领取 (其中 0表示没有领取，1表示已经领取)
		private var m_giftsYear:int=1;
		
		//黄钻(蓝钻)贵族礼包是否领取 (其中 0表示没有领取，1表示已经领取)
		private var m_giftsMost:int=1;
		
		//3366 每日登录礼包
		private var m_gifts3366:int=1;
		
		//新手礼包列表配置
		private var m_configGiftsNewList:Array=null;
		
		//每日礼包列表配置(包括普通和年费)
		private var m_configGiftsList:Array=null;
		
		//升级礼包列表配置
		private var m_configGiftsLevelList:Array=null;
		
		//升级礼包列表配置 按照 show_index 字段索引
		private var m_configGiftsLevelListByShowIndex:Array=null;
		
		//最大的 升级礼包 show_index 字段索引
		private var m_maxShow_index:int=0;
		
		
		
		/**
		 *	蓝钻测试数据
		 *  andy 2013-04-26
		 */
		public static const BAOZI:int=1048611;
		public static const BAOZI_BLUE:int=330015;
		public static const BAOZI_BLUE_MOST:int=362783;
		public static const BAOZI_BLUE_YEAR:int=199435;
		
		/**
		 *	黄钻测试数据
		 *  andy 2014-02-13
		 */
		public static const TEST_Yellow_COMMON:int=13;
		public static const TEST_Yellow_YREAR:int=15;

		
		
		public function YellowDiamond(target:IEventDispatcher=null)
		{
			super(target);
			DataKey.instance.register(PacketSCQQYellowLevelGiftState.id, _responseSCQQYellowLevelGiftState);
			DataKey.instance.register(PacketSCQQYellowLevelGift.id, _responseSCQQYellowLevelGift);
			DataKey.instance.register(PacketSCQQYellowGift.id, _responseSCQQYellowGift);
			
			DataKey.instance.register(PacketSCExchangeCDKey.id, _responseSCExchangeCDKey);
			DataKey.instance.register(PacketSCActGetQQYellowPet.id, _responseSCActGetQQYellowPet);
			
		
			
			//清凉一夏协议监听
			//DataKey.instance.register(PacketSCActGetQQYellowSummer.id, _responseSCActGetQQYellowSummer);
			//DataKey.instance.register(PacketSCActGetQQYellowSummerData.id, _responseSCActGetQQYellowSummerData);
			//DataKey.instance.register(PacketSCActGetQQYellowSummerPrize.id, _responseSCActGetQQYellowSummerPrize);
			
			_initConfig();
			
//			requestCSActGetQQYellowCD();
			
			reqeustCSActGetQQYellowSummer();
			
			//ControlButton.getInstance().setVisible('arrQingLiang', true, true);    
		}
		
		/**
		 * 初始化黄钻礼包的配置文件
		 *
		 */
		private function _initConfig():void
		{
			if (null != m_configGiftsNewList && null != m_configGiftsList && null != m_configGiftsLevelList && null != m_configGiftsLevelListByShowIndex)
			{
				return;
			}
			
			var _index_giftsNew:int=1;
			var _index_gifts:int=1;
			var _index_giftsLevel:int=1;
			
			m_configGiftsNewList=[];
			m_configGiftsList=[];
			m_configGiftsLevelList=[];
			m_configGiftsLevelListByShowIndex=[];
			
			var _config:TablesLib=XmlManager.localres.QQYellowXml;
			var _YellowResModel:Pub_YellowResModel=null;
			var _id:int=1;
			
			
			
			do
			{
				_YellowResModel=_config.getResPath(_id) as Pub_YellowResModel;
				++_id;
				
				if (null != _YellowResModel)
				{
					switch (_YellowResModel.sort)
					{
						case 1: //新手礼包
							m_configGiftsNewList[_index_giftsNew]=_YellowResModel;
							++_index_giftsNew;
							break;
						case 2: //每日礼包
							m_configGiftsList[_index_gifts]=_YellowResModel;
							++_index_gifts;
							break;
						case 3: //等级礼包
							m_configGiftsLevelList[_index_giftsLevel]=_YellowResModel;
							m_configGiftsLevelListByShowIndex[_YellowResModel.show_index]=[_YellowResModel, 1];
							if (m_maxShow_index < _YellowResModel.show_index)
							{
								m_maxShow_index=_YellowResModel.show_index;
							}
							++_index_giftsLevel;
							break;
						default:
							break;
					}
				}
			} while (null != _YellowResModel);
			
			
		}
		
		
		public static function getInstance():YellowDiamond
		{
			if (null == m_instance)
			{
				m_instance=new YellowDiamond();
			}
			
			return m_instance;
		}
		
		/**
		 * 设置礼包领取状态
		 * //QQ黄钻礼包数据  ,字段位数说明 (其中 0表示没有领取，1表示已经领取)
		 * //PSF_QQYELLOW_NEWER = 9,         //QQ黄钻新手礼包
		 * //PSF_QQYELLOW_LOGIN_NORMAL = 10, //QQ黄钻每日登录礼包
		 * //PSF_QQYELLOW_LOGIN_YEAR = 11,   //QQ年费黄钻每日登录礼包
		 * //PSF_QQBLUE_NEWER = 15,//QQ蓝钻新手礼包
		 * //PSF_QQBLUE_LOGIN_NORMAL = 16,//QQ蓝钻每日登录礼包
		 * //PSF_QQBLUE_LOGIN_YEAR = 17,//QQ年费蓝钻每日登录礼包
		 * //PSF_QQ_3366_LOGIN = 18,//QQ 3366每日登录礼包
		 * //PSF_QQBLUE_LOGIN_MOST = 22,//QQ豪华蓝钻每日登录礼包
		 * @param specialFlag
		 *
		 */
		public function setQQYellowStatus(specialFlag:int):void
		{
			var _arr:Array=handleQQYellowStatus(specialFlag);
			
			//新手礼包
			if (m_giftsNew != _arr[0])
			{
				m_giftsNew=_arr[0];
			}
			
			//每日登录礼包
			if (m_giftsCommon != _arr[1])
			{
				m_giftsCommon=_arr[1];
			}
			
			//年费每日登录礼包
			if (m_giftsYear != _arr[2])
			{
				m_giftsYear=_arr[2];
			}
			
			//3366每日登录礼包
			if (m_gifts3366 != _arr[3])
			{
				//m_gifts3366 = _arr[3];
				_set3366Gifts(_arr[3]);
			}
			
			//贵族每日登录礼包
			if (m_giftsMost != _arr[4])
			{
				m_giftsMost=_arr[4];
			}
			
			
		}
		
		//黄钻宠物是否已经领取 0 表示未领取，1 表示领取
		private var m_yellowPet:int = 0;
		public function setYellowPet(has:int):void
		{
			m_yellowPet = has;
			
			var _e:YellowDiamondEvent=null;
			_e=new YellowDiamondEvent(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT);
			dispatchEvent(_e);
		}
		
		public function getYellowPet():int
		{
			return m_yellowPet;
		}
		
		//是否还有未领取的礼包
		public function hasGift():Boolean
		{
//			//黄钻(蓝钻)新手礼包是否领取 (其中 0表示没有领取，1表示已经领取)
//			private var m_giftsNew:int=1;
//			
//			//黄钻(蓝钻)普通礼包是否领取 (其中 0表示没有领取，1表示已经领取)
//			private var m_giftsCommon:int=1;
//			
//			//黄钻(蓝钻)年费礼包是否领取 (其中 0表示没有领取，1表示已经领取)
//			private var m_giftsYear:int=1;
//			
//			//黄钻(蓝钻)贵族礼包是否领取 (其中 0表示没有领取，1表示已经领取)
//			private var m_giftsMost:int=1;
			
			var _QQYellowType:int = this.getQQYellowType();
			if(YellowDiamond.QQ_YELLOW_NULL == _QQYellowType)
			{
				return false;
			}
			else if(YellowDiamond.QQ_YELLOW_COMMON == _QQYellowType)
			{
				if(1 == m_giftsCommon && 1 == m_giftsNew)
				{
					return false;
				}
			}
			else if(YellowDiamond.QQ_YELLOW_YEAR == _QQYellowType)
			{
				if(1 == m_giftsCommon && 1 == m_giftsYear && 1 == m_giftsNew)
				{
					return false;
				}
			}
			
			
			return true ;
		}
		
		
		/**
		 * 处理QQ VIP 信息
		 * @param specialFlag
		 * @return
		 *
		 */
		public function handleQQYellowStatus(specialFlag:int):Array
		{
			var _ret:Array=[];
			
			var _giftsNew:int=1;
			var _giftsCommon:int=1;
			var _giftsYear:int=1;
			var _gifts3366:int=1;
			var _giftsMost:int=1; // 豪华
			
			if (GameIni.PF_3366 == GameIni.pf())
			{
				_giftsNew=BitUtil.getOneToOne(specialFlag, 16, 16);
				_giftsCommon=BitUtil.getOneToOne(specialFlag, 17, 17);
				_giftsYear=BitUtil.getOneToOne(specialFlag, 18, 18);
				_gifts3366=BitUtil.getOneToOne(specialFlag, 19, 19);
				_giftsMost=BitUtil.getOneToOne(specialFlag, 23, 23);
			}
			else
			{
				_giftsNew=BitUtil.getOneToOne(specialFlag, 9, 9);
				_giftsCommon=BitUtil.getOneToOne(specialFlag, 10, 10);
				_giftsYear=BitUtil.getOneToOne(specialFlag, 11, 11);
				_gifts3366=BitUtil.getOneToOne(specialFlag, 19, 19);
				_giftsMost=BitUtil.getOneToOne(specialFlag, 23, 23);
			}
			_ret[0]=_giftsNew;
			_ret[1]=_giftsCommon;
			_ret[2]=_giftsYear;
			_ret[3]=_gifts3366;
			_ret[4]=_giftsMost;
			
			return _ret;
		}
		
		
		/**
		 * 处理黄钻图标
		 * @param specialFlag    后台发过来的黄钻数值数值
		 * @param qqDiamondMC    黄钻统一的黄钻图标MC
		 *
		 */
		public function showQQDiamondIcon(specialFlag:int, qqDiamondMC:MovieClip):void
		{
			if (null == qqDiamondMC)
			{
				return;
			}
			
			var _arr:Array=YellowDiamond.parseQQVIP(specialFlag);
			var _qqYellowType:int=_arr[0];
			var _qqYellowLevel:int=_arr[1];
			
			if (YellowDiamond.QQ_YELLOW_NULL == _qqYellowType)
			{
				qqDiamondMC.visible=false;
			}
			else if (YellowDiamond.QQ_YELLOW_COMMON)
			{
				qqDiamondMC.visible=true;
				qqDiamondMC.gotoAndStop(1);
				qqDiamondMC["mc_xiao_zuan"].gotoAndStop(_qqYellowLevel);
			}
			else if (YellowDiamond.QQ_YELLOW_YEAR)
			{
				qqDiamondMC.visible=true;
				qqDiamondMC.gotoAndStop(2);
				qqDiamondMC["mc_nian_zuan"].gotoAndStop(_qqYellowLevel);
			}
			
		}
		
//		public function requestCSActGetQQYellowCD():void
//		{
//			
//			return;
//			var _p:PacketCSActGetQQYellowCD=new PacketCSActGetQQYellowCD();
//			
//			DataKey.instance.send(_p);
//		}
		
		
		private var m_startTime:Date;
		private var m_endTime:Date;
		
		
		public function requestCSExchangeCDKey(key:String):void
		{
			if (null == key || "" == key)
			{
				return;
			}
			var _p:PacketCSExchangeCDKey=new PacketCSExchangeCDKey();
			_p.cdkey=key;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCExchangeCDKey(p:IPacket):void
		{
			var _p:PacketSCExchangeCDKey=p as PacketSCExchangeCDKey;
			
			if (0 != _p.tag)
			{
				Lang.showMsg(Lang.getServerMsg(_p.tag));
				return;
			}
		}
		
		
		/**
		 * 领取QQ黄钻礼包
		 * @param type  类型 1新手礼包 2:普通黄钻 3:年费黄钻 4:3366每日礼包 5: 豪华蓝钻礼包
		 *
		 */
		public function requestCSQQYellowGift(type:int):void
		{
			var _p:PacketCSQQYellowGift=new PacketCSQQYellowGift();
			_p.type=type;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCQQYellowGift(p:IPacket):void
		{
			var _p:PacketSCQQYellowGift=p as PacketSCQQYellowGift;
			
			if (0 != _p.tag)
			{
				Lang.showMsg(Lang.getServerMsg(_p.tag));
				return;
			}
			
			switch (_p.type)
			{
				case 1: //新手礼包
					m_giftsNew=1;
					break;
				case 2: //普通黄钻
					m_giftsCommon=1;
					break;
				case 3: //年费黄钻
					m_giftsYear=1;
					break;
				case 4: //3366每日登录礼包
					_set3366Gifts(1);
					//m_gifts3366 = 1;
					break;
				case 5: //贵族
					m_giftsMost=1;
					break;
				default:
					break;
			}
			
			var _e:YellowDiamondEvent=null;
			_e=new YellowDiamondEvent(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT);
			dispatchEvent(_e);
		}
		
		/**
		 * 向服务器领取QQ黄钻等级礼包
		 * @param index   第几个等级礼包
		 *
		 */
		public function requestCSQQYellowLevelGift(index:int):void
		{
			var _p:PacketCSQQYellowLevelGift=new PacketCSQQYellowLevelGift();
			_p.index=index;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCQQYellowLevelGift(p:IPacket):void
		{
			var _p:PacketSCQQYellowLevelGift=p as PacketSCQQYellowLevelGift;
			
			if (0 != _p.tag)
			{
				Lang.showMsg(Lang.getServerMsg(_p.tag));
				return;
			}
			
			var _index:int=_p.index;
			m_configGiftsLevelListByShowIndex[_index][1]=1;
			
			var _e:YellowDiamondEvent=null;
			_e=new YellowDiamondEvent(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT);
			dispatchEvent(_e);
		}
		
		/**
		 * 获取QQ黄钻等级礼包领取状态
		 * @param type
		 *
		 */
		public function requestCSQQYellowLevelGiftState():void
		{
			var _p:PacketCSQQYellowLevelGiftState=new PacketCSQQYellowLevelGiftState();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCQQYellowLevelGiftState(p:IPacket):void
		{
			var _p:PacketSCQQYellowLevelGiftState=p as PacketSCQQYellowLevelGiftState;
			var _status:int=_p.status;
			
			for (var i:int=1; i <= m_maxShow_index; ++i)
			{
				//更新等级礼包是否领取
				m_configGiftsLevelListByShowIndex[i][1]=BitUtil.getOneToOne(_status, i, i);
			}
			
			var _e:YellowDiamondEvent=null;
			_e=new YellowDiamondEvent(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT);
			dispatchEvent(_e);
			
			ControlButton.getInstance().checkYellow();
			
			
		}
		
		public function getQQYellowVIP():int
		{
			return this.m_qqyellowvip;
		}
		
		/**
		 * 设置当前玩家的QQ黄钻等级
		 * @param iData
		 * 第一位：  is_yellow_vip  是否为黄钻用户(0：不是； 1：是)
		 * 第二位：  is_yellow_year_vip  是否为年费黄钻用户(0：不是； 1：是)
		 * 第三 到  六位：  yellow_vip_level  黄钻等级。目前最高级别为黄钻8级(如果是黄钻用户才返回此字段)
		 *
		 *
		 */
		public function setQQYellowVIP(iData:int):void
		{
			m_qqyellowvip=iData;
			var _arr:Array=YellowDiamond.parseQQVIP(iData);
			m_qqYellowType=_arr[0];
			m_qqYellowLevel=_arr[1];
			m_3366Level=_arr[3];
			m_3366RealLevel=_arr[4];
			//表示该用户是不是 豪华用户
			var m_is_QQYellow_MOST:Boolean=_arr[5];
			
			if (m_qqYellowLevel <= 0)
			{
				m_qqYellowLevel=1;
			}
			else if (m_qqYellowLevel > 8)
			{
				m_qqYellowLevel=8;
			}
			
			if (m_3366Level <= 0)
			{
				m_3366Level=1;
			}
			
			if (_arr[2] <= 0)
			{
				m_qqYellowVIP_FromGame=false;
			}
			else
			{
				m_qqYellowVIP_FromGame=true;
			}
			
			
		}
		
		/**
		 * 处理关于QQ VIP 网络数据字段解析
		 *
		 *  //QQ用户信息 从高位到低位, 32位普通黄钻 31位年费黄钻 27-30位黄钻等级 26位是否从我们游戏成为黄钻
		 //24位普通蓝钻 23位年费蓝钻 19-22位蓝钻等级 17位是否为豪华蓝钻  18位是否从我们游戏成为蓝钻
		 //9-16 3366 用户等级
		 *
		 * 3366成长等级
		 * 1-5 显示包子1
		 6-10 显示包子2
		 11-15 显示包子3
		 16-20 显示包子4
		 21-25 显示包子5
		 26及以上 显示包子6
		 
		 *
		 * @param iData
		 * @return
		 *
		 */
		
		/**
		 * 处理关于QQ VIP 网络数据字段解析
		 *
		 //QQ用户信息 从高位到低位, 1位普通黄钻 2位年费黄钻 3-6位黄钻等级 7位是否从我们游戏成为黄钻
		 //9位普通蓝钻 10位年费蓝钻 11-14位蓝钻等级  15位是否从我们游戏成为蓝钻  16位是否为豪华蓝钻
		 //17-24 3366 用户等级
		 *
		 * 3366成长等级
		 * 1-5 显示包子1
		 6-10 显示包子2
		 11-15 显示包子3
		 16-20 显示包子4
		 21-25 显示包子5
		 26及以上 显示包子6
		 
		 *
		 * @param iData
		 * @return
		 *
		 */
		public static function parseQQVIP(iData:int):Array
		{
			//数组 0 ：表示QQ VIP 三种状态  。 
			//数组 1 ：表示QQ VIP 等级  。
			//数组 2 ：该VIP是否从我们游戏中获得的
			//数组 3 ：如果 从 3366 中进入游戏的 之类表示 3366 的包子等级
			//数组 4 ：表示实际的包子等级，转化前的。
			//数组 5 ：表示是否为豪华蓝钻
			
			var _ret:Array=[];
			var _is_QQ_vip:int=0; //BitUtil.getOneToOne(iData,1,1);
			var _is_QQ_year_vip:int=0; //BitUtil.getOneToOne(iData,2,2);
			var _QQ_vip_level:int=0; //BitUtil.getOneToOne(iData,3,6);
			var _vip_fromGame:int=0; //BitUtil.getOneToOne(iData,7,7);
			var _3366_baozi_level:int=0;
			
			if (GameIni.PF_3366 == GameIni.pf())
			{
				_is_QQ_vip=BitUtil.getOneToOne(iData, 1 + 8, 1 + 8);
				_is_QQ_year_vip=BitUtil.getOneToOne(iData, 2 + 8, 2 + 8);
				_QQ_vip_level=BitUtil.getOneToOne(iData, 3 + 8, 6 + 8);
				_vip_fromGame=BitUtil.getOneToOne(iData, 7 + 8, 7 + 8);
				
				_3366_baozi_level=BitUtil.getOneToOne(iData, 17, 24);
				_ret[4]=_3366_baozi_level;
				if (_3366_baozi_level >= 1 && _3366_baozi_level <= 5)
				{
					_3366_baozi_level=1;
				}
				else if (_3366_baozi_level >= 6 && _3366_baozi_level <= 10)
				{
					_3366_baozi_level=2;
				}
				else if (_3366_baozi_level >= 11 && _3366_baozi_level <= 15)
				{
					_3366_baozi_level=3;
				}
				else if (_3366_baozi_level >= 16 && _3366_baozi_level <= 20)
				{
					_3366_baozi_level=4;
				}
				else if (_3366_baozi_level >= 21 && _3366_baozi_level <= 25)
				{
					_3366_baozi_level=5;
				}
				else if (_3366_baozi_level >= 26)
				{
					_3366_baozi_level=6;
				}
				
				_ret[5]=BitUtil.getOneToOne(iData, 16, 16);
			}
			else
			{
				_is_QQ_vip=BitUtil.getOneToOne(iData, 1, 1);
				_is_QQ_year_vip=BitUtil.getOneToOne(iData, 2, 2);
				_QQ_vip_level=BitUtil.getOneToOne(iData, 3, 6);
				_vip_fromGame=BitUtil.getOneToOne(iData, 7, 7);
			}
			
			
			if (1 == _is_QQ_year_vip)
			{
				_ret[0]=YellowDiamond.QQ_YELLOW_YEAR;
				_ret[1]=_QQ_vip_level;
			}
			else if (1 == _is_QQ_vip)
			{
				_ret[0]=YellowDiamond.QQ_YELLOW_COMMON;
				_ret[1]=_QQ_vip_level;
			}
			else
			{
				_ret[0]=YellowDiamond.QQ_YELLOW_NULL;
				_ret[1]=0;
			}
			
			_ret[2]=_vip_fromGame;
			_ret[3]=_3366_baozi_level;
			
			return _ret;
		}
		
		/**
		 * 判断当前玩家的黄钻是否从我们游戏中充值的
		 * @return
		 *
		 */
		public function getQQYellowFrom():Boolean
		{
			return m_qqYellowVIP_FromGame;
		}
		
		public function getQQYellowType():int
		{
			return this.m_qqYellowType;
		}
		
		//是不是豪华用户
		public function isQQYellow_MOST(iData:int):Boolean
		{
			return parseQQVIP(iData)[5];
		}
		
		public function getQQYellowLevel():int
		{
			return this.m_qqYellowLevel;
		}
		
		public function get3366Level():int
		{
			return this.m_3366Level;
		}
		
		public function get3366RealLevel():int
		{
			return this.m_3366RealLevel;
		}
		
		public function getQQYellowGiftsNew():int
		{
			return this.m_giftsNew;
		}
		
		public function getQQYellowGiftsCommon():int
		{
			return this.m_giftsCommon;
		}
		
		public function getQQYellowGiftsYear():int
		{
			return this.m_giftsYear;
		}
		
		public function getQQYellowGiftsMost():int
		{
			return this.m_giftsMost;
		}
		
		
		
		public function get3366Gifts():int
		{
			return this.m_gifts3366;
		}
		
		private function _set3366Gifts(gift:int):void
		{
			this.m_gifts3366=gift;
			
			if (GameIni.PF_3366 == GameIni.pf())
			{
				if (0 == this.m_gifts3366)
				{
					ControlButton.getInstance().setVisible("arr3366", true, true);
				}
				else
				{
					ControlButton.getInstance().setVisible("arr3366", true, false);
				}
			}
		}
		
		
		public function getConfigGiftsNew():Pub_YellowResModel
		{
			var _ret:Pub_YellowResModel=null;
			
			if (null != this.m_configGiftsNewList[1])
			{
				_ret=this.m_configGiftsNewList[1] as Pub_YellowResModel;
			}
			
			return _ret;
		}
		
		public function getConfigGiftsLevelListByShowIndex():Array
		{
			return m_configGiftsLevelListByShowIndex;
		}
		
		public function getMaxShowindex():int
		{
			return this.m_maxShow_index;
		}
		
		public function getConfigGiftsList():Array
		{
			return this.m_configGiftsList;
		}
		
		
		/**
		 * 处理当前玩家的黄钻图标
		 * @param mc
		 *
		 */
		public static function handleYellowDiamondMC(qqmc:MovieClip, level:int=-1):void
		{
			if (qqmc == null)
			{
				return;
			}
			
			if (level < 0)
			{
				//				if(GameIni.PF_3366 ==  GameIni.pf())
				//				{
				//					
				//				}
				//				else
				//				{
				//					var _yellowDiamondModel:YellowDiamond = YellowDiamond.getInstance();
				//					var _yellowLevel:int = _yellowDiamondModel.getQQYellowLevel();
				//					switch(_yellowDiamondModel.getQQYellowType())
				//					{
				//						case YellowDiamond.QQ_YELLOW_NULL:
				//							qqmc.visible = false;
				//							break;
				//						case YellowDiamond.QQ_YELLOW_COMMON:
				//							qqmc.visible = true;
				//							qqmc.gotoAndStop(1);
				//							if(qqmc['mc_xiao_zuan']!=null)
				//								qqmc['mc_xiao_zuan'].gotoAndStop(_yellowLevel);
				//							break;
				//						case YellowDiamond.QQ_YELLOW_YEAR:
				//							qqmc.visible = true;
				//							qqmc.gotoAndStop(2);
				//							if(qqmc['mc_nian_zuan']!=null)
				//								qqmc['mc_nian_zuan'].gotoAndStop(_yellowLevel);
				//							break;
				//						default:
				//							break;
				//					}
				//				}
				
				YellowDiamond.getInstance().handleYellowDiamondMC2(qqmc, YellowDiamond.getInstance().getQQYellowVIP());
			}
			else if (level >= 1)
			{
				qqmc['mc_xiao_zuan'].gotoAndStop(level);
			}
			
			
			
		}
		
		private function _onBlueDiamondClickListener(e:MouseEvent):void
		{
			var _name:String=e.target.name;
			
			switch (_name)
			{
				case "mc_blue":
					//BlueDiamondWindow.getInstance().open();
					break;
				default:
					break;
			}
		}
		
		/**
		 * 处理玩家的黄钻图标
		 * @param mc    元件
		 * @param iData 黄钻数值
		 *
		 */
		public function handleYellowDiamondMC2(qqmc:MovieClip, iData:int):int
		{
			if (qqmc == null)
				return 0;
			
			if (GameIni.pf() == GameIni.PF_3366 || GameIni.pf() == GameIni.PF_QQGAME)
			{
				if (false == qqmc.hasEventListener(MouseEvent.CLICK))
				{
					qqmc.addEventListener(MouseEvent.CLICK, _onBlueDiamondClickListener);
				}
			}
			
			
			
			var arr:Array=parseQQVIP(iData);
			//表示该用户是不是 豪华用户
			var m_is_QQYellow_MOST:Boolean=arr[5];
			
			
			if (GameIni.PF_QQGAME == GameIni.pf())
			{
				
				switch (arr[0])
				{
					case YellowDiamond.QQ_YELLOW_NULL:
						qqmc.visible=false;
						break;
					case YellowDiamond.QQ_YELLOW_COMMON:
						qqmc.visible=true;
						qqmc.gotoAndStop(5);
						
						if (null != qqmc['mc_xiao_zuan_blue'])
						{
							if (m_is_QQYellow_MOST)
							{
								qqmc['mc_xiao_zuan_blue'].gotoAndStop(arr[1] + 10);
							}
							else
							{
								qqmc['mc_xiao_zuan_blue'].gotoAndStop(arr[1]);
							}
							
							if (0 == arr[3])
							{
								if (null != qqmc['mc_xiao_zuan_blue']['baozi'])
								{
									qqmc['mc_xiao_zuan_blue']['baozi'].visible=false;
								}
								
							}
							else
							{
								if (null != qqmc['mc_xiao_zuan_blue']['baozi'])
								{
									qqmc['mc_xiao_zuan_blue']['baozi'].gotoAndStop(arr[3]);
								}
							}
						}
						
						break;
					case YellowDiamond.QQ_YELLOW_YEAR:
						qqmc.visible=true;
						qqmc.gotoAndStop(6);
						
						if (null != qqmc['mc_nian_zuan_blue'])
						{
							if (m_is_QQYellow_MOST)
							{
								qqmc['mc_nian_zuan_blue'].gotoAndStop(arr[1] + 10);
							}
							else
							{
								qqmc['mc_nian_zuan_blue'].gotoAndStop(arr[1]);
							}
							
							if (0 == arr[3])
							{
								if (null != qqmc['mc_nian_zuan_blue']['baozi'])
								{
									qqmc['mc_nian_zuan_blue']['baozi'].visible=false;
								}
								
							}
							else
							{
								if (null != qqmc['mc_nian_zuan_blue']['baozi'])
								{
									qqmc['mc_nian_zuan_blue']['baozi'].gotoAndStop(arr[3]);
								}
							}
						}
						
						break;
					default:
						break;
				}
				
				
				
				
			}
			else if (GameIni.PF_3366 == GameIni.pf())
			{
				switch (arr[0])
				{
					case YellowDiamond.QQ_YELLOW_NULL:
						qqmc.visible=true;
						qqmc.gotoAndStop(5);
						if (null != qqmc['mc_blue'])
						{
							qqmc['mc_blue'].visible=false;
							
						}
						
						if (null != qqmc['mc_baozi'])
						{
							if (0 == arr[3])
							{
								qqmc['mc_baozi'].visible=false;
							}
							else
							{
								qqmc['mc_baozi'].visible=true;
								qqmc['mc_baozi'].gotoAndStop(arr[3]);
							}
						}
						break;
					case YellowDiamond.QQ_YELLOW_COMMON:
						qqmc.visible=true;
						qqmc.gotoAndStop(5);
						
						if (null != qqmc['mc_blue'])
						{
							qqmc['mc_blue'].visible=true;
							if (m_is_QQYellow_MOST)
							{
								qqmc['mc_blue'].gotoAndStop(arr[1] + 10);
							}
							else
							{
								qqmc['mc_blue'].gotoAndStop(arr[1]);
							}
						}
						
						if (null != qqmc['mc_baozi'])
						{
							if (0 == arr[3])
							{
								qqmc['mc_baozi'].visible=false;
							}
							else
							{
								qqmc['mc_baozi'].visible=true;
								qqmc['mc_baozi'].gotoAndStop(arr[3]);
							}
						}
						
						
						break;
					case YellowDiamond.QQ_YELLOW_YEAR:
						qqmc.visible=true;
						qqmc.gotoAndStop(6);
						
						if (null != qqmc['mc_blue'])
						{
							qqmc['mc_blue'].visible=true;
							if (m_is_QQYellow_MOST)
							{
								qqmc['mc_blue'].gotoAndStop(arr[1] + 10);
							}
							else
							{
								qqmc['mc_blue'].gotoAndStop(arr[1]);
							}
						}
						
						if (null != qqmc['mc_baozi'])
						{
							if (0 == arr[3])
							{
								qqmc['mc_baozi'].visible=false;
							}
							else
							{
								qqmc['mc_baozi'].visible=true;
								qqmc['mc_baozi'].gotoAndStop(arr[3]);
							}
						}
						
						break;
					default:
						break;
				}
				
				
				
			}
			else
			{
				//----------------------------------------
				
				switch (arr[0])
				{
					case YellowDiamond.QQ_YELLOW_NULL:
						qqmc.visible=false;
						break;
					case YellowDiamond.QQ_YELLOW_COMMON:
						qqmc.visible=true;
						qqmc.gotoAndStop(1);
						if (qqmc['mc_xiao_zuan'] != null)
							qqmc['mc_xiao_zuan'].gotoAndStop(arr[1]);
						break;
					case YellowDiamond.QQ_YELLOW_YEAR:
						qqmc.visible=true;
						qqmc.gotoAndStop(2);
						if (qqmc['mc_nian_zuan'] != null)
							qqmc['mc_nian_zuan'].gotoAndStop(arr[1]);
						break;
					default:
						break;
				}
			}
			return arr[0];
		}
		//-------------- 清凉一夏天  网络协议处理 ------------------------
		/**
		 *
		 * 获取QQ黄钻续费活动清凉一夏信息
		 */
		public function reqeustCSActGetQQYellowSummer():void
		{
			if (GameIni.PF_3366 != GameIni.pf())
			{
				//var _p:PacketCSActGetQQYellowSummer=new PacketCSActGetQQYellowSummer();
				//DataKey.instance.send(_p);
			}
			
		}
		
		//清凉一夏 的开启时间
		private var QL_startTime:Date;
		//清凉一夏 的开始时间 字符串格式
		public var QL_startTimeString:String;
		//清凉一夏 的结束时间
		private var QL_endTime:Date;
		//清凉一夏 的结束时间 字符串格式
		public var QL_EndTimeString:String;
		//QQ黄钻续费活动清凉一夏活动状态  1 表示开启
		private var QL_state:int;
		
		private function _responseSCActGetQQYellowSummer(p:IPacket):void
		{
//			var _p:PacketSCActGetQQYellowSummer=p as PacketSCActGetQQYellowSummer;
//			
//			QL_state=_p.state;
//			QL_startTime=StringUtils.iDateToDate(_p.begin_date);
//			QL_startTimeString=StringUtils.iDataToDateString(_p.begin_date);
//			QL_endTime=StringUtils.iDateToDate(_p.end_date);
//			QL_EndTimeString=StringUtils.iDataToDateString(_p.end_date);
//			
//			//开启清凉一夏
//			if (1 == QL_state && GameIni.PF_3366 != GameIni.pf())
//			{
//				ControlButton.getInstance().setVisible('arrQingLiang', true, true);
//			}
//			else
//			{
//				ControlButton.getInstance().setVisible('arrQingLiang', false, false);
//			}
//			
//			var _e:YellowDiamondEvent=null;
//			_e=new YellowDiamondEvent(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT);
//			dispatchEvent(_e);
			
		}
		
		
		/**
		 * 获取QQ黄钻续费清凉一夏活动信息数据
		 *
		 */
		public function reqeustCSActGetQQYellowSummerData():void
		{
			//var _p:PacketCSActGetQQYellowSummerData=new PacketCSActGetQQYellowSummerData();
			//DataKey.instance.send(_p);
		}
		
		
		/**
		 *开通续费次数
		 */
		public var QL_num:int;
		/**
		 *礼包的领取状态，从低位到高位，为1表示已领取，为0表示未领取
		 */
		public var QL_libao_state:int;
		
		private function _responseSCActGetQQYellowSummerData(p:IPacket):void
		{
//			var _p:PacketSCActGetQQYellowSummerData=p as PacketSCActGetQQYellowSummerData;
//			
//			QL_num=_p.num;
//			QL_libao_state=_p.state;
//			
//			//BitUtil.getOneToOne(QL_libao_state,1,1);
//			
//			var _e:YellowDiamondEvent=null;
//			_e=new YellowDiamondEvent(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT);
//			dispatchEvent(_e);
		}
		
		
		/**
		 * QQ黄钻续费清凉一夏活动领奖 ,  1，2，3，4....
		 * @param index   领取序号
		 *
		 */
		public function reqeustCSActGetQQYellowSummerPrize(index:int):void
		{
//			var _p:PacketCSActGetQQYellowSummerPrize=new PacketCSActGetQQYellowSummerPrize();
//			_p.index=index;
//			DataKey.instance.send(_p);
		}
		
		private function _responseSCActGetQQYellowSummerPrize(p:IPacket):void
		{
//			var _p:PacketSCActGetQQYellowSummerPrize=p as PacketSCActGetQQYellowSummerPrize;
//			
//			if (0 != _p.tag)
//			{
//				Lang.showResult(_p);
//				return;
//			}
//			
//			reqeustCSActGetQQYellowSummerData();
		}
		
		
		//---------------------------------------------------------
		
		
		public function requestCSActGetQQYellowPet():void
		{
			var _p:PacketCSActGetQQYellowPet=new PacketCSActGetQQYellowPet();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCActGetQQYellowPet(p:IPacket):void
		{
			var _p:PacketSCActGetQQYellowPet=p as PacketSCActGetQQYellowPet;
			//			
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
			
			
		}
		
		
		
		
	}
	
	
}









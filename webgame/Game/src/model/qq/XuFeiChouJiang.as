package model.qq
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import netc.DataKey;
	import netc.packets2.StructQQYellowLog2;
	
	import nets.ipacket.IPacket;
	import nets.packets.PacketCSActGetQQYellow;
	import nets.packets.PacketCSActGetQQYellowData;
	import nets.packets.PacketCSActGetQQYellowPrize;
	import nets.packets.PacketCSActGetQQYellowPrizeLog;
	import nets.packets.PacketCSActGetQQYellowPrizeToBag;
	import nets.packets.PacketCSItemExchange;
	import nets.packets.PacketSCActGetQQYellow;
	import nets.packets.PacketSCActGetQQYellowData;
	import nets.packets.PacketSCActGetQQYellowPrize;
	import nets.packets.PacketSCActGetQQYellowPrizeLog;
	import nets.packets.PacketSCActGetQQYellowPrizeToBag;
	import nets.packets.PacketSCItemExchange;
	
	import utils.StringUtils;
	import utils.bit.BitUtil;
	
	import view.view2.other.ControlButton;
	import view.view4.qq.WenXinTiShi_POP;
	import view.view4.qq.XuFeiChouJiangWindow;
	
	import world.Lang;

	public class XuFeiChouJiang  extends EventDispatcher
	{
		private static var m_instance:XuFeiChouJiang = null;
		
		//奖品总个数
		public static const REWARDS_NUM:int = 17;
		
		
		//活动是否处于开启状态，由服务器传送过来。
		private var m_isOnTime:Boolean = false;
		
		public function XuFeiChouJiang(target:IEventDispatcher=null)
		{
			super(target);
			_init();
			
			DataKey.instance.register(PacketSCActGetQQYellow.id,_responseSCActGetQQYellow);   
			DataKey.instance.register(PacketSCActGetQQYellowData.id,_responseSCActGetQQYellowData);   
			DataKey.instance.register(PacketSCActGetQQYellowPrize.id,_responseSCActGetQQYellowPrize);  
			
			DataKey.instance.register(PacketSCActGetQQYellowPrizeToBag.id,_responseSCActGetQQYellowPrizeToBag);  
			DataKey.instance.register(PacketSCActGetQQYellowPrizeLog.id,_responseSCActGetQQYellowPrizeLog);  
			DataKey.instance.register(PacketSCItemExchange.id,_responseSCItemExchange);  
			
			
			
		}
		
		public static function getInstance():XuFeiChouJiang
		{
			if(null == m_instance)
			{
				m_instance = new XuFeiChouJiang();
			}
			
			return m_instance;
		}
		
		/**
		 * 奖励的数据,二维数组 【物品ID，是否已经领取(0表示未领取)】 
		 */		
		private var rewards:Array = null;
		
		/**
		 * 初始化数据结构 
		 * 
		 */		
		private function _init():void
		{
			if(null != rewards)
			{
				return ;
			}
			
			rewards = [];
			for(var i:int = 1 ; i <= REWARDS_NUM; ++i)
			{
				rewards[i] = [1000+i,0];
			}
		}
		
		
		private var m_remainderTicketNum:int = 0;
		/**
		 * 获得剩余奖券个数
		 * @return 
		 * 
		 */		
		public function remainderTicketNum():int
		{
			return m_remainderTicketNum;
		}
		
		/**
		 * 剩余奖品个数 
		 * @return 
		 * 
		 */		
		public function remainderRewardsNum():int
		{
			var _ret:int = 0;
			for(var i:int = 1 ; i <= REWARDS_NUM ; ++i)
			{
				if(0 == rewards[i][1])
				{
					++_ret;
				}
			}
			return _ret;
		}  
		
		/**
		 * 是否领取了。 
		 * @param index
		 * @return 
		 * 
		 */		
		public function hasResived(index:int):Boolean
		{
			if(0 == rewards[index][1])
			{
				return false;
			}
			else
			{
				return true;	
			}
		}
		
		public function getFirstIndex():int
		{
			var _ret:int = 0;
			for(var i:int = 1 ; i <= REWARDS_NUM; ++i)
			{
				if(0 == rewards[i][1])
				{
					_ret = i;
					break;
				}
			}
			
			return _ret;
		}
		
		public function getNextIndex(index:int):int
		{
			var _ret:int; 
			var _init:int = index;
			while(true)
			{
			  ++index;
			  if(index >= REWARDS_NUM)
			  {
				  index = 1;
			  }
			  
			  if(_init == index || 0 == rewards[index][1])
			  {
				  _ret  = index;
				  break;
			  }
			 
			}
			
			return _ret;
		}
		
		
		private var m_CanReceiveIndex:int = 0;
		/**
		 * 当前可以领取奖励的索引 
		 * @return 
		 * 
		 */		
		public function getCanReceiveIndex():int
		{
			return m_CanReceiveIndex;
		}
		
		private var m_endTime:Date;
		/**
		 * 获得活动结束时间 
		 * @return 
		 * 
		 */		
		public function getEndTime():Date
		{
			return m_endTime;
		}
		
		
		private var m_EndTimeString:String = null;
		public function getEndTimeString():String
		{
			if(null == m_EndTimeString)
			{
				m_EndTimeString = "";
			}
			return m_EndTimeString;
		}
		
		private var m_startTime:Date;
		/**
		 * 获得活动的开始时间 
		 * @return 
		 * 
		 */		
		public function getStartTime():Date
		{
			return m_startTime;
		}
		
		/**
		 * 获取QQ黄钻续费活动信息 
		 * 
		 */		
		public function requestCSActGetQQYellow():void
		{
			var _p:PacketCSActGetQQYellow = new PacketCSActGetQQYellow();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCActGetQQYellow(p:IPacket):void     
		{
			var _p:PacketSCActGetQQYellow = p as PacketSCActGetQQYellow;
			
			m_startTime = StringUtils.iDateToDate(_p.begin_date);   
			m_endTime =  StringUtils.iDateToDate(_p.end_date);   
			m_EndTimeString = StringUtils.iDataToDateString(_p.end_date);

			if(1 == _p.state)
			{
				m_isOnTime = true;
				ControlButton.getInstance().setVisible("arrXuFeiChouJiang",true,true);
			}
			else
			{
				m_isOnTime = false;
				ControlButton.getInstance().setVisible("arrXuFeiChouJiang",false);
			}
			
		}
		
		
		
		/**
		 *  获取QQ黄钻续费活动信息数据
		 * 
		 */		
		public function requestCSActGetQQYellowData():void
		{
			var _p:PacketCSActGetQQYellowData = new PacketCSActGetQQYellowData();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCActGetQQYellowData(p:IPacket):void
		{
			var _p:PacketSCActGetQQYellowData = p as PacketSCActGetQQYellowData;
			
			m_remainderTicketNum = _p.num;
			m_CanReceiveIndex = _p.last_prize_id;
			
			for(var i:int = 1 ; i <= REWARDS_NUM ; ++i)
			{
				rewards[i][1] = BitUtil.getOneToOne(_p.state,i,i);
			}
			
			var _e:XuFeiChouJiangEvent = new XuFeiChouJiangEvent(XuFeiChouJiangEvent.QQ_XUFEI_CHOUJIANG_EVENT);
			_e.sort = XuFeiChouJiangEvent.SORT_DATA;
			dispatchEvent(_e);
			
		}
		
		
		
		/**
		 * QQ黄钻续费抽奖 
		 * 
		 */		
		public function requestCSActGetQQYellowPrize():void
		{
			var _p:PacketCSActGetQQYellowPrize = new PacketCSActGetQQYellowPrize();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCActGetQQYellowPrize(p:IPacket):void
		{
			var _p:PacketSCActGetQQYellowPrize = p as PacketSCActGetQQYellowPrize;
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
			
			m_CanReceiveIndex = _p.last_prize_id;
			--m_remainderTicketNum;
			if(m_remainderTicketNum < 0)
			{
				m_remainderTicketNum = 0;
			}
			
			var _e:XuFeiChouJiangEvent = new XuFeiChouJiangEvent(XuFeiChouJiangEvent.QQ_XUFEI_CHOUJIANG_EVENT);
			_e.sort = XuFeiChouJiangEvent.SORT_CHOUJIANG;
			dispatchEvent(_e);
		}
		
		/**
		 * QQ黄钻续费礼包领取
		 * 
		 */		
		public function requestCSActGetQQYellowPrizeToBag():void
		{
			var _p:PacketCSActGetQQYellowPrizeToBag = new PacketCSActGetQQYellowPrizeToBag();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCActGetQQYellowPrizeToBag(p:IPacket):void
		{
			var _p:PacketSCActGetQQYellowPrizeToBag = p as PacketSCActGetQQYellowPrizeToBag;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
			
//			var _e:XuFeiChouJiangEvent = new XuFeiChouJiangEvent(XuFeiChouJiangEvent.QQ_XUFEI_CHOUJIANG_EVENT);
//			_e.sort = XuFeiChouJiangEvent.SORT_LINGJIANG;
//			dispatchEvent(_e);
			
			requestCSActGetQQYellowData();
		}
		
		/**
		 * 商店ID70200009		
			物品ID10200277	 
		 * 
		 */		
		public function requestCSItemExchange(shopID:int=70200009,itemID:int=10200277):void
		{
			var _p:PacketCSItemExchange = new PacketCSItemExchange();
			_p.shopid = shopID;
			_p.itemid = itemID;
			_p.num = 1;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCItemExchange(p:IPacket):void
		{
			var _p:PacketSCItemExchange = p as PacketSCItemExchange;
			
			if(0 != _p.tag)
			{
				//Lang.showResult(_p);
				if(XuFeiChouJiangWindow.getInstance().isOpen)
				{
					if(15003 ==  _p.tag || 15009 == _p.tag)
					{
						WenXinTiShi_POP.getInstance().setType(0);
						WenXinTiShi_POP.getInstance().open(true);
					}
				}
				
				
				return ;
			}
			
			
		}
		
		
		private var m_arrItemmsg:Vector.<StructQQYellowLog2> = null;
		/**
		 * 获得日志信息 
		 * @return 
		 * 
		 */		
		public function getArrItemMsg():Vector.<StructQQYellowLog2>
		{
			return m_arrItemmsg;
		}
		
		
		/**
		 * QQ黄钻续费礼包领取日志 
		 * 
		 */		
		public function requestCSActGetQQYellowPrizeLog():void
		{
			var _p:PacketCSActGetQQYellowPrizeLog = new PacketCSActGetQQYellowPrizeLog();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCActGetQQYellowPrizeLog(p:IPacket):void
		{
			var _p:PacketSCActGetQQYellowPrizeLog = p as PacketSCActGetQQYellowPrizeLog;
			
			m_arrItemmsg = _p.arrItemmsg;
			
			var _e:XuFeiChouJiangEvent = new XuFeiChouJiangEvent(XuFeiChouJiangEvent.QQ_XUFEI_CHOUJIANG_EVENT);
			_e.sort = XuFeiChouJiangEvent.SORT_MSG;
			dispatchEvent(_e);
		}
		
		
		
	}
	
	
	
	
}




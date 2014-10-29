package model.rebate
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.events.EventDispatcher;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.DateSet;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketCSGetCosume;
	import nets.packets.PacketCSGetCosumePrize;
	import nets.packets.PacketSCGetCosume;
	import nets.packets.PacketSCGetCosumePrize;
	
	import ui.view.view2.other.CBParam;
	import ui.view.view2.other.ControlButton;
	import ui.view.view2.rebate.ConsumeRebateEvent;

	/**
	 * 消费返利模块
	 * @author steven guo
	 * 
	 */	
	public class ConsumeRebateModel extends EventDispatcher
	{
		private static var m_instance:ConsumeRebateModel;
		
		//没有领了
		public static const CONSUME_REBATE_NO:int = 0;
		//已经领了
		public static const CONSUME_REBATE_YES:int = 1;
		//不够条件，不能领
		public static const CONSUME_REBATE_CANNOT:int = 2;
		
		//累计消费元宝数量
		private var m_YB_Consume_Number:int = 0;
		
		//消费返利 元宝数量列表
		private var m_YB_NumberList:Array = null;
		
		//消费返利 掉落ID列表
		private var m_DropIDList:Array = null;
		
		//配置文件列表
		private var m_RwardConfigList:Array = null;

		//开始时间
		private var m_startTimeString:String = null;
		//结束时间
		private var m_endTimeString:String = null;
		//剩余时间
		private var m_remainderTimeString:String = null;
		//消费返利领取状态,按位
		private var m_state:int;
		
		//是否有可领的奖励
		private var m_hasRward:Boolean;
		
		public function ConsumeRebateModel()
		{
			DataKey.instance.register(PacketSCGetCosume.id,_responeSCGetCosume);    
			DataKey.instance.register(PacketSCGetCosumePrize.id,_responseSCGetCosumePrize);    
			
			Data.myKing.addEventListener(MyCharacterSet.LEVEL_UPDATE, me_lvl_up);
			
			_init();
		}
		
		private function me_lvl_up(e:DispatchEvent):void
		{
			if(null != m_PacketSCGetCosume)
			{
				_responeSCGetCosume(m_PacketSCGetCosume);
			}
			
		}
		
		public static function getInstance():ConsumeRebateModel
		{
			if(null == m_instance)
			{
				m_instance = new ConsumeRebateModel();
			}
			
			return m_instance;
		}
		
		/**
		 * 是否有可领取的奖励 
		 * @return 
		 * 
		 */		
		public function hasRward():Boolean
		{
			return m_hasRward;
		}
		
		/**
		 * 活动开始时间 
		 * @return 
		 * 
		 */		
		public function startTime():String
		{
			return m_startTimeString;
		}
		
		/**
		 * 活动结束时间 
		 * @return 
		 * 
		 */		
		public function endTime():String
		{
			return m_endTimeString ;
		}
		
		/**
		 * 活动剩余时间 
		 * @return 
		 * 
		 */		
		public function remainderTime():String
		{
			return m_remainderTimeString;
		}
		
		
		/**
		 * 累计消费元宝数量
		 * @return 
		 * 
		 */		
		public function getYBConsumeNumber():int
		{
			return m_YB_Consume_Number;
		}
		
		/**
		 * 根绝索引获得该奖励的状态，未领，已领，不能领 
		 * @param index
		 * 
		 */		
		public function getStateByIndex(index:int):int
		{
			if(m_YB_Consume_Number < m_YB_NumberList[index])
			{
				return CONSUME_REBATE_CANNOT;
			}
			
			var _ret:int = BitUtil.getOneToOne(m_state,(index + 1),(index + 1));
			
			return _ret;
		}
		
		public function getRwardConfigList():Array
		{
			return m_RwardConfigList;
		}
		
		/**
		 * 初始化，例如可以初始化一下奖励列表 
		 * 
		 */		
		private function _init():void
		{
			m_YB_NumberList = Lang.getLabelArr("arrConsumeRebate_YB_Number");
			m_DropIDList = Lang.getLabelArr("arrConsumeRebate_DropID");
			m_RwardConfigList = [];
			
			var _length:int = m_YB_NumberList.length;
			for(var i:int = 0; i<_length ; ++i)
			{
				m_RwardConfigList[i] = new ConsumeRebateRwardConfig(m_YB_NumberList[i],m_DropIDList[i]);
			}
		}
		
		/**
		 * 获取消费返利信息 
		 * 
		 */		
		public function requestCSGetCosume():void
		{
			var _p:PacketCSGetCosume = new PacketCSGetCosume();
			DataKey.instance.send(_p);
		}
		
		
		private var m_PacketSCGetCosume:PacketSCGetCosume = null;
		
		/**
		 * 获取消费返利信息返回
		 * @param p
		 * 
		 */		
		private function _responeSCGetCosume(p:IPacket):void
		{
			var _p:PacketSCGetCosume = p as PacketSCGetCosume;
			
			m_PacketSCGetCosume = _p;
			
			m_startTimeString = StringUtils.iDataToDateString(_p.begin_date) + 
				"00"+Lang.getLabel("pub_xiaoshi") + "00" + Lang.getLabel("pub_fenzhong");
			m_endTimeString = StringUtils.iDataToDateString(_p.end_date) + 
				"23"+Lang.getLabel("pub_xiaoshi") + "59" + Lang.getLabel("pub_fenzhong");
			
			//当前服务器时间
			var _nowDate:Date = Data.date.nowDate;
			var _endDate:Date = StringUtils.iDateToDate(_p.end_date);
			var _diffTime:Number = (_endDate.getTime() + 24*60*60*1000) - _nowDate.getTime();
			if(_diffTime <= 0)
			{
				_diffTime = 0;
			}
			m_remainderTimeString = StringUtils.getStringDayTime(_diffTime,false);
			m_YB_Consume_Number = _p.num;
			m_state = _p.state;
			
			if(1 == _p.hasGift )
			{
				m_hasRward = true;
				
			}
			else 
			{
				m_hasRward = false;
			}
			
			if(_p.begin_date <= 0)
			{
				//操作大图标
				ControlButton.getInstance().setVisible("arrXiaoFeiFanLi",false,m_hasRward);
			}
			else
			{
				//操作大图标
				if(Data.myKing.level >= CBParam.ArrXiaoFeiFanLi_On_Lvl){
				ControlButton.getInstance().setVisible("arrXiaoFeiFanLi",true,m_hasRward);
				}
				
				var _e:ConsumeRebateEvent = new ConsumeRebateEvent(ConsumeRebateEvent.CONSUME_REBATE_EVENT);
				_e.sort = ConsumeRebateEvent.CONSUME_REBATE_EVENT_SORT;
				dispatchEvent(_e);
			}
			
		}
		
		/**
		 * 奖励序号，从1开始
		 * @param index
		 * 
		 */		
		public function requestCSGetCosumePrize(index:int):void
		{
			trace("requestCSGetCosumePrize....");
			var _p:PacketCSGetCosumePrize = new PacketCSGetCosumePrize();
			_p.index = index + 1;
			
			DataKey.instance.send(_p);
		}
		
		private function _responseSCGetCosumePrize(p:IPacket):void
		{
			var _p:PacketSCGetCosumePrize = p as PacketSCGetCosumePrize;
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
		}
		
		
	}
	
}














package model.yunying
{
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.Queue;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.view.view2.other.ControlButton;
	import ui.view.view4.yunying.XunBaoChangKu;

	/**
	 * 寻宝活动
	 * @author steven guo
	 *
	 */
	public class XunBaoModel extends EventDispatcher
	{
		private static var m_instance:XunBaoModel;
		
		//开启等级
		private var m_openLevel:int = 40;

		public function XunBaoModel(target:IEventDispatcher=null)
		{
			super(target);

			DataKey.instance.register(PacketSCDiscoveringTreasure.id, _responseSCDiscoveringTreasure);
			DataKey.instance.register(PacketSCDiscoveringTreasureInfo.id, _responseSCDiscoveringTreasureInfo);
			DataKey.instance.register(PacketSCDiscoveringTreasureLog.id, _responseSCDiscoveringTreasureLog);
			DataKey.instance.register(PacketSCDiscoveringTreasureHeroLog.id, _responseSCDiscoveringTreasureHeroLog);
			
			DataKey.instance.register(PacketSCDrawLuckyItem.id, _responseSCDrawLuckyItem);
			DataKey.instance.register(PacketSCTrimActBank.id, _responseSCTrimActBank);
			
			//包裹满了
			DataKey.instance.register(PacketSCActBankTakeAll.id, _responseSCActBankTakeAll);
			
			
			Data.myKing.addEventListener(MyCharacterSet.LEVEL_UPDATE, me_lvl_up);

			//
			ControlButton.getInstance().checkXunBao();

			
			
			var _xunBaoBag:PacketCSPlayerActBank = new PacketCSPlayerActBank();
			DataKey.instance.send(_xunBaoBag);
		}
		
		private function me_lvl_up(e:DispatchEvent):void
		{
			ControlButton.getInstance().checkXunBao();
		}

		public static function getInstance():XunBaoModel
		{
			if (null == m_instance)
			{
				m_instance=new XunBaoModel();
			}

			return m_instance;
		}

		//--------------------------------------------------------------

		/**
		 *  寻宝
		 * @param type  1:寻宝1次 2:寻宝10次 3:寻宝50次
		 *
		 */
		public function requestCSDiscoveringTreasure(type:int):void
		{
			var _p:PacketCSDiscoveringTreasure=new PacketCSDiscoveringTreasure();
			_p.type=type;
			DataKey.instance.send(_p);
		}

		private function _responseSCDiscoveringTreasure(p:IPacket):void
		{
			var _p:PacketSCDiscoveringTreasure=p as PacketSCDiscoveringTreasure;

			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}else{
				XunBaoChangKu.getInstance().open(true);
			}

		}

		//---------------------------------------------------------------

		/**
		 * 获取寻宝信息
		 *
		 */
		public function requestCSDiscoveringTreasureInfo():void
		{
			var _p:PacketCSDiscoveringTreasureInfo=new PacketCSDiscoveringTreasureInfo();
			DataKey.instance.send(_p);
		}

		//抽奖物品ID
		private var m_DiscoveringItemID:int=0;

		public function getDiscoveringItemID():int
		{
			return m_DiscoveringItemID;
		}
		//抽奖物品数量
		private var m_DiscoveringItemNum:int=0;

		public function getDiscoveringItemNum():int
		{
			return m_DiscoveringItemNum
		}
		
		private var m_DiscoveringItemPos:int = 0;
		public function getDiscoveringItemPos():int
		{
			return m_DiscoveringItemPos;
		}
		
		//幸运度物品类型ID
		private var m_luckyItemID:int=0;

		public function getLuckyItemID():int
		{
			return m_luckyItemID;
		}

		//幸运度物品数量
		private var m_luckyItemNum:int=0;

		public function getLuckyItemNum():int
		{
			return m_luckyItemNum;
		}

		//幸运值
		private var m_lucky:int=0;

		public function getlucky():int
		{
			return m_lucky;
		}
		
		//表示幸运奖励是否可以领取 ，0 表示不能领取，1表示可以领取
		private var m_luckyFlag:int = 0;
		public function getLuckyFlag():int
		{
			return m_luckyFlag;
		}
		private var m_grade:int = 0;
		public function getGrade():int
		{
			return m_grade;
		}
		private var m_luckyLevel:int;
		public function getLuckyLevel():int
		{
			return m_luckyLevel;
		}

		//随机种子
		private var m_seed:int

		public function getSeed():int
		{
			return m_seed;
		}

		private function _responseSCDiscoveringTreasureInfo(p:IPacket):void
		{
			var _p:PacketSCDiscoveringTreasureInfo=p as PacketSCDiscoveringTreasureInfo;

//			if(0 != _p.tag)
//			{
//				Lang.showResult(_p);
//				return ;
//			}

			m_DiscoveringItemID=_p.itemid1;
			m_DiscoveringItemNum=_p.num1;
			m_luckyItemID=_p.itemid2;
			m_luckyItemNum=_p.num2;
			m_lucky=_p.lucky;
			m_luckyFlag = _p.flag;
			m_luckyLevel = _p.item2lvl;
			m_DiscoveringItemPos = _p.pos;
			m_grade = _p.grade;
			m_seed=_p.seed;

			var _e:XunBaoEvent=new XunBaoEvent(XunBaoEvent.XUN_BAO_EVENT);
			dispatchEvent(_e);
		}

		//---------------------------------------------------------------

		private var m_version:int=0;

		/**
		 * 全服寻宝史册
		 * @param version
		 * @param num
		 *
		 */
		public function requestCSDiscoveringTreasureLog(num:int):void
		{
			var _version:int=m_version;
			var _p:PacketCSDiscoveringTreasureLog=new PacketCSDiscoveringTreasureLog();
			_p.version=_version;
			_p.num=num;
			DataKey.instance.send(_p);
		}
		
		private var m_allInfo:Queue=new Queue(50);

		/**
		 * 获得所有 全服寻宝史册 数据
		 * @return
		 *
		 */
		public function getAllInfo():Array
		{
			return m_allInfo.getList();
		}
		
		private var m_heroInfo:Queue=new Queue(50);
		
		/**
		 * 获得 玩家 寻宝史册 数据
		 * @return
		 *
		 */
		public function getHeroInfo():Array
		{
			return m_heroInfo.getList();
		}

		private function _responseSCDiscoveringTreasureLog(p:IPacket):void
		{
			var _p:PacketSCDiscoveringTreasureLog=p as PacketSCDiscoveringTreasureLog;

			if (_p.version == m_version)
			{
				return;
			}

			m_version=_p.version;
			if (_p.arrItemlog.length <= 0)
			{
				return;
			}

			for (var i:int=0; i < _p.arrItemlog.length; ++i)
			{
				m_allInfo.add(_p.arrItemlog[i]);
			}


			var _e:XunBaoEvent=new XunBaoEvent(XunBaoEvent.XUN_BAO_EVENT);
			_e.sort=XunBaoEvent.ALL_INFO_EVENT_SORT;
			dispatchEvent(_e);
		}
		
		
		private function _responseSCDiscoveringTreasureHeroLog(p:IPacket):void
		{
			var _p:PacketSCDiscoveringTreasureHeroLog=p as PacketSCDiscoveringTreasureHeroLog;
			if (_p.arrItemlog.length <= 0)
			{
				return;
			}
			
			for (var i:int=0; i < _p.arrItemlog.length; ++i)
			{
				m_heroInfo.add(_p.arrItemlog[i]);
			}
			
			var _e:XunBaoEvent=new XunBaoEvent(XunBaoEvent.XUN_BAO_EVENT);
			_e.sort=XunBaoEvent.HERO_INFO_EVENT_SORT;
			dispatchEvent(_e);
		}

		//---------------------------------------------------------------

		/**
		 * 领取幸运度物品
		 *
		 */
		public function requestCSDrawLuckyItem():void
		{
			var _p:PacketCSDrawLuckyItem=new PacketCSDrawLuckyItem();
			DataKey.instance.send(_p);
		}

		private function _responseSCDrawLuckyItem(p:IPacket):void
		{
			var _p:PacketSCDrawLuckyItem=p as PacketSCDrawLuckyItem;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
		}

		//---------------------------------------------------------------

		/**
		 * 整理活动仓库
		 *
		 */
		public function requestCSTrimActBank():void
		{
			var _p:PacketCSTrimActBank=new PacketCSTrimActBank();
			DataKey.instance.send(_p);
		}

		private function _responseSCTrimActBank(p:IPacket):void
		{
			var _p:PacketSCTrimActBank=p as PacketSCTrimActBank;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
		}

		//---------------------------------------------------------------

		/**
		 * 活动仓库取出全部
		 *
		 */
		public function requestCSActBankTakeAll():void
		{
			var _p:PacketCSActBankTakeAll=new PacketCSActBankTakeAll();
			DataKey.instance.send(_p);
		}

		private function _responseSCActBankTakeAll(p:IPacket):void
		{
			var _p:PacketSCActBankTakeAll=p as PacketSCActBankTakeAll;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
		}

		//---------------------------------------------------------------

	}


}




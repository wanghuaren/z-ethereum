package model.yunying
{
	import common.managers.Lang;
	
	import engine.support.IPacket;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSGameTestVipInfo;
	import nets.packets.PacketCSGameVipBuy;
	import nets.packets.PacketCSGameVipData;
	import nets.packets.PacketCSGameVipPrize;
	import nets.packets.PacketCSGameVipTypePrizeNum;
	import nets.packets.PacketSCGameTestVipInfo;
	import nets.packets.PacketSCGameVipBuy;
	import nets.packets.PacketSCGameVipData;
	import nets.packets.PacketSCGameVipPrize;
	
	/*
	-----------------------------------------
	日期:2013-04-20
	-----------------------------------------
	技术部-叶俊 15:37:40
	<packet id="31026" name="CSGameVipBuy" desc="购买VIP特权时间" sort="1">
	<prop name="flag" type="3" length="0" desc="VIP特权类型1表示白银，2表示黄金，3表示至尊"/>
	</packet>
	<packet id="31027" name="SCGameVipBuy" desc="购买VIP特权时间返回" sort="2">
	<prop name="flag" type="3" length="0" desc="操作代码"/>
	
	<prop name="tag" type="3" length="0" desc="错误码"/>
	<prop name="msg" type="7" length="128" desc="错误信息"/>
	</packet>
	
	
	<packet id="31028" name="CSGameVipData" desc="获取VIP特权信息" sort="1">
	</packet>
	<packet id="31029" name="SCGameVipData" desc="获取VIP特权信息返回" sort="2">
	<prop name="VipType" type="3" length="0" desc="VIP特权类型1表示白银，2表示黄金，3表示至尊"/>
	<prop name="VipTypeEndDate" type="3" length="0" desc="VIP特权结束日期"/>
	<prop name="GiftState" type="3" length="0" desc="福利领取状态,1表示已领取，0表示尚未领取"/>
	</packet>
	
	
	<packet id="31030" name="CSGameVipPrize" desc="获取VIP特权礼包" sort="1">
	</packet>
	<packet id="31031" name="SCGameVipPrize" desc="获取VIP特权礼包返回" sort="2">
	<prop name="tag" type="3" length="0" desc="错误码"/>
	<prop name="msg" type="7" length="128" desc="错误信息"/>
	</packet>

	*/
	
	/**
	 * 至尊VIP
	 * @author steven guo
	 * 
	 */	
	public class ZhiZunVIPModel extends EventDispatcher
	{
		private static var m_instance:ZhiZunVIPModel;
		
		public function ZhiZunVIPModel(target:IEventDispatcher=null)
		{
			super(target);
			
			DataKey.instance.register(PacketSCGameVipBuy.id,_responseSCGameVipBuy);  
			DataKey.instance.register(PacketSCGameVipData.id,_responseSCGameVipData); 
			DataKey.instance.register(PacketSCGameVipPrize.id,_responseSCGameVipPrize); 
		}
		
		public static function getInstance():ZhiZunVIPModel
		{
			if(null == m_instance)
			{
				m_instance = new ZhiZunVIPModel();
			}
			
			return m_instance;
		}
		
		//--------------------------------------------------------------
		/**
		 * 购买VIP特权时间  
		 * @param type VIP特权类型1表示白银，2表示黄金，3表示至尊
		 * 
		 */		
		public function requestCSGameVipBuy(flag:int):void
		{
			var _p:PacketCSGameVipBuy = new PacketCSGameVipBuy();
			_p.flag = flag;
			DataKey.instance.send(_p);
		}
		
		private function _responseSCGameVipBuy(p:IPacket):void
		{
			var _p:PacketSCGameVipBuy = p as PacketSCGameVipBuy;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
			
//			var _e:ZhiZunVIPEvent = new ZhiZunVIPEvent(ZhiZunVIPEvent.ZHI_ZUN_VIP_EVENT);
//			dispatchEvent(_e);
			
			requestCSGameVipData();
			
		}
		
		//--------------------------------------------------------------
		
		/**
		 * 获取VIP特权信息
		 * 
		 */		
		public function requestCSGameVipData():void
		{
			//获取VIP类型礼包可领次数
			var p:PacketCSGameVipTypePrizeNum = new PacketCSGameVipTypePrizeNum();
			DataKey.instance.send(p);
			//获取体验VIP信息
			var p2:PacketCSGameTestVipInfo = new PacketCSGameTestVipInfo();
			DataKey.instance.send(p2);
			//获取VIP特权信息
			var _p:PacketCSGameVipData = new PacketCSGameVipData();
			DataKey.instance.send(_p);
			trace("--->请求获取vip特权信息");
		}
		
		private var m_PacketSCGameVipData:PacketSCGameVipData = null;
		public function getPacketSCGameVipData():PacketSCGameVipData
		{
			return m_PacketSCGameVipData;
		}
		
		public function _responseSCGameVipData(p:IPacket):void
		{
			var _p:PacketSCGameVipData = p as PacketSCGameVipData;
			
			m_PacketSCGameVipData = _p;
			
			trace("--->返回vip特权信息");
			var _e:ZhiZunVIPEvent = new ZhiZunVIPEvent(ZhiZunVIPEvent.ZHI_ZUN_VIP_EVENT);
			dispatchEvent(_e);
		}
		  
		//--------------------------------------------------------------
		
		/**
		 * 获取VIP特权礼包
		 * 
		 */		
		public function requestCSGameVipPrize():void
		{
			var _p:PacketCSGameVipPrize = new PacketCSGameVipPrize();
			DataKey.instance.send(_p);
		}
		
		public function _responseSCGameVipPrize(p:IPacket):void
		{
			var _p:PacketSCGameVipPrize = p as PacketSCGameVipPrize;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
			if(this.m_PacketSCGameVipData!=null){
				this.m_PacketSCGameVipData.GiftState = 1;
			}
			var _e:ZhiZunVIPEvent = new ZhiZunVIPEvent(ZhiZunVIPEvent.ZHI_ZUN_VIP_EVENT);
			_e.sort = -1;
			dispatchEvent(_e);
		}
		
		//--------------------------------------------------------------
	}
	
}











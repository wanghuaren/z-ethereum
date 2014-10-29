package model.smartimplement
{
	import flash.events.EventDispatcher;
	
	import engine.support.IPacket;
	
	/**
	 * 四神器模块
	 * @author steven guo
	 * 
	 */	
	public class SmartImplementModel extends EventDispatcher
	{ 
		
		/**
		 * 四神器副本完成列表 
		 */		
		private var m_finishList:Array;
		
		
		private static var m_instance:SmartImplementModel;
		
		public function SmartImplementModel()
		{
			_init();
		}
		
		public static function getInstance():SmartImplementModel
		{
			if(null == m_instance)
			{
				m_instance = new SmartImplementModel();
			}
			
			return m_instance;
		}
		
		
		private function _init():void
		{
			m_finishList = [];
			m_finishList[0] = 0;  // 玄黄剑
			m_finishList[1] = 0;  // 冰荒杖
			m_finishList[2] = 0;  // 九幽斧
			m_finishList[3] = 0;  // 长天弓
			
		}
		
		/**
		 * 获得四神器副本完成列表 
		 * @return 
		 * 
		 */		
		public function getFinishList():Array
		{
			return m_finishList;
		}
		
		/**
		 * 向服务器请求已经完成的 四神器副本 列表的进度 
		 * 
		 */		
		public function requestFinishList():void
		{
			
		}
		
		/**
		 * 服务器返回查询结果 
		 * @param p
		 * 
		 */		
//		private function _responseFinishList(p:IPacket):void
//		{
//			
//		}
		
		
		/**
		 * 剩余怪物数量   (冰荒杖 副本消息) 
		 * @param p
		 * 
		 */		
//		private function _notifyRemaind(p:IPacket):void
//		{
//			
//		}
		
		/**
		 * 副本剩余时间   (九幽斧 副本消息)
		 * @param p
		 * 
		 */		
//		private function _notifyRemaindTime(p:IPacket):void
//		{
//			
//		}
		
		/**
		 * 剩余怪物波数  (长天弓副本消息) 
		 * @param p
		 * 
		 */		
//		private function _notifyRemaindGroup(p:IPacket):void
//		{
//			
//		}
		
		/**
		 * 已经通过怪物个数  (长天弓副本消息) 
		 * @param p
		 * 
		 */		
//		private function _notifyCrossNum(p:IPacket):void
//		{
//			
//		}
		
		/**
		 * 请求某个4神器副本
		 * 
		 */		
		public function requestCSInstanceRank():void
		{
			
		}
		
	}
	
}






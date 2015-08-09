package scene.action.hangup
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import nets.packets.PacketCSPick;
	
	/**
	 * 挂机的辅助工具
	 * @author steven guo
	 * 
	 */	
	public class HangupHelper
	{
		//最高捡取次数
		private static const MAX_PICK_TIMES:int = 1000;
		
		//通过一个距离定义什么是 “远” ，什么是 “近”  (像素值)
		private static const FAR_PICK_DISTANCE:int = 500;//  distance:int = 300;//   isTooFarPick
		
		//记录捡取某个obj对象的列表
		private var m_pickObjList:Array;
		
		//帮助记录列表中的数量,如果超过某个长度就清空一下
		private var m_pickObjListLength:int;
		
		//列表最大长度
		private static const MAX_PICK_OBJ_LIST_LENGTH:int = 200;
		
		
		public function HangupHelper(md:*)
		{
			//m_model = md;
			m_pickObjList = [];
		}
		
		
		private var m_kingPoint:Point;
		private var m_targetPoint:Point;
		
		/**
		 * 判断捡取某个物品的距离是否太远了。 
		 * @param cX              当前玩家的位置 x
		 * @param cY			  当前玩家的位置   y
		 * @param targetX         捡取目标 x
		 * @param targetY         捡取目标 y
		 * @return                true ： 太远了， false ： 不远
		 * 
		 */		
		public function isTooFarPick(cX:int,cY:int,targetX:int,targetY:int):Boolean
		{
			if(null == m_kingPoint)
			{
				m_kingPoint = new Point();
			}
			
			if(null ==  m_targetPoint)
			{
				m_targetPoint = new Point();
			}
			
			m_kingPoint.x = cX;
			m_kingPoint.y = cY;
			
			m_targetPoint.x = targetX;
			m_targetPoint.y = targetY;
			
			
			if( FAR_PICK_DISTANCE >= Point.distance(m_kingPoint,m_targetPoint) )
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * 判断捡取某个物品的次数是不是太多了。
		 * @param packet
		 * @return 
		 * 
		 */		
		public function isTooMuchPick(objID:int):Boolean
		{
			var _ret:Boolean = false;
			
			//_addPickObj(objID);
			
			if(MAX_PICK_TIMES <= _getPickObjTimes(objID))
			{
				_ret = true;
			}
			
			return _ret;
		}
		
		public function addPickObj(objID:int , times:int = 1):void
		{
			_addPickObj(objID,times);
		}
		
		/**
		 * 添加一个obj对象 
		 * @param objID
		 * @param num
		 * 
		 */		
		private function _addPickObj(objID:int , times:int = 1):void
		{
			if(null == m_pickObjList[objID])
			{
				m_pickObjList[objID] = times;
				
				++m_pickObjListLength;
				
				//当大于最高长度的时候清空一次
				if(m_pickObjListLength >= MAX_PICK_OBJ_LIST_LENGTH)
				{
					m_pickObjList = [];
					m_pickObjListLength = 0;
				}
			}
			else
			{
				m_pickObjList[objID] +=times;
			}
		}
		
		private function _getPickObjTimes(objID:int):int
		{
			var _ret:int = 0;
			if(null != m_pickObjList[objID])
			{
				_ret = m_pickObjList[objID]
			}

			return _ret;
		}
		
		/**
		 * 是否从服务器请求 太频繁
		 * @return 
		 * 
		 */		
		private var m_time:int;
		private var m_lastTime:int = -1;
		public function isTooMuchPlugInsPos():Boolean
		{
			m_time = getTimer();
			var _tTime:int = 0;
			_tTime = m_time - m_lastTime;
			
			if(_tTime >= 6000)
			{
				m_lastTime = m_time;
				return false;
			}
			
			return true;
		}
		private var m_time2:int;
		private var m_lastTime2:int = -1;
		public function isTooMuchMonsterPos():Boolean
		{
			m_time2 = getTimer();
			var _tTime:int = 0;
			_tTime = m_time2 - m_lastTime2;
			
			if(_tTime >= 3000)
			{
				m_lastTime2 = m_time2;
				return false;
			}
			
			return true;
		}	
	}
}




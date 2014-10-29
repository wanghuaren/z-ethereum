package ui.frame
{
	import ui.view.QBShengJiHuoDe;

	/**
	 * 游戏右下角的提示窗口 管理器
	 *  
	 * @author steven guo
	 * 
	 */	
	public class RightDownTipManager
	{
		private static var m_instance:RightDownTipManager ;
		
		/**
		 * 对象池数量 
		 */		
		private static const TIP_POOL_SIZE:int = 10;
		
		/**
		 * 当前 装备 对象的索引 
		 */		
		private var m_index_zb:int;
		
		/**
		 * 当前 礼包 对象的索引 
		 */		
		private var m_index_lb:int;
		
		/**
		 * 当前 技能书 对象的索引 
		 */		
		private var m_index_jns:int;
		
		/**
		 * 当前 QB 升级奖励对象索引 
		 */		
		private var m_index_qb:int;
		
		
		/**
		 * 装备 对象池列表 
		 */		
		private var m_list_zb:Array;
		
		/**
		 * 礼包 对象池列表 
		 */		
		private var m_list_lb:Array;
		
		/**
		 * 技能书 对象池列表 
		 */		
		private var m_list_jns:Array;
		
		/**
		 * 升级获得QB对象列表 
		 */		
		private var m_list_QB:Array;
		
		
		public function RightDownTipManager()
		{
			_init();
		}
		
		/**
		 * 初始化函数 
		 * 
		 */		
		private function _init():void
		{
			if(null == m_list_zb)
			{
				m_list_zb = [];
				m_index_zb = 0;
				
				for(var i:int = 0 ; i<TIP_POOL_SIZE ; ++i)
				{
					m_list_zb[i] = new RightDownTipZB();
				}
			}
			
			if(null == m_list_lb)
			{
				m_list_lb = [];
				m_index_lb = 0;
				
				for(var n:int = 0 ; n<TIP_POOL_SIZE ; ++n)
				{
					m_list_lb[n] = new RightDownTipLB();
				}
			}
			
			if(null == m_list_jns)
			{
				m_list_jns = [];
				m_index_jns = 0;
				
				for(var m:int = 0 ; m<TIP_POOL_SIZE ; ++m)
				{
					m_list_jns[m] = new RightDownTipJNS();
				}
			}
			
			if(null == m_list_QB)
			{
				m_list_QB = [];
				m_index_qb = 0;
				
				for(var h:int = 0 ; h<TIP_POOL_SIZE ; ++h)
				{
					m_list_QB[h] = new QBShengJiHuoDe();
				}
			}
			
		}
		
		public static function getInstance():RightDownTipManager
		{
			if(null  ==  m_instance)
			{
				m_instance = new RightDownTipManager();
			}
			
			return m_instance;
		}
		
		
		/**
		 * 获得一个装备 对象实例 。 从内存池中获得 
		 * @return 
		 * 
		 */	
		public function getOneTipZB():RightDownTip
		{
			var _ret:RightDownTip = null;
			
			_ret = m_list_zb[m_index_zb] as RightDownTipZB ; 
			_ret.close();
			
			++m_index_zb;
			if(m_index_zb >= TIP_POOL_SIZE)
			{
				m_index_zb = 0;
			}
			
			return _ret;
		}
		
		/**
		 * 获得一个礼包  对象实例 。 从内存池中获得 
		 * @return 
		 * 
		 */	
		public function getOneTipLB():RightDownTip
		{
			var _ret:RightDownTip = null;
			
			_ret = m_list_lb[m_index_lb] as RightDownTipLB ; 
			_ret.close();
			
			++m_index_lb;
			if(m_index_lb >= TIP_POOL_SIZE)
			{
				m_index_lb = 0;
			}
			
			return _ret;
		}
		
		
		/**
		 * 获得一个技能书  对象实例 。 从内存池中获得  
		 * @return 
		 * 
		 */		
		public function getOneTipJNS():RightDownTip
		{
			var _ret:RightDownTip = null;
			
			_ret = m_list_jns[m_index_jns] as RightDownTipJNS ; 
			_ret.close();
			
			++m_index_jns;
			if(m_index_jns >= TIP_POOL_SIZE)
			{
				m_index_jns = 0;
			}
			
			return _ret;
		}
	}	
}
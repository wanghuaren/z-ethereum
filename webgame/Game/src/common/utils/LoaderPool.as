package common.utils
{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;

	/**
	 * 提供一个 UILoader 的对象池
	 * @author steven guo
	 * 
	 */	
	public class LoaderPool
	{
		//最大loader个数
		private static const MAX_NUM:int = 20;
		
		private static var m_instance:LoaderPool;
		
		private var m_pool:Array;
		
		private var m_cIndex:int;
		
		
		public function LoaderPool()
		{
			m_pool = [];
		}
		
		public static function getInstance():LoaderPool
		{
			if(null == m_instance)
			{
				m_instance = new LoaderPool();
			}
			
			return m_instance;
		}
		
		
		public function getOne():Loader
		{
			var _ret:Loader ;
			
			if(m_cIndex >= MAX_NUM)
			{
				m_cIndex = 0;
			}
			
			if(null == m_pool[m_cIndex])
			{
				m_pool[m_cIndex] = new Loader();
				
			}
			
			_ret = m_pool[m_cIndex];
			
			//_clean(_ret);
			
			return _ret;
		}
		
//		private function _clean(display:DisplayObject):void
//		{
//			
//		}
	}
}




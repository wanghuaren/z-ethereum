package scene
{
	/**
	 * 场景策略，用于优化游戏场景性能
	 * @author steven guo
	 * 
	 */	
	public class SceneTactics
	{
		private static var m_instance:SceneTactics;
		
		/**
		 * 一个周期内最大战斗数量 
		 */		
		public static const FIGHT_ACTION_NUM_MAX:int = 3;
		
		/**
		 * 一个周期内D1最大动画数量 
		 */		
		public static const D1_MOVIE_NUM_MAX:int = 20;
		
		/**
		 * 一个周期内D2最大动画数量 
		 */		
		public static const D2_MOVIE_NUM_MAX:int = 5;
		
		/**
		 * 当前周期已经播放战斗数量 
		 */		
		private var m_fightActionNum:int;
		
		/**
		 * 当前周期已经播放D1动画数量 
		 */	
		private var m_d1MovieNum:int;
		
		/**
		 * 当前周期已经播放动画数量 
		 */	
		private var m_d2MovieNum:int;
		
		public function SceneTactics()
		{
			m_fightActionNum = 0;
			m_d1MovieNum = 0;
			m_d2MovieNum = 0;
		}
		
		public static function getInstance():SceneTactics
		{
			if(null == m_instance)
			{
				m_instance = new SceneTactics();
			}
			
			return m_instance;
		}
		
		/**
		 * 在每个周期开始的时候需要重置所有数值
		 * 
		 */		
		public function reset():void
		{
			m_fightActionNum = 0;
			m_d1MovieNum = 0;
			m_d2MovieNum = 0;
		}
		
		/**
		 * 获得 当前周期已经播放战斗数量 
		 * @return 
		 * 
		 */		
		public function getFightActionNum():int
		{
			return m_fightActionNum;
		}
		
		/**
		 * 增加 当前周期已经播放战斗数量 
		 * @param num
		 * 
		 */		
		public function addFightActionNum(num:int = 1):void
		{
			m_fightActionNum += num;
		}
		
		
		public function getD1MovieNum():int
		{
			return m_d1MovieNum;
		}
		
		public function addD1MovieNum(num:int = 1):void
		{
			m_d1MovieNum += num;
		}
		
		public function getD2MovieNum():int
		{
			return m_d2MovieNum;
		}
		
		public function addD2MovieNum(num:int = 1):void
		{
			m_d2MovieNum += num;
		}
	}
}
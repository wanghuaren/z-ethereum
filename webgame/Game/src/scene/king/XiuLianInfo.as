package scene.king
{
	public class XiuLianInfo
	{		
		/**
		 * 是否正在修炼
		 * 根据角色的roleZT来判断
		 */
		
		
		/**
		 * 已修炼时间 ，单位：秒
		 */		
		private var _exercisingSec:int;
		
		/**
		 * 修炼中获得的经验
		 */ 
		private var _exercisingExp:int;
		
		/**
		 * 需要累加的exp，使用后清零
		 */
		private var _cumulateExp:int;
		
		private var _cumulateExpByPanel:int;
		
		
		/**
		 * 需要累加的sec，使用后清零
		 */ 
		private var _cumulateSec:int;
		
		
		
		/**
		 * 发送指令锁
		 */
		private var _CSExerciseLock:Boolean = false;
		
		public function XiuLianInfo()
		{
			
		}
		
		//
		public function get cumulateExp():int
		{
			return _cumulateExp;
		}
		
		public function get cumulateSec():int
		{
			return _cumulateSec;
		}

		/**
		 * @private
		 */
		public function get exercisingSec():int
		{
			_exercisingSec = _exercisingSec + useCumulateSec();
			return _exercisingSec;
		}
		
		/**
		 * @private
		 */
		public function get exercisingExp():int
		{			
			_exercisingExp = _exercisingExp + useCumulateExp();
			
			return _exercisingExp;
		}
		
		/**
		 * @private
		 */
		public function set exercisingSec(value:int):void
		{
			_exercisingSec = value;
		}
		
		public function set exercisingExp(value:int):void
		{			
			_exercisingExp = value;
		}
		
		public function useCumulateExp():int
		{
			var value:int = _cumulateExp;
			_cumulateExp = 0;
			
			return value;
		}
		
		public function useCumulateSec():int
		{
			var value:int = _cumulateSec;
			_cumulateSec = 0;
			
			return value;
		}
		
		public function set cumulateExp(value:int):void
		{
			_cumulateExp = value;
		}
		
		public function set cumulateExpByPanel(value:int):void
		{
			_cumulateExpByPanel = value;
		}
		
		public function useCumulateExpByPanel():int
		{
			var value:int = _cumulateExpByPanel;
			_cumulateExpByPanel = 0;
			
			return value;
		}
		
		
		public function set cumulateSec(value:int):void
		{
			_cumulateSec = value;
		}
		
		
		
		
		
		
		
		

		//
		public function get CSExerciseLock():Boolean
		{
			return _CSExerciseLock;
		}

		public function set CSExerciseLock(value:Boolean):void
		{
			_CSExerciseLock = value;
		}

		
		
		

	}
}
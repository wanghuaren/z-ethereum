package netc.dataset
{
	public class MoTianStepInfo
	{
		/**
		 * 大地图开启
		 */ 
		public var step:int;
		
		/**
		 * 打到了第几个怪
		 */ 
		public var level:int;
		
		public function MoTianStepInfo()
		{
			step = 0;
			level = 0;			
		}
		
		public function get isComplete():Boolean
		{
			if(this.level >= 7)
			{
				return true;
			}
			
			return false;
		
		}
		
		
	}
}
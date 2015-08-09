package netc.dataset
{
	import com.engine.utils.HashMap;
	

	public class MoTianInfo
	{
		private var _stepList:HashMap;
		
		public var resetnum:int;		
		public var req_step:int;
		public var star:int;
				
		public function MoTianInfo(steps_num:int)
		{		
			//
			_stepList = new HashMap();
			
			for(var i:int =0;i<=steps_num;i++)
			{
				_stepList.put(i,new MoTianStepInfo());			
			}
			
			//
			resetnum = 0;
			req_step = 0;
			star = 0;
		
		}
		
		public function mapStep(myLvl:int,STEPS_OPEN_LVL:Array):int
		{
			
			//
			var len:int = STEPS_OPEN_LVL.length;
			var _mapStep:int = 0;	
			
			for(var i:int = 0; i < len; i++)
			{
				if(myLvl >= STEPS_OPEN_LVL[i])
				{
					_mapStep = i;
				}			
			}
		
			return _mapStep;
		}
		
		/**
		 * 
		 */
		public function get stepList():HashMap
		{
			return _stepList;
		}

	}
}
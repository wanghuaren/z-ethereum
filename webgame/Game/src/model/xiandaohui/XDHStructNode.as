package model.xiandaohui
{
	import netc.packets2.StructServerPlayerPkInfo2;

	public class XDHStructNode
	{
		public var child0:XDHStructNode = null;
		public var child1:XDHStructNode = null;
		public var parent:XDHStructNode = null;
		public var index:int = 0;
		public var level:int = 0;
		public var winner:StructServerPlayerPkInfo2 = null;
		
		// 用 0  和 1 来表示
		public var winLorR:int = 0; 
		
		//仅仅表示该节点的3种状态:比赛前 ,比赛中,比赛后
		private var status:int = XDHModel.TIMESTEP_SUB_1; 
		
		
		public function getStatus():int
		{
			var _ret:int = XDHModel.TIMESTEP_SUB_1; 

			var _stepMain:int = XDHModel.getInstance().getTimeStepMain();
			var _stepSub:int = XDHModel.getInstance().getTimeStepSub();
			
			var _lv:int = _levelToTimeStepMain(level);
			
			if(-1 == _lv)
			{
				return XDHModel.TIMESTEP_SUB_3;
			}
			else if( _lv == _stepMain )
			{
				return XDHModel.getInstance().getTimeStepSub();
			}
			else if(_lv > _stepMain)
			{
				return XDHModel.TIMESTEP_SUB_1;
			}
			else if(_lv < _stepMain)
			{
				return XDHModel.TIMESTEP_SUB_3;
			}
			
			return _ret;
		}
		
		public function levelToTimeStepMain(lv:int):int
		{
			return _levelToTimeStepMain(lv);
		}
	
	
		private function _levelToTimeStepMain(lv:int):int
		{
			if(0 == lv)
			{
				return XDHModel.TIMESTEP_MAIN_5;
			}
			else if(1 == lv)
			{
				return XDHModel.TIMESTEP_MAIN_4;
			}
			else if(2 == lv)
			{
				return XDHModel.TIMESTEP_MAIN_3;
			}
			else if(3 == lv)
			{
				return XDHModel.TIMESTEP_MAIN_2;
			}
			else if(4 == lv)
			{
				return XDHModel.TIMESTEP_MAIN_1;
			}
			else if(5 == lv)
			{
				return 0;
			}
			
			return 0;
		}
		
		
	}
	
}








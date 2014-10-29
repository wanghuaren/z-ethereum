package netc.dataset
{
	public class BeatBackInfo
	{
		private var _idleSec:int;
		
		private var _objid:int;
		
		public function BeatBackInfo(objid_:int)
		{
			_objid = objid_;
			_idleSec =0 ;
		}
		
		public function get objid():int
		{
			return _objid;
		}

		public function get idleSec():int
		{
			return _idleSec;
		}
		
		public function idleSecAdd():void
		{
			_idleSec++;
		}
		
		public function idleSecReset():void
		{
			_idleSec = 0;
		}
		
		public function isCanDel():Boolean
		{
			if(_idleSec >= 180)
			{
				return true;
			}
			
			return false;
			
		}
		
	}
}
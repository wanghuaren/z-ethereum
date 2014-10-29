package scene.king
{
	public class SoulInfo
	{
		private var _objid:int;
		
		private var _monsterid:int;
		
		private var _soul:int;
		
			
		public function SoulInfo(objid_:int,monsterid_:int,soul_:int)
		{
			this._objid = objid_;
			
			this._monsterid = monsterid_;
			
			this._soul = soul_;
			
		}
		
		

		/**
		 * screen唯一标识
		 */
		public function get objid():int
		{
			return _objid;
		}
		
		public function get monsterid():int
		{
			return _monsterid;
		}
		
		public function get soul():int
		{
			return _soul;
		}
		
		
		
		
		
		
		
		
		
		
	}
}
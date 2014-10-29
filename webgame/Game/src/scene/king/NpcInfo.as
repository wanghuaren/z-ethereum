package scene.king
{
	public class NpcInfo
	{
		private var _objid:int;
		
		private var _dbid:int;
		
		
		
		public function NpcInfo(objid_:int,dbid_:int)
		{
			this._objid = objid_;
			
			this._dbid = dbid_;
			
		}

		/**
		 * npcId
		 */
		public function get dbid():int
		{
			return _dbid;
		}
		
		/**
		 * screen唯一标识
		 */
		public function get objid():int
		{
			return _objid;
		}

	}
}
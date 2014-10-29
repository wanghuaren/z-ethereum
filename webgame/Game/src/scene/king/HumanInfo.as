package scene.king
{
	public class HumanInfo
	{
		private var _objid:int;
		
		
		private var _outlook:int;
		
		
		private var _rolename:String;
		
		
		private var _level:int;
		
		private var _teamid:int;
		
		private var _teamleader:int;
		
		private var _metier:int;
		
		public function HumanInfo(objid_:int,
								  outlook_:int,
								  rolename_:String,
								  level_:int,
								  teamid_:int,
								  teamleader_:int,
								  metier_:int)
		{
			this._objid = objid_;
			
			this._outlook = outlook_;
			
			this._rolename = rolename_;
			
			this._level = level_;
			
			this._teamid = teamid_;
			
			this._teamleader = teamleader_;
			
			this._metier = metier_;
		}
		
		public function get level():int
		{
			return _level;
		}

		public function get rolename():String
		{
			return _rolename;
		}

		/**
		 * npcId，同时也是外观
		 */		
		public function get outlook():int
		{
			return _outlook;
		}
		
		/**
		 * screen唯一标识
		 */
		public function get objid():int
		{
			return _objid;
		}
		
		public function get teamid():int
		{
			return _teamid;
		}
		

		
		public function get teamleader():int
		{
			return _teamleader;
		}
		
		public function get metier():int
		{
			return _metier;
		}
		
		
		
	}
}
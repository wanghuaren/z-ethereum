package scene.king
{
	public class ResInfo extends NpcInfo
	{
		private var _taskid:String;
		private var _taskstep:int;
		public function ResInfo(objid_:int,dbid_:int,taskid:String,taskstep:int)
		{
			super(objid_,dbid_);
			this._taskid = taskid;
			this._taskstep = taskstep;
		}

		public function get taskstep():int
		{
			return _taskstep;
		}

		/**
		 * 采集对应任务id
		 */
		public function get taskid():String
		{
			return _taskid;
		}
	}
}
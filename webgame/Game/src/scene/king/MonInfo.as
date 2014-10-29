package scene.king
{
	public class MonInfo
	{
		private var _objid:int;
		
		public function MonInfo()
		{
		}
		
		/**
		 * screen唯一标识
		 */
		public function get objid():int
		{
			return _objid;
		}
		
		public function set objid(value:int):void
		{
			_objid = value;
		}
	}
}
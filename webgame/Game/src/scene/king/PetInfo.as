package scene.king
{
	public class PetInfo
	{
		private var _objid:int;
		
		public function PetInfo()
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
package scene.king
{
	/**
	 * this.king属于被采集的物品，且正在被采集中
	 */
	public class ByPickInfo
	{
		/**
		 * this.king属于被采集的物品，且正在被采集中
		 */ 
		private var _byPicking:Boolean;
		
		public function ByPickInfo()
		{
			_byPicking = false;
		}

		/**
		 * this.king属于被采集的物品，且正在被采集中
		 */
		public function get picking():Boolean
		{
			return _byPicking;
		}

		/**
		 * this.king属于被采集的物品，且正在被采集中
		 */
		public function set picking(value:Boolean):void
		{
			_byPicking = value;
		}

	}
}
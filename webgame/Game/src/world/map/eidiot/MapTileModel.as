package world.map.eidiot{
	import world.map.starts.IMapTileModel;
	public class MapTileModel implements IMapTileModel {
		private var m_map : Array;

		/**
		 * 优化，提前存储结果
		 */ 
		private var mapWidth : int;
		private var mapHeight : int;
		
		public function MapTileModel() {

		}
		
		public function get map():Array {
			return this.m_map;
		}
		
		public function set map(p_value : Array):void {
			this.m_map = p_value;
			//优化，提前存储结果
			mapWidth   = this.m_map.length;
			mapHeight  = this.m_map[0].length;
		}
		
		/**
		 * 这个地方调用非常频繁
		 */ 
		public function isBlock(p_startX : int, p_startY : int, p_endX : int, p_endY : int):int {
			//var mapWidth : int = this.m_map.length;
			//var mapHeight : int = this.m_map[0].length;

			//if (p_endX < 0 || p_endX == mapWidth || p_endY < 0 || p_endY == mapHeight) {
			if (p_endX < 0 || p_endX >= mapWidth || p_endY < 0 || p_endY >= mapHeight) {
				return 0;
			}
			if (this.m_map[p_endX][p_endY]>=1) {
				return 1;
			} else {
				return 0;
			}
		}
	}
}
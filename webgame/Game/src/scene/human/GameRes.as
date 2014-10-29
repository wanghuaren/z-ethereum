package scene.human
{
	import scene.king.King;
	
	
	public class GameRes extends King
	{

		private var _distance:int;
		private var _needtime:int;
		private var _cursor:int;
		private var _intonate_desc:String;//采集描述

		public function get intonate_desc():String
		{
			return _intonate_desc;
		}

		public function set intonate_desc(value:String):void
		{
			_intonate_desc = value;
		}

		/** 
		 *鼠标指针id
		 */
		public function get cursor():int
		{
			return _cursor;
		}

		/**
		 * @private
		 */
		public function set cursor(value:int):void
		{
			_cursor = value;
		}

		/** 
		 *操作时间
		 */
		public function get needtime():int
		{
			return _needtime;
		}

		/**
		 * @private
		 */
		public function set needtime(value:int):void
		{
			_needtime = value;
		}

		/** 
		 *操作距离
		 */
		public function get distance():int
		{
			return _distance;
		}

		/**
		 * @private
		 */
		public function set distance(value:int):void
		{
			_distance = value;
		}

		public function GameRes()
		{
			
		}
	}
}
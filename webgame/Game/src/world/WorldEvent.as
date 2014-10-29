package world
{
	import flash.events.Event;
		
	public class WorldEvent extends Event
	{
		/**
		 * 地图Alchemy寻路数据文件加载和分析完成
		 */ 
		public static const PATHR_FILE_PARSE_COMPLETE:String = "pathrFileParseComplete";
		
		/**
		 * 1秒事件发生
		 */ 
		public static const CLOCK_SECOND:String = "clockSecond";
		/**
		 * 2秒事件发生
		 */ 
		public static const CLOCK_TWO_SECOND:String = "clockTwoSecond";
		
		/**
		 * 5秒事件发生
		 */ 
		public static const CLOCK_FIVE_SECOND:String = "clockFiveSecond";
		
		/**
		 * 10秒事件发生 
		 */		
		public static const CLOCK_TEN_SECOND:String = "clockTenSecond";
		/**
		 * 30秒事件发生 
		 */		
		public static const CLOCK_THIRTY_SECOND:String = "clockThirtySecond";
		
		/**
		 * 半秒事件发生
		 */ 
		public static const CLOCK_HALF_OF_SECOND:String = "clockHalfOfSecond";
		
		/**
		 * 400毫秒事件发生
		 */ 
		public static const CLOCK__SECOND400:String = "clockSecond400";
		
		/**
		 * 200毫秒事件发生
		 */ 
		public static const CLOCK__SECOND200:String = "clockSecond200";
		
		/**
		 * 100毫秒事件发生
		 */ 
		public static const CLOCK__SECOND100:String = "clockSecond100";
		/**
		 * 帧频同步事件发生
		 */ 
		public static const CLOCK__:String = "clock";
		
		/**
		 * 进度事件发生
		 */ 
		public static const PROGRESS_HAND:String = "progressHand";
		
		/**
		 * 某事件完成
		 */ 
		public static const COMPLETE_HAND:String = "completeHand";
		
		/**
		 * 加载失败，且是io error
		 */ 
		public static const IOERROR_HAND:String = "ioErrorHand";
		
		/**
		 * 数值变化
		 */ 
		public static const VALUE_CHANGED:String = "valueChanged";
		
		//地图数据加载完成
		public static const MapDataComplete : String = "MapDataComplete";
				
		/**
		 * 实例属性
		 */ 
		public var data:*;
		
		public static const WORLD_EVENT:String = "WORLD_EVENT";
		
		public function WorldEvent(type:String,data:*=null)
		{
			var bubbles:Boolean=false;
			var cancelable:Boolean=false;
			
			super(type,bubbles,cancelable);
			
			this.data = data;
		}
		
		override public function clone():Event
		{
			return new WorldEvent(WorldEvent.WORLD_EVENT);
		}
		
		
	}
}
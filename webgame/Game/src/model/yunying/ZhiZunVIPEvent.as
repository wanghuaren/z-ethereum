package model.yunying
{
	import flash.events.Event;
	
	public class ZhiZunVIPEvent extends Event
	{
		public static const ZHI_ZUN_VIP_EVENT:String = "ZHI_ZUN_VIP_EVENT";
		
		//默认消息
		public static const DEFAULT_EVENT_SORT:int = 0;
		
		//消息类型
		private var m_sort:int = ZhiZunVIPEvent.DEFAULT_EVENT_SORT;
		
		
		public function ZhiZunVIPEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function set sort(s:int):void
		{
			m_sort = s;
		}
		
		public function get sort():int
		{
			return m_sort;
		}
		
		override public function clone():Event
		{
			return new ZhiZunVIPEvent(ZhiZunVIPEvent.ZHI_ZUN_VIP_EVENT);
		}
		
	}
	
}


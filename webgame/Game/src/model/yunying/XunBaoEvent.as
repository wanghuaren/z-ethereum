package model.yunying
{
	import flash.events.Event;
	
	public class XunBaoEvent extends Event
	{
		public static const XUN_BAO_EVENT:String = "XUN_BAO_EVENT";
		
		//默认消息
		public static const DEFAULT_EVENT_SORT:int = 0;
		
		//全服消息更新
		public static const ALL_INFO_EVENT_SORT:int = 1;
		
		//个人消息更新
		public static const HERO_INFO_EVENT_SORT:int = 2;
		
		//消息类型
		private var m_sort:int = XunBaoEvent.DEFAULT_EVENT_SORT;
		
		
		public function XunBaoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new XunBaoEvent(TianJianBaoXiangEvent.TIAN_JIANG_BAO_XIANG_EVENT);
		}
	}
}
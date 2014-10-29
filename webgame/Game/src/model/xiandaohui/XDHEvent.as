package model.xiandaohui
{
	import flash.events.Event;
	
	public class XDHEvent extends Event
	{
		public static const XDH_EVENT:String = "XDH_EVENT";
		
		public static const XDH_EVENT_SORT_DEFAULT:int = 0;
		
		//支持消息
		public static const XDH_EVENT_SORT_ZHICHI:int = 1;
		//服务器返回押注情况
		public static const XDH_EVENT_SORT_YAZHU:int = 2;
		

		public static const XDH_EVENT_SORT_PK_COST:int = 30;
		
		public static const XDH_EVENT_SORT_PK_ALL_GAMBLE:int = 31;
		
		public static const XDH_EVENT_SORT_PK_SELF_INFO:int = 32;
		
		public static const XDH_EVENT_SORT_PK_RESULT:int = 33;

		private var m_sort:int = XDHEvent.XDH_EVENT_SORT_DEFAULT;
		
		public var data:*;
		
		
		public function XDHEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new XDHEvent(XDHEvent.XDH_EVENT);
		}
		
		
	}
	
	
}



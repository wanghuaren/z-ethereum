package model.qq
{
	import flash.events.Event;
	
	
	/**
	 * QQ 黄钻礼包事件
	 * @author steven guo
	 * 
	 */	
	public class YellowDiamondEvent extends Event
	{
		//QQ 黄钻礼包事件消息
		public static const QQ_YELLOW_DIAMOND_EVENT:String = "QQ_YELLOW_DIAMOND_EVENT";
		
		//默认QQ 黄钻礼包事件消息
		public static const QQ_YELLOW_DIAMOND_EVENT_SORT:int = 0;
		
		//消息类型
		private var m_sort:int = YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT_SORT;
		
		public function YellowDiamondEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new YellowDiamondEvent(YellowDiamondEvent.QQ_YELLOW_DIAMOND_EVENT);
		}
		
	}
	
	
}
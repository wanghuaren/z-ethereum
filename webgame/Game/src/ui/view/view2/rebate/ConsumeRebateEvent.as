package ui.view.view2.rebate
{
	import flash.events.Event;
	
	public class ConsumeRebateEvent extends Event
	{
		
		//消息
		public static const CONSUME_REBATE_EVENT:String = "CONSUME_REBATE_EVENT";
		
		//默认消息类型
		public static const CONSUME_REBATE_EVENT_SORT:int = 0;
		
		//消息类型
		private var m_sort:int = ConsumeRebateEvent.CONSUME_REBATE_EVENT_SORT;
		
		
		public function ConsumeRebateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new ConsumeRebateEvent(ConsumeRebateEvent.CONSUME_REBATE_EVENT);
		}
		
	}
}
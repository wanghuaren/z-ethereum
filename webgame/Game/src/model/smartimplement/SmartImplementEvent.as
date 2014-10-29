package model.smartimplement
{
	import flash.events.Event;
	
	
	/**
	 * 四神器副本模块 发出的 事件消息
	 * @author steven guo
	 * 
	 */	
	public class SmartImplementEvent extends Event
	{
		//消息类型定义 
		public static const SMART_IMPLEMENT_EVENT:String = "SMART_IMPLEMENT_EVENT";
		
		
		public function SmartImplementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new SmartImplementEvent(SmartImplementEvent.SMART_IMPLEMENT_EVENT);
		}
		
	}
	
	
}



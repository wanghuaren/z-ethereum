package model.jingjie
{
	import flash.events.Event;
	
	/**
	 * 境界消息
	 * @author steven guo
	 * 
	 */	
	public class JingJieEvent extends Event
	{
		//PK赛消息
		public static const JING_JIE_EVENT:String = "JING_JIE_EVENT";
		
		public function JingJieEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new JingJieEvent(JingJieEvent.JING_JIE_EVENT);
		}
	}
}
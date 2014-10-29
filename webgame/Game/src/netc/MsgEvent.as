package netc
{
	import flash.events.Event;
	
	public class MsgEvent extends Event
	{
		public static const MSG_EVENT:String = "MSG_EVENT";
		
		public static const MSG_EVENT_DATA_REFRESH:String = "dataRefresh";
		
		public static const MSG_EVENT_NUM_REFRESH:String = "numRefresh";
		
		public var data:*;
		
		public function MsgEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,data:*=null)
		{
			super(type,bubbles,cancelable);
			
			this.data = data;
		}
		
		
		override public function clone():Event
		{
			return new MsgEvent(MsgEvent.MSG_EVENT);
		}
		
		
	}
}
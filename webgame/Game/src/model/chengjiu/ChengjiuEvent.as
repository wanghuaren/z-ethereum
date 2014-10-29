package model.chengjiu
{
	import common.config.xmlres.server.Pub_AchievementResModel;
	
	import flash.events.Event;
	
	public class ChengjiuEvent extends Event
	{
		public static const CHENG_JIU_EVENT:String = "CHENG_JIU_EVENT";
		
		public static const CHENG_IUE:int = 0; 
		public static const CHENG_IUE_UPDATA:int = 1; 
		public static const CHENG_NEW_COMPLETE:int = 2; 
		public static const SET_MAIN_JIEMIAN:int = 3; 
		
		//消息类型
		private var m_sort:int = ChengjiuEvent.CHENG_IUE;
		public function ChengjiuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get sort():int
		{
			return m_sort;
		}

		public function set sort(value:int):void
		{
			m_sort = value;
		}
		override public function clone():Event
		{
			return new ChengjiuEvent(ChengjiuEvent.CHENG_JIU_EVENT);
		}
	}
}
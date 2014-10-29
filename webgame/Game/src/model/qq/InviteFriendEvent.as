package model.qq
{
	import flash.events.Event;
	
	public class InviteFriendEvent extends Event
	{
		
		public static const QQ_INVITE_FRIEND_EVENT:String = "QQ_INVITE_FRIEND_EVENT";
		
		//默认消息类型
		public static const QQ_INVITE_FRIEND_EVENT_SORT_DEFAULT:int = 0;
		
		//消息类型
		private var m_sort:int = InviteFriendEvent.QQ_INVITE_FRIEND_EVENT_SORT_DEFAULT;
		
		public function InviteFriendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new InviteFriendEvent(InviteFriendEvent.QQ_INVITE_FRIEND_EVENT);
		}
		
	}
}
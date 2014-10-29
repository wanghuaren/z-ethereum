package model.qq
{
	import flash.events.Event;
	
	public class XuFeiChouJiangEvent extends Event
	{
		//续费抽奖消息
		public static const QQ_XUFEI_CHOUJIANG_EVENT:String = "QQ_XUFEI_CHOUJIANG_EVENT";
		
		//默认消息类型
		public static const SORT_DEFAULT:int = 0;
		
		//天使推荐MSG消息
		public static const SORT_MSG:int = 1;
		
		//抽奖
		public static const SORT_CHOUJIANG:int = 2;
		
		//领奖
		public static const SORT_LINGJIANG:int = 3;   
		
		//数据
		public static const SORT_DATA:int = 4;
		
		//WenXinTiShi_POP 开启
		public static const SORT_POP:int = 5;
		
		//消息类型
		private var m_sort:int = InviteFriendEvent.QQ_INVITE_FRIEND_EVENT_SORT_DEFAULT;
		
		public function XuFeiChouJiangEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new XuFeiChouJiangEvent(XuFeiChouJiangEvent.QQ_XUFEI_CHOUJIANG_EVENT);
		}
		
	}
	
}



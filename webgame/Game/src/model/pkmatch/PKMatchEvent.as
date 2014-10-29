package model.pkmatch
{
	import flash.events.Event;
	
	
	/**
	 * 个人PK赛事件
	 * @author steven guo
	 * 
	 */	
	public class PKMatchEvent extends Event
	{
		//PK赛消息
		public static const PK_MATCH_EVENT:String = "PK_MATCH_EVENT";
		
		//默认PK赛消息类型
		public static const PK_EVENT_SORT:int = 0;
		
		public static const PK_EVENT_SORT_PERSONAL_INFO:int = 1;
		public static const PK_EVENT_SORT_NOTIFY_PERSONAL_INFO:int = 2;
		
		//获得太乙和通天的总积分消息类型
		public static const PK_EVENT_SORT_TOTAL_NUMBER:int = 3;
		
		//左侧 通天 参赛人员列表
		public static const PK_EVENT_LEFT_HERO_LIST:int = 4;
		
		//右侧 太乙 参赛人员列表
		public static const PK_EVENT_RIGHT_HERO_LIST:int = 5;
		
		//获得pk日排行榜数据 
		public static const PK_EVENT_SORT_DAY_PK_RANK:int = 6; 
		
		//获得pk周排行榜数据 
		public static const PK_EVENT_SORT_WEEK_PK_RANK:int = 7; 
		
		//后台主动通知战报信息更新
		public static const PK_EVENT_NOTIFY_WAR_INFO:int = 8;//  notifyWarInfo
		
		//后台通知玩家请求参战成功
		public static const PK_EVENT_NOTIFY_ENTER_WAR:int = 9;
		
		//后台通知玩家请求离开战斗成功
		public static const PK_EVENT_NOTIFY_LEAVE_WAR:int = 10;
		
		
		
		//消息类型
		private var m_sort:int = PKMatchEvent.PK_EVENT_SORT;
		
		
		public function PKMatchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new PKMatchEvent(PKMatchEvent.PK_MATCH_EVENT);
		}
	}
}


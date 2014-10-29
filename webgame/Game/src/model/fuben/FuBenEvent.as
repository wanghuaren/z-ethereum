package model.fuben
{
	import flash.events.Event;
	
	
	/**
	 * 副本模块传递的事件消息
	 * @author steven guo 
	 * 
	 */	
	public class FuBenEvent extends Event
	{
		//消息类型
		public static const FU_BEN_EVENT:String = "FU_BEN_EVENT";
		
		//进入副本消息
		public static const FU_BEN_EVENT_ENTRY:int = 0;
		
		//离开副本消息
		public static const FU_BEN_EVENT_LEAVE:int = 1;
		
		//副本消息更新
		public static const FU_BEN_EVENT_UPDATA:int = 2;
		
		
		//获得四神器副本记录返回
		public static const FU_BEN_EVENT_PLAYER_GRUARD_INFO:int = 3; //  PlayerGruardInfo
		
		//进入四神器副本返回
		public static const FU_BEN_EVENT_ENTRY_GUARD_INSTANCE:int = 4;
		
		//副本失败消息
		public static const FU_BEN_EVENT_END:int = 5;
		
		//活动剩余时间倒计时消息
		public static const HUO_DONG_COUNT_DOWN_TIME:int = 6;
		
		//关闭 活动倒计时 窗口
		public static const HUO_DONG_COUNT_DOWN_CLOSE:int = 7;
		
		//关闭副本信息窗口
		public static const CLOSE_FUBEN_INFO:int = 8;
		
		
		//消息类型
		private var m_sort:int = -1;
		
		
		public function FuBenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new FuBenEvent(FuBenEvent.FU_BEN_EVENT);
		}
	}
}


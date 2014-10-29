package model.yunying
{
	import flash.events.Event;
	
	public class TianJianBaoXiangEvent extends Event
	{
		public static const TIAN_JIANG_BAO_XIANG_EVENT:String = "XIN_SHOU_MU_BIAO_EVENT";
		
		public static const DEFAULT_EVENT_SORT:int = 0;
		
		public static const HJ_KAIQI_CHENGGONG_EVENT_SORT:int = 1;
		
		public static const BY_KAIQI_CHENGGONG_EVENT_SORT:int = 2;
		
		public static const SS_KAIQI_CHENGGONG_EVENT_SORT:int = 3;
		
		//消息类型
		private var m_sort:int = TianJianBaoXiangEvent.DEFAULT_EVENT_SORT;
		
		
		
		public function TianJianBaoXiangEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new TianJianBaoXiangEvent(TianJianBaoXiangEvent.TIAN_JIANG_BAO_XIANG_EVENT);
		}
		
	}  
	
}
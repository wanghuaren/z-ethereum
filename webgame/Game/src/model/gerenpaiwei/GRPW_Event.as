package model.gerenpaiwei
{
	import flash.events.Event;
	
	public class GRPW_Event extends Event
	{
		
		public static const GRPW_EVENT:String = "GRPW_EVENT";
		

		public static const GRPW_EVENT_SORT_DEFAULT:int = 0;
		
		/**没有活动时候 界面右上角5个排名情况 */
		public static const GRPW_EVENT_SORT_SHRank:int = 1;
		/**今日可以挑战次数*/
		public static const GRPW_EVENT_SORT_FIGHT_COUNT:int = 2;
		/**今日比赛结果*/
		public static const GRPW_EVENT_SORT_TODAY:int = 3;
		/**所有战报消息 */
		public static const GRPW_EVENT_SORT_ZHANBAO_ALL:int = 4;
		/**个人战报消息 */
		public static const GRPW_EVENT_SORT_ZHANBAO_SELF:int = 5;
		/**获得个人赛比赛奖励信息 */
		public static const GRPW_EVENT_SORT_PRIZE:int = 6;
		/**所有人参赛排名情况 */
		public static const GRPW_EVENT_SORT_AllRank:int = 7;
		/**比赛中排名情况 */
		public static const GRPW_EVENT_SORT_FIGHT_Rank:int = 8;
		/**在比赛的过程中 显示 双方的战斗情况*/
		public static const GRPW_EVENT_SORT_FIGHTING:int = 9;
		/**下一场比赛开始时间更新 */
		public static const GRPW_EVENT_SORT_NEXT_MATCH_TIME:int = 10;
		/**是否参赛 */
		public static const GRPW_EVENT_SORT_IS_CANSAI:int = 11;
		/**队伍信息 */
		public static const GRPW_EVENT_SORT_DUI_WU:int = 12;
		

		private var m_sort:int = GRPW_Event.GRPW_EVENT_SORT_DEFAULT;
		
		public function GRPW_Event(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new GRPW_Event(GRPW_Event.GRPW_EVENT);
		}
	}
}
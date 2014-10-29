package ui.base.renwu
{
	import flash.events.EventDispatcher;

	public class renwuEvent extends EventDispatcher
	{
		//已接任务有变化
		public static var USERTASKCHANGE:String = "USERTASKCHANGE";
		//可接任务有变化
		public static var NEXTTASKCHANGE:String = "NEXTTASKCHANGE";
		//任务有变化
		public static var TASKCHANGE:String = "TASKCHANGE";
		//新的已接任务
		public static var NEWUSERTASK:String = "NEWUSERTASK";
		//任务完成可提交
		public static var TASKCANSUBMIT:String = "TASKCANSUBMIT";
		//队伍变化
		public static var changeDuiWu:String = "changeDuiWu";
		//某个队员的信息变化
		public static var changeDuiWuLEVEL:String = "changeDuiWuLEVEL";
		//队伍成员添加
		public static var DuiWuAdd:String = "DuiWuAdd";
		//队伍成员减少
		public static var DuiWuDelete:String = "DuiWuDelete";
		//队伍解散
		public static var DuiWuDeleteAll:String = "DuiWuDeleteAll";
		
		
		private static var _instance:renwuEvent; 
		
		public static function get instance():renwuEvent
		{
			if(!_instance)
			{
				_instance = new renwuEvent();
			}
			
			return _instance;
		}
		
	}
}
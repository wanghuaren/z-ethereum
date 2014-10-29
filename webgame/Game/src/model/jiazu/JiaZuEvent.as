package model.jiazu
{
	import flash.events.Event;
	
	
	/**
	 * 家族事件
	 * @author steven guo
	 * 
	 */	
	public class JiaZuEvent extends Event
	{

		//家族创建成功事件
		public static const JZ_CREATE_SUCCESS_EVENT:int = 1;
		
		//权限变更
		public static const JZ_GUILDDUTY_UPD_EVENT:int = 2;
		
		//ID变化(全变)
		public static const JZ_GUILD_UPD_EVENT:int = 3;
		
		//名字变化
		public static const JZ_GUILDNAME_UPD_EVENT:int = 4;
		
		//家族公告信息更新
		public static const JZ_GUILD_ANNOUNCEMENT_UPD_EVENT:int = 5; 
		
		//家族列表信息更新 ,家族排行榜更新
		public static const JZ_GUILD_LIST_UPD_EVENT:int = 6; 
		
		//申请成功消息
		public static const JZ_GUILD_REQ_SUCCESS_EVENT:int = 7;  
		
		//家族信息查询消息
		public static const JZ_GUILD_INFO_EVENT:int = 8;
		
		//家族动态信息更新
		public static const JZ_GUILD_LOG_UPD_EVENT:int = 9;
		
		//家族捐赠成功事件
		public static const JZ_GUILD_GIVE_MONEY_SUCCESS_EVENT:int = 10;  
		
	
		
		//
		public static const JZ_GUILD_REQ_LIST_EVENT:int = 11;  
		
		
		public static const JZ_GUILD_MEMBER_DEL_EVENT:int = 12;
		
		public static const JZ_GUILD_LVL_UPD_EVENT:int = 13;
		
		public static const JZ_GUILD_DEL_EVENT:int = 14;
		
		public static const JZ_GUILD_BOSS_TIME_EVENT:int = 15;
		
		public static const JZ_GUILD_SKILL_DATA_UPD_EVENT:int = 16;
		
		public static const JZ_GUILD_SKILL_LVL_UPD_EVENT:int = 17;
		
		//家族树信息更新
		public static const JZ_GUILD_TREE_INFO_UPD_EVENT:int = 18;
		
		//家族树操作成功
		public static const JZ_GUILD_TREE_OP_SUCCESS_EVENT:int = 19;
		
		//家族树掉落
		public static const JZ_GUILD_TREE_DROP_SUCCESS_EVENT:int = 20;
		
		public static const JZ_GUILD_REFUSE_EVENT:int = 21;
		public static const JZ_GUILD_ACCESS_EVENT:int = 22;
		
		//公告设置成功事件
		public static const JZ_GUILD_SET_TEXT_SUCCESS_EVENT:int = 23;
		
		public static const JZ_GUILD_QUIT_EVENT:int = 24;
		
		public static const JZ_GUILD_CHANGE_JOB_EVENT:int = 25;
		
		public static const JZ_GUILD_PRIZE:int = 26;
		
		public static const JZ_GUILD_AUTO_ACCESS_EVENT:int = 27;
				
		public static const JZ_EVENT:String = "jz_evt";
		
		
		
		//消息类型
		private var m_sort:int;
		
		//消息数据传递
		private var m_msg:Object;
		
		public function JiaZuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
		
		public function set msg(data:Object):void
		{
			m_msg = data;
		}
		
		public function get msg():Object
		{
			return m_msg;
		}
		
		override public function clone():Event
		{
			return new JiaZuEvent(JiaZuEvent.JZ_EVENT);
		}
	}
	
	
}




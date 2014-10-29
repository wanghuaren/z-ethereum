package common.config {
	/**
	 *@author wanghuaren
	 *@version 1.0 2010-3-30
	 *@category 界面事件发送类 所以事件数据格式{data:{......}};
	 */
	public final class EventACT {
		//==========================wanghuaren begin=====================
		/**
		 * @category 聊天内容事件
		 */
		public static const CHAT:String="EVENT_CHAT";
		/**
		 * @category 技能使用事件
		 */
		public static const SKILL:String="EVENT_SKILL"; 
		/**
		 * @category 背包中物品事件
		 */
		public static const RES:String="EVENT_RES"; 
		/**
		 * @category 地图上NPC 事件
		 */
		public static const NPC:String="EVENT_NPC"; 
		/**
		 * @category 地图上角色 事件
		 */
		public static const ROLE:String="EVENT_ROLE";
		/**
		 * @category 关于角色数据更新 事件//没有用上
		 */
		public static const REFRESH:String="EVENT_REFRESH"; 
		/**
		 * @category 拆分窗口 事件
		 */
		public static const SPLIT:String="SPLITWINDOWN_NUM"; 
		/*
		 * NPC自动寻路 参数type 0表示任务传送,若是VIP直接飞
		 */
		public static const FIND_NPC:String="FIND_NPC_ON_MISSION"; 
		/*
		 * 换线成功
		 */
		public static const CHANGE_LINE_SUCCESS:String="ON_GAME_CHANGE_LINE_SUCCESS"; 
		/*
		 * 自动寻路到达NPC旁边
		 */
		public static const FIND_NPC_OVER:String="CLICK_MISSION_AUTO_FIND_ADDRESS_OVER"; 
		/*
		 * 跟随事件
		 */
		public static const FOLLOW:String="TEAM_FOLLOW"; 
		/**
		 * 程序加载完毕
		 */
		public static const LOADED:String="FIRST_GAME_LOADED"; 
		/**
		 * 快捷使用物品事件
		 */
		public static const SHORTCUTS_USE:String="CLICK_SHORTCUTS_DISPATCH_RES_ID"; 
		
		//==========================wanghuaren end=====================
	}
}

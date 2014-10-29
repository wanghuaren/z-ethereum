package world
{
	import flash.events.EventDispatcher;

	/**
	 * 除计时外的其它事件发生器
	 */ 
	public class WorldDispatcher extends EventDispatcher
	{
		/**
		 * 
		 */ 
		public static const SysConfig_roleMessage:String = "SysConfig_roleMessage";
		public static const SysConfig_MonsterMessage:String = "SysConfig_MonsterMessage";
		public static const SysConfig_hide:String = "SysConfig_hide";
		public static const SysConfig_drop:String = "SysConfig_drop";
		public static const SysConfig_QUANPING:String = "SysConfig_QUANPING";
		
		public static const StudyNewSkill:String = "StudyNewSkill";
		
		public static const CREATEROLE:String = "CREATEROLE";
		
		public static const PKWIN:String = "PKWIN";
		public static const LOGINERROR:String = "LOGINERROR";
		
		public static const CHONGLIAN:String = "CHONGLIAN";
		
		public static const IN_GROUND:String = "in_ground";
		
		public static const TXT_INFO:String = "txt_info";		
		public static const TXT_INFO2:String = "txt_info2";		
		public static const TXT_INFO3:String = "txt_info3";		
		
		public static const PIC_SOURCE:String = "pic_source";
		
		public static const BAR_PERCENT:String = "bar_percent";
		
		public static const LOAD_RES:String = "load_res";
		
		private static var _instance:WorldDispatcher; 
		
		public static function get instance():WorldDispatcher
		{
			if(!_instance)
			{
				_instance = new WorldDispatcher();
			}
			
			return _instance;
		}
	}
}
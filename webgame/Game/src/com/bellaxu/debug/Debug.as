package com.bellaxu.debug
{
	import com.demonsters.debugger.MonsterDebugger;

	/**
	 * 调试类
	 * @author  BellaXu
	 */
	public final class Debug
	{
		private static const DO_TRACE:Boolean = true;
		
		public static function error(msg:String, tag:* = null):void
		{
			if(DO_TRACE)
				trace("[错误]：" + msg);
			//此处可上传错误日志
		}

		public static function warn(msg:*, tag:* = null):void
		{
			if(DO_TRACE)
				trace("[警告]: " + msg);
		}
		
		public static function notice(msg:*):void
		{
			if(DO_TRACE)
				trace(msg);
		}
		
		public static function initMonsterDebugger(base:Object, address:String = "127.0.0.1"):void
		{
//			if(DO_TRACE)
//				MonsterDebugger.initialize(base, address);
		}
		
		public static function monsterDebuggerLog(str:String):void
		{
//			if(DO_TRACE)
//				MonsterDebugger.log(str);
		}
		
		public static function monsterDebuggerSelectParent():void
		{
//			if(DO_TRACE)
//				MonsterDebugger.selectParent();
		}
	}
}
package com.bellaxu.def
{
	/**
	 * 资源优先级定义
	 * @author BellaXu
	 */
	public class ResPriorityDef
	{
		/**加载级别-普通(默认级别)**/
		public static const LOW:uint = 0;
		/**加载级别-中等(能优先加载最好，不行也可忍受的级别)**/
		public static const NORMAL:uint = 1;
		/**加载级别-高等(必须优先加载)**/
		public static const HIGH:uint = 2;
		/**加载级别-最高**/
		public static const SHIGH:uint = 3;
	}
}
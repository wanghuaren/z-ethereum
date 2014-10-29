package com.bellaxu.util
{ 
	import flash.net.LocalConnection;
	
	/**
	 * 系统方法
	 * @author BellaXu
	 */	
	public class SysUtil
	{
		/**
		 * 强制回收 
		 */		
		public static function gc():void
		{
			try
			{
				new LocalConnection().connect('gc');
				new LocalConnection().connect('gc');
			}
			catch(e:Error){
			
			}
		}
	}
}
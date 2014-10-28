package com.engine.core.controls
{
	import com.engine.core.model.IProto;
	/**
	 * 指令接口 
	 * @author saiman
	 * 
	 */	
	public interface IOrder extends IProto
	{
		function get type():String
			
		/**
		 * 执行指令函数 
		 * @return 
		 * 
		 */			
		function execute():*;
		/**
		 * 执行回调函数 
		 * @param args
		 * @return 
		 * 
		 */		
		function callback(args:Array=null):*
	}
}
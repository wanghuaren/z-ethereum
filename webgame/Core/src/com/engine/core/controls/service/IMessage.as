package com.engine.core.controls.service
{
	import com.engine.core.model.IProto;
	
	/**
	 *　信件接口 
	 * @author saiman
	 * 
	 */	
	public interface IMessage extends IProto
	{
		
		function get actionType():String
		function set actionType(value:String):void
		/**
		 * 信件头 
		 * @return 
		 * 
		 */		
		function get head():Head
		/**
		 * 信件体 
		 * @return 
		 * 
		 */		
		function get body():Body;
	
		/**
		 *　收信方 
		 * @return 
		 * 
		 */			
		function get geters():Vector.<String>
		/**
		 *　发信方 
		 * @return 
		 * 
		 */			
		function get sender():String
		/**
		 * 信件类型 
		 * @return 
		 * 
		 */			
		function get messageType():String
		/**
		 *　初始化 
		 * @param messageFormat
		 * @param messageMode
		 * @param sender
		 * @param geters
		 * @param body
		 * 
		 */			
		function setUp( sender:String, geters:Vector.<String>,body:Body=null, messageType:String='module_to_module'):void
		function toString():String
		function send():void
	}
}
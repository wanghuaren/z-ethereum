package com.engine.core.controls.model
{
	import com.engine.core.controls.service.Body;
	import com.engine.core.controls.service.IMessage;
	import com.engine.core.model.IProto;
	/**
	 * 模块代理接口 
	 * @author saiman
	 * 
	 */	
	public interface IProxy extends IProto
	{
		function send(message:IMessage):void
		
		function createMessage(serner:String,geters:Vector.<String>,body:Body=null,type:String='module_to_module'):IMessage
		function setUp(id:String,modelName:String,subHandler:Function):void
	}
}
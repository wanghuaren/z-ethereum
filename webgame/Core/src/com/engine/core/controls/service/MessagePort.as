package com.engine.core.controls.service
{
	import com.engine.core.controls.model.IModule;
	import com.engine.core.controls.model.MessageConstant;
	import com.engine.core.controls.model.ModuleMonitor;
	import com.engine.core.controls.model.ServierProtModule;
	import com.engine.core.view.base.BaseTimer;
	import com.engine.namespaces.saiman;
	/**
	 * 模块消息通信代理，消息系统的所有类型消息都经由此处进出。 
	 * @author saiman
	 * 
	 */
	public class MessagePort
	{
		private static var _instance:MessagePort
		public var moduleMonitor:ModuleMonitor
		
		public function MessagePort()
		{
			this.moduleMonitor=ModuleMonitor.saiman::getInstance()
		}
		saiman static function getInstance():MessagePort
		{
			if(_instance==null)_instance=new MessagePort;
			return _instance
		}
		public function send(message:IMessage):void
		{
			if(message.messageType==MessageConstant.MODULE_TO_SERVICE)
			{
				
				this.moduleToSevrice(message)
			}else {
				this.moduleToModule(message)
			}
			
		}
		public function moduleToModule(message:IMessage):void
		{
			
		
			var module:IModule=moduleMonitor.takeModule(message.sender);
			if(module){
				var geters:Vector.<String>=message.geters;
				for(var i:int=0;i<geters.length;i++)
				{
					if(geters[i]){
						var geter:IModule=moduleMonitor.takeModule(geters[i])
						if(Message(message).copy)message=message.clone() as Message;
						if(geter)geter.proxy.saiman::subHandler(message);
					}
				}
			}
			
			
		}
		public function moduleToSevrice(message:IMessage):void
		{
				
			var module:IModule=moduleMonitor.takeModule(ServierProtModule.NAME);
			module.proxy.saiman::subHandler(message)
		
			
		}
	}
}
package com.engine.core.controls.model
{
	import com.engine.core.controls.service.Body;
	import com.engine.core.controls.service.IMessage;
	import com.engine.core.controls.service.Message;
	import com.engine.core.controls.service.MessagePort;
	import com.engine.core.model.Proto;
	import com.engine.namespaces.saiman;
	import com.engine.utils.Hash;
	
	import flash.utils.Dictionary;

	/**
	 *   模块管理器用于对模块的注册，存储管理。
	 * @author saiman
	 * 
	 */
	public class ModuleMonitor extends Proto 
	{
		private static var _instance:ModuleMonitor;
		private var _hash:Hash
		public function ModuleMonitor()
		{
			_hash=new Hash
		}
		saiman function get hash():Hash
		{
			return this._hash
		}
		/**
		 * @prvate 
		 * 获取模块管理器，该方法需要使用saiman命名空间进行调用以保障好程序的稳定性。 
		 * @return 
		 * 
		 */		
		saiman static function getInstance():ModuleMonitor
		{
			if(_instance==null)_instance=new ModuleMonitor;
			return _instance
		}
		public function setUp(moduleConstant:Class):void
		{
			var serverModule:ServierProtModule=new ServierProtModule
			serverModule.register(ServierProtModule.NAME);
			
			var xml:XML=flash.utils.describeType(moduleConstant)
			var xmllist:XMLList=xml.child('constant')
			for(var i:int=0;i<xmllist.length();i++)
			{
				var className:String=moduleConstant[xmllist[i].@name]
				var cla:Class=flash.utils.getDefinitionByName(className) as Class
				if(cla)
				{
					var module:IModule=new cla as IModule;
					if(module)module.register(className);
				}
			}
		
		}
		
		/**
		 *  广播一个消息给所有模块 
		 * @param actionType
		 * @param sender
		 * @param data
		 * @return 
		 * 
		 */	
		public  function sendToTotalModule(actionType:String,sender:String,data:Object=null):void
		{
			var geter:Vector.<String>=new Vector.<String>
			for each(var module:IModule in this._hash.hash)
			{
				geter.push(module.id)
			}
			var message:Message=new Message
			if(data as Body)
			{
				message.setUp(sender,geter,data as Body)
			}else {
				message.setUp(sender,geter)
				message.proto=data;
			}
			message.actionType=actionType;
			message.send()
		}
		
		/**
		 * 添加一个模块 
		 * @param module
		 * 
		 */		
		public function addModule(module:IModule):void
		{
			if(this._hash.has(module.id)==false)
			{
				this._hash.put(module.id,module);
				
			}
		}
		/**
		 *  删除一个模块 
		 * @param id
		 * 
		 */		
		public function removeModule(id:String):void
		{
			 this._hash.remove(id)
		}
		/**
		 * 获取一个模块 
		 * @param id
		 * @return 
		 * 
		 */		
		public function takeModule(id:String):IModule
		{
			return this._hash.take(id) as IModule
		}
		/**
		 *  发送一个信息
		 * @param message
		 * 
		 */		
		public function send(message:IMessage):void
		{
			MessagePort.saiman::getInstance().send(message)
		}	
		public function subHandler(message:IMessage):void
		{
			
		}
		/**
		 * 创建一个信息 
		 * @param serner
		 * @param geters
		 * @param body
		 * @param type
		 * @return 
		 * 
		 */		
		public function createMessage(serner:String,geters:Vector.<String>,body:Body=null,type:String='module_to_module'):IMessage
			
		{
			var message:Message=new Message
			message.setUp(serner,geters,body,type);
			return message
		}
	}
}
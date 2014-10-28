package com.engine.core.controls.model
{
	import com.engine.core.controls.service.Body;
	import com.engine.core.controls.service.IMessage;
	import com.engine.core.controls.service.Message;
	import com.engine.core.model.Proto;
	import com.engine.namespaces.saiman;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 *  模块附属挂钩代理。
	 *  <br>用于解决模块内部间通信问题。
	 *  <br>模块的各子级界面如需进行通信都可以创建该类实例并将其注册到对应的模块模块中。
	 *  <br>
	 * @author saiman
	 * 
	 */	
	public class SubProxy extends Proto implements IProxy
	{
		private var _moduleName:String

		

		private var _subHandler:Function;
		
		private var _lock:Boolean=false
		
		public function SubProxy()
		{
			super();
			this.$id=flash.utils.getQualifiedClassName(this)
			
		}
		public function subHandler(message:IMessage):void
		{
			
		}
		
		public function get lock():Boolean
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void
		{
			_lock = value;
		}
		/**
		 * 将自身注册到一个模块中去
		 * @param moduleName
		 * @param subHandler
		 * 
		 */		
		public function setUp(id:String,moduleName:String,subHandler:Function):void
		{
//			this.unlock();
			if(id!=null)this.$id=id;
			_moduleName=moduleName;
			_subHandler=subHandler;
			this.$oid=moduleName;
			
			var module:IModule=ModuleMonitor.saiman::getInstance().takeModule(this.$oid);
			if(module){
//				this.unlock()
				try{
				var cla:Class=flash.utils.getDefinitionByName(id) as Class
				}catch(e:Error){}
				var sub:*
				if(cla){
					sub=  new cla
				}else {
					sub=this
				}
				
				module.proxy.addSub(sub);
			}
		}
		/**
		 * 解除与模块的注册关系 
		 * 
		 */		
		public function unlock():void
		{	
			_subHandler=null;
			_moduleName=null
			this.$oid=null
			var module:IModule=ModuleMonitor.saiman::getInstance().takeModule(this.$oid);
			if(module){
				module.proxy.removeSub(this.$id)
			}
		}
		/**
		 *  发送一个信息到从属的sub代理 
		 * @param message
		 * 
		 */		
		public function senToSub(subId:String,message:IMessage):void
		{
			if(this.lock)return;
			var module:IModule=ModuleMonitor.saiman::getInstance().takeModule(this.$oid);
			if(module){
				module.proxy.sendToSub(subId,message)
			}
		}
		public function sendToSub(subId:String,actionType:String,data:Object):void
		{
			if(this.lock)return;
			var module:IModule=ModuleMonitor.saiman::getInstance().takeModule(this.$oid);
			if(module){
				if(data as Message){
					module.proxy.sendToSub(subId,data as Message)
				}else {
					var message:Message=new Message
						message.setUp(this.id,new <String>[subId],null)
						message.actionType=actionType
						message.proto=data
						module.proxy.sendToSub(subId,message)
				}
			}
		}
		/**
		 * 发送一个信息到多个从属的sub代理 
		 * @param geters
		 * @param message
		 * 
		 */		
		public function senToSubs(geters:Vector.<String>,message:IMessage):void
		{
			if(this.lock)return;
			var module:IModule=ModuleMonitor.saiman::getInstance().takeModule(this.$oid);
			if(module){
			var len:int=geters.length
			for(var i:int=0;i<len;i++)
			{
					var subId:String=geters[i]
					if(subId)
					{
						module.proxy.sendToSub(subId,message)
					}
				}
			}
			
		}
		
		public function sendToSerivce(actionType:String,data:Object):void
		{
			if(this.lock)return;
			var message:Message=new Message
				message.setUp(this.$oid,new <String>[ServierProtModule.NAME],null,MessageConstant.MODULE_TO_SERVICE);
				message.actionType=actionType;
				message.proto=data;
				message.send()
		}
		
		/**
		 *  发送一个消息通知所有模块 
		 * @param actionType
		 * @param sender
		 * @param data
		 * 
		 */	
		public  function sendToTotalModule(actionType:String,data:Object=null):void
		{
			if(this.lock)return;
			ModuleMonitor.saiman::getInstance().sendToTotalModule(actionType,this.oid,data)
		}
		/**
		 * 向模块发送一个信息
		 * @param geters
		 * @param body
		 * 
		 */		
		public function sendToModule(actionType:String,geters:Vector.<String>,data:Object=null):void
		{
			if(this.lock)return;
			var message:Message=new Message
			var body:Body
			if(data as Body){
				data.type=actionType
				body=data as Body
			}else {
				body=new Body
				body.type=actionType
				body.proto=data
			}
			message.setUp(this.oid,geters,body,MessageConstant.MODULE_TO_MODULE)
			message.send();
		} 
		/**
		 * 信息发送方法 
		 * @param message
		 * 
		 */		
		public function send(message:IMessage):void
		{
			if(this.lock)return;
			var module:IModule=ModuleMonitor.saiman::getInstance().takeModule(this.$oid);
			if(module){
				module.send(message)
			}else {
				throw new Error('该Sub还没注册')
			}
		}
	
		/**
		 * 
		 *  实例对外开放的新信息接入方法。
		 *  非核心管理器，无需直接调用
		 * @param message
		 * 
		 */		
		saiman function subHandler(message:IMessage):void
		{
			if(this.lock)return;
			subHandler.apply(null,[message]);
//			if(this._subHandler!=null)this._subHandler.apply(null,[message]);
		}
		/**
		 *  创建一个信息 
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
			message.setUp(this.oid,geters,body,type);
			return message
		}
		/**
		 * 销毁方法 
		 * 
		 */		
		override public function dispose():void
		{
			this._subHandler=null;
			var module:IModule=ModuleMonitor.saiman::getInstance().takeModule(this.$oid);
			if(module){
				module.proxy.removeSub(this.id)
			}
			super.dispose()
		}
		public function getSubIdByClass(cla:Class):String
		{
			try{
			return  flash.utils.getQualifiedClassName(cla)
			}catch(e:Error){
				
			}
			return null
		}
	}
}
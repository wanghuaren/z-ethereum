package com.engine.core.controls.model
{
	import com.engine.core.Core;
	import com.engine.core.controls.service.Body;
	import com.engine.core.controls.service.IMessage;
	import com.engine.core.controls.service.Message;
	import com.engine.core.controls.service.MessagePort;
	import com.engine.core.model.IProto;
	import com.engine.core.model.Proto;
	import com.engine.core.view.IBaseSprite;
	import com.engine.namespaces.saiman;
	/**
	 * 基础模块 
	 * @author saiman
	 * 
	 */	
	public class BaseModule  implements IModule
	{
		protected var $id:String
		protected var $oid:String
		protected var $proto:Object
		protected var $proxy:ModuleProxy;
		protected var $view:IBaseSprite;
		protected var $valve:Boolean
		private var _lock:Boolean
		
		public function BaseModule()
		{
			this.valve=true;
//			throw new Error('模块基类只能继承，无法实例化，且必须重载subHandler方法')
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
		 * 模块信息阀门 
		 * @return 
		 * 
		 */		
		public function get valve():Boolean
		{
			return $valve;
		}

		public function set valve(value:Boolean):void
		{
			$valve = value;
			if(this.$proxy)this.$proxy.valve=value;
		}

		public function get id():String
		{
			return $id;
		}
		public function get oid():String
		{
			return $oid;
		}
		public function set proto(value:Object):void
		{
			 this.$proto=value
		}
		public function get proto():Object
		{
			return this.$proto
		}
		public function get proxy():ModuleProxy
		{
			return $proxy;
		}
		public function get view():IBaseSprite
		{
			return $view;
		}
		
		public function set view(value:IBaseSprite):void
		{
			$view=value
		}
		public function initialize():void
		{
			
		}
		public function dispose():void
		{
			ModuleMonitor.saiman::getInstance().removeModule(this.id)
			$proxy.dispose()
			$proxy=null;
			$view=null;
			$proto=null;
			$id=null
			
		}
		public function clone():IProto
		{
			return null
		}
		public function register(moduleName:String):void
		{
			
			if(this.$proxy==null)
			{
				this.$proxy=new ModuleProxy
				this.$proxy.valve=this.$valve;
				proxy.setUp(null,moduleName,subHandler)
				this.$id=moduleName
				ModuleMonitor.saiman::getInstance().addModule(this)
			}
		}
		public function subHandler(message:IMessage):void
		{
			
		}
		public function send(message:IMessage):void
		{
			if(!Core.sandBoxEnabled)return;
			Message.check(message)
			MessagePort.saiman::getInstance().send(message)
		}
		
		public function createMessage(sender:String,geters:Vector.<String>,body:Body=null,messageType:String='module_to_module'):IMessage
		
		{
			var message:Message=new Message
				message.setUp(sender,geters,body,messageType)
				return message
		}
		/**
		 * 注册订阅器 
		 * @param sub SubProxy类及其子类类名，或者SubProxy类及其子类实例
		 * 
		 */		
		public function registerSub(...subs:Array):void
		{
			for(var i:int=0;i<subs.length;i++){
				var sub:Object=subs[i]
				var subx:SubProxy
				if(sub is Class)
				{
					subx=new sub as SubProxy
					subx.saiman::oid=this.id;
					if(subx){
						this.proxy.addSub(subx)
					}else {
						throw new Error('参数对象不是SubProxy子类对象')
					}
					
				}else if(sub as SubProxy)
				{
					subx.saiman::oid=this.id
					this.proxy.addSub(subx)
				}else {
					throw new Error('参数对象不是SubProxy子类对象')
				}
			}
		}
	}
}
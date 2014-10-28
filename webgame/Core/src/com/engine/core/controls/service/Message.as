package com.engine.core.controls.service
{
	import com.engine.core.controls.model.IModule;
	import com.engine.core.controls.model.MessageConstant;
	import com.engine.core.controls.model.Module;
	import com.engine.core.controls.model.ModuleMonitor;
	import com.engine.core.controls.model.SubProxy;
	import com.engine.core.model.IProto;
	import com.engine.core.model.Proto;
	import com.engine.namespaces.saiman;
	
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;
	/**
	 * 模块通信消息类，作为一个信件体形式通用于所有模块间的消息 
	 * @author saiman
	 * 
	 */	
	public class Message extends Proto implements IMessage
	{
		protected var $head:Head;
		protected var $body:Body;
		public var bubble:Boolean
		public var copy:Boolean	
		public function Message()
		{
			super();
			flash.net.registerClassAlias('saiman.save.Message',Message)
		}
		public function get actionType():String
		{
			return this.$body.type
		}
		public function set actionType(value:String):void
		{
			if(this.$body==null)this.$body=new Body;
			this.$body.type=value
		}
		public function get head():Head
		{
			return this.$head;
		}
		public function get messageType():String
		{
			if(this.$head==null)return null;
			return this.$head.messageType;
		}
		public function get sender():String
		{
			if(this.$head==null)return null;
			return this.$head.sender;
		}
		public function get geters():Vector.<String>
		{
			if(this.$head==null)return null;
			return this.$head.geters;
		}
		
		public function get body():Body
		{
			return this.$body;;
		}
		override public function set proto(value:Object):void
		{
			
			if(this.body==null)this.$body=new Body;
			this.$body.proto=value;
		}
	
		override public function get proto():Object
		{
			if(this.$body==null)return null;
			return this.$body.proto
		}
		
		public function setUp( sender:String, geters:Vector.<String>,body:Body=null, messageType:String='module_to_module'):void
		{
			var head:Head=new Head
			head.geters=geters;
			head.messageType=messageType;
			head.sender=sender
			this.$head=head;
			this.$body=body;
			this.$oid=sender
		}
		public function setUpFunction(execFunc:Function=null,args:Array=null,callbackFunc:Function=null):void
		{
			if(this.$body)this.$body.setUpFunction(execFunc,args,callbackFunc);
		}
		public function send():void
		{
			check(this)
			var module:IModule=ModuleMonitor.saiman::getInstance().takeModule(this.sender) 
			if(module){
				if(!module.lock)
				module.send(this);
			}else {
				throw new Error('消息发送方非注册模块成员')
			}
		}
		public static function check(message:IMessage):void
		{
			if(message==null)throw new Error('【message】不能为null！')
			if(message.sender==null||message.geters.length<=0||message.geters==null)
			{
				var str:String='sender='+message.sender+'\n';
				message.geters?str+='geters length='+message.geters.length:str+='geters='+message.geters+'\n';
				throw new Error('【message】基本信息不完整，请检查！\n'+str)
			}
		}
		override public function toString():String
		{
			var name:String=getQualifiedClassName(this)
			var str:String=''
			str+='['+name.substr(name.indexOf('::')+2,name.length)+' '+id+' '
			str+='messageType='+this.messageType+' ';
			str+='sender='+this.sender+' ';
			str+='geters='+this.geters+' ]'
			return str
		}
		override public function dispose():void
		{
			this.$body?this.$body.dispose():'';
			this.head?this.head.dispose():''
			this.$body=null;
			this.$head=null
			super.dispose()
		}
		/**
		 *  发送一个消息通知所有模块 
		 * @param actionType
		 * @param sender
		 * @param data
		 * 
		 */	
		public static function sendToTotalModule(actionType:String,sender:String,data:Object=null):void
		{
			ModuleMonitor.saiman::getInstance().sendToTotalModule(actionType,sender,data)
		}
		/**
		 * 发送一个消息给某个模块 
		 * @param actionType
		 * @param sender
		 * @param geter
		 * @param data
		 * 
		 */		
		public static function sendToModules(actionType:String,sender:String,geter:Vector.<String>,data:Object=null):void
		{
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
		public static function sendToSub2(actionType:String,moduleId:String,geter:Class,data:Object=null):void
		{
			var module:Module=ModuleMonitor.saiman::getInstance().takeModule(moduleId) as Module
			if(module)
			{
				var message:Message=new Message;
				message.setUp(moduleId,new <String>[flash.utils.getQualifiedClassName(geter)])
				message.proto=data;
				message.actionType=actionType
				module.senToSub(flash.utils.getQualifiedClassName(geter),message);
			}
		}
		public static function sendToSub(actionType:String,sender:SubProxy,geter:Class,data:Object=null):void
		{
			
			var module:Module=ModuleMonitor.saiman::getInstance().takeModule(sender.oid) as Module
			if(module)
			{
				var message:Message=new Message;
				message.setUp(flash.utils.getQualifiedClassName(sender),new <String>[flash.utils.getQualifiedClassName(geter)])
				message.proto=data;
				message.actionType=actionType
				module.senToSub(flash.utils.getQualifiedClassName(geter),message);
			}
		
		}
		public static function sendToService(service:String,sender:String,data:Object):void
		{
			
			var body:Body
			if(data as Body){
				data.type=service
				body=data as Body
			}else {
				body=new Body
				body.type=service
				body.proto=data
			}
			var message:Message=new Message
			message.setUp(sender,new <String>[MessageConstant.MODULE_TO_SERVICE],body,MessageConstant.MODULE_TO_SERVICE)
			message.send();
		}
		
	}
}
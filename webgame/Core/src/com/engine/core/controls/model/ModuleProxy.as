package com.engine.core.controls.model
{
	import com.engine.core.controls.service.Body;
	import com.engine.core.controls.service.IMessage;
	import com.engine.core.controls.service.Message;
	import com.engine.core.controls.service.MessagePort;
	import com.engine.core.model.Proto;
	import com.engine.namespaces.saiman;
	import com.engine.utils.Hash;
	/**
	 * 模块通信代理 
	 * <br>模块对外通信的代理类。
	 * <br>实现模块的Sub代理的注册与管理
	 * @author saiman
	 * 
	 */	
	public class ModuleProxy extends Proto implements IProxy
	{
		private var _hash:Hash
		private var _moduleName:String;
		private var _subHandler:Function;
		private var _valve:Boolean
		public function ModuleProxy()
		{
			super();
		}
		/**
		 *  将代理注册到一个模块中 
		 * @param moduleName
		 * @param subHandler
		 * 
		 */		
		public function setUp(id:String,moduleName:String,subHandler:Function):void
		{
			if(id!=null)this.$id=id;
			_moduleName=moduleName;
			this.$oid=moduleName
			_subHandler=subHandler;
			_hash=new Hash
			
			
		}
		/**
		 *  添加一个Sub代理
		 * @param sub
		 * 
		 */		
		public function addSub(sub:SubProxy):void
		{
			if(sub==null)return;
			if(this._hash.has(sub.id)==false){
				 _hash.put(sub.id,sub)
			
			}else {
				throw new Error('定阅器注册的id以存在，请确保id唯一');
			}
		}
		/**
		 * 删除一个Sub代理 
		 * @param id
		 * @return 
		 * 
		 */		 
		public function removeSub(id:String):SubProxy
		{
			return _hash.remove(id) as SubProxy
		}
		/**
		 * 获取一个sub代理 
		 * @param id
		 * @return 
		 * 
		 */		
		public function takeSub(id:String):SubProxy
		{
			return _hash.take(id) as SubProxy
		}
		/** 
		 *  判断是否存在一个sub代理 
		 * @param id
		 * @return 
		 * 
		 */		 
		public function hasSub(id:String):Boolean
		{
			return _hash.has(id);
		}
		/**
		 *  调用模块的一个信息到 
		 * @param message
		 * 
		 */		 
		public function send(message:IMessage):void
		{
			MessagePort.saiman::getInstance().send(message)
		}
		/**
		 * 代理接受外部信息的回调方法 
		 * <br>该方法会将信息传递给模块从属的每一个sub代理
		 * @param message
		 * 
		 */			
		saiman function subHandler(message:IMessage):void
		{
			
			if(this._valve){
				this._subHandler.apply(null,[message])
				for each(var sub:SubProxy in this._hash.hash)
				{
					if(!sub.lock)
					sub.saiman::subHandler(message)
				}
			}
			
		}
		/**
		 *  发送一个信息到从属的一个sub代理
		 * @param subId
		 * @param message
		 * 
		 */		
		public function sendToSub(subId:String,message:IMessage):void
		{
			var sub:SubProxy=this.takeSub(subId);
			message.head.messageType=MessageConstant.MODELE_TO_SUB
			message.head.geters=new <String>[subId];
			if(sub){
				sub.saiman::subHandler(message)
			}
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
		/**
		 * 销毁 
		 * 
		 */		
		override public function dispose():void
		{
			this._hash.dispose();
			this._hash=null; 
			this._subHandler=null;
			super.dispose();
			
		}
		
	
		
		public function set valve(value:Boolean):void
		{
			_valve = value;
			
		}

		
	}
}
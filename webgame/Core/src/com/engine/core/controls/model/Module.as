package com.engine.core.controls.model
{
	import com.engine.core.controls.service.Body;
	import com.engine.core.controls.service.IMessage;
	import com.engine.core.controls.service.Message;
	import com.engine.namespaces.saiman;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 *  具体的模块基类，进行模块开发是，需要集成该类。
	 *  <br> 作为模块不建议实例化使用，游戏初始化时，需要由模块管管理模块独立初始化并实例化。
	 *  <br>为避免直接对模块的实例操作。模块类不设计成单例模式。模块的任何通信都需要通过模块的代理或者实例化Sub代理进行通信。
	 *  <br>进而避免代码的过度耦合，保护模块的独立性及降低模块间的依赖性。这对于后期模块快开发意义重大。
	 * @author saiman
	 * 
	 */
	public class Module extends BaseModule
	{
	
		public function Module()
		{
			this.register(getQualifiedClassName(this))
		}

		

		/**
		 * 模块对外的唯一信息入口所有的通信信息将从该入口进入。 
		 * <br>请禁止在模块实例外部直接调用该方法，该方法之作为信息进入接口
		 * @param message
		 * 
		 */		
		override public function subHandler(message:IMessage):void
		{
			if(this.lock)return;
			super.subHandler(message)
			switch(message.messageType)
			{
				case MessageConstant.MODULE_TO_MODULE:
					messageFromModule(message)
					break;
				case MessageConstant.MODULE_TO_SERVICE:
					messageFromService(message)
					break;
			}
		}
		/**
		 *  模块间通信信息响应方法
		 *  <br> 子类需要重载该方法，并在子类该方法下进行相关的信息处理
		 * @param message
		 * 
		 */		
		protected function messageFromModule(message:IMessage):void
		{
			
			
		}
		/**
		 *  服务端返回的信息入口 
		 *  <br> 子类需要重载该方法，并在子类该方法下进行相关的信息处理
		 * @param message
		 * 
		 */		
		protected function messageFromService(message:IMessage):void
		{
			
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
			ModuleMonitor.saiman::getInstance().sendToTotalModule(actionType,this.$id,data)
		}
		
		/**
		 * 向模块发送一个信息
		 * @param geters
		 * @param body
		 * 
		 */		
		public function sendToModule(actionType:String,geters:Vector.<String>,data:Object):void
		{
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
				message.setUp(this.$id,geters,body,MessageConstant.MODULE_TO_MODULE)
				
				message.send();
		} 
		/**
		 *  向服务端发送一个信息 
		 * @param geters
		 * @param body
		 * 
		 */		
		public function sendToService(actionType:String,geters:Vector.<String>,data:Object):void
		{
			var body:Body
			if(data as Body){
				data.type=actionType
				body=data as Body
			}else {
				body=new Body
				body.type=actionType
				body.proto=data
			}
			var message:Message=new Message
			message.setUp(this.$id,geters,body,MessageConstant.MODULE_TO_SERVICE)
			message.send();
		}
		/**
		 * 拷贝一个信息 
		 * @param message
		 * @return 
		 * 
		 */		
		public function copyMessage(message:Message):Message
		{
			return message.clone() as Message
		}
		/**
		 *  发送一个信息到从属的sub代理 
		 * @param message
		 * 
		 */		
		public function senToSub(subId:String,message:IMessage):void
		{
			this.proxy.sendToSub(subId,message)
		}
		/**
		 * 发送一个信息到多个从属的sub代理 
		 * @param geters
		 * @param message
		 * 
		 */		
		public function senToSubs(geters:Vector.<String>,message:IMessage):void
		{
			var len:int=geters.length
			for(var i:int=0;i<len;i++)
			{
				var subId:String=geters[i]
				if(subId)
				{
					this.proxy.sendToSub(subId,message)
				}
			}
			
		}
		override public function  dispose():void
		{
			super.dispose();
			
		}
		
		
	}
}
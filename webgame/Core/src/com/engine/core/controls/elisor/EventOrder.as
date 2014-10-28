package com.engine.core.controls.elisor
{
	import com.engine.core.Core;
	import com.engine.core.IOrderDispatcher;
	import com.engine.core.controls.Order;
	import com.engine.core.view.DisplayObjectPort;
	import com.engine.namespaces.saiman;
	
	import flash.net.registerClassAlias;
	/**
	 *  事件指令  
	 *  <br>EventOrder类封装事件注册的相关信息，本类实例不存储对象实例。他会根据事件拥有者的id信息到对象管理器中进行查询
	 *  <br>事件指令需要注册到事件管理器中进行维护管理，一般地当实现了IOrderDispatcher 接口的对象在销毁时会调用指令管理器对注册信息进行销毁。
	 * @author saiman
	 * 
	 */	
	public class EventOrder extends Order
	{
		public var _listener:Function;
		public var listenerType:String
		
		public function EventOrder()
		{
			super();
			flash.net.registerClassAlias('saiman.save.EventOrder',EventOrder)
			this.$type=OrderMode.EVENT_ORDER;
			
		}
		public function register(oid:String,listenerType:String,listener:Function):void
		{
			this._listener=listener;
			this.listenerType=listenerType;
			this.$oid =oid;
			this.$id=this.$oid+Core.SIGN+listenerType
			
		}
		override public function dispose():void
		{
			var owner:IOrderDispatcher=DisplayObjectPort.saiman::getInstance().task(this.oid)
			if(owner)
			{
				owner.removeEventListener(this.listenerType,this._listener);
				owner=null;
			}
			this._listener=null;
			this.listenerType=null
			this.$id=null;
			this.$oid=null;
			super.dispose();
		}
		override public function execute():*
		{
			activate()
		}
		public function activate():void
		{
			var owner:IOrderDispatcher=DisplayObjectPort.saiman::getInstance().task(this.oid)
			if(owner)
			{
				owner.addEventListener(this.$id,this._listener);
				owner=null;
			}
		}
		public function unactivate():void
		{
			var owner:IOrderDispatcher=DisplayObjectPort.saiman::getInstance().task(this.oid)
			if(owner)
			{
				owner.removeEventListener(this.$id,this._listener)
				owner=null
			}
		}
	}
}
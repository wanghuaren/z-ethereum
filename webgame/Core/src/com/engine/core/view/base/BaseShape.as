package com.engine.core.view.base
{
	import com.engine.core.Core;
	import com.engine.core.controls.IOrder;
	import com.engine.core.controls.Order;
	import com.engine.core.controls.elisor.Elisor;
	import com.engine.core.controls.elisor.EventOrder;
	import com.engine.core.controls.elisor.FrameOrder;
	import com.engine.core.controls.elisor.OrderMode;
	import com.engine.core.model.IProto;
	import com.engine.core.model.Proto;
	import com.engine.core.view.DisplayObjectPort;
	import com.engine.core.view.IBaseSprite;
	import com.engine.namespaces.saiman;
	
	import flash.display.Shape;
	/**
	 * 核心重载实现的不带鼠标交互的绘图原型对象 实现了 IBaseSprite接口。调用dispose可实现完全销毁
	 * @author saiman
	 * 
	 */	
	public class BaseShape extends Shape implements IBaseSprite
	{
		private var _id:String;
		protected var $oid:String;
		protected var $proto:Object
		
		public function BaseShape()
		{
			super();
			this._id=Core.saiman::nextInstanceIndex().toString(16);
			DisplayObjectPort.saiman::getInstance().put(this)
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			var elisor:Elisor=Elisor.getInstance()
			var key:String=this._id+Core.SIGN+type
			if(elisor.hasOrder(key,OrderMode.EVENT_ORDER)==false)
			{
				var order:EventOrder=elisor.createEventOrder(this.id,type,listener)
				elisor.addOrder(order)
				if(super.hasEventListener(type)==false)super.addEventListener(type,listener,useCapture)
			}
			
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			var elisor:Elisor=Elisor.getInstance()
			var key:String=this._id+Core.SIGN+type
			if(elisor.hasOrder(key,OrderMode.EVENT_ORDER)==true)
			{
				var order:EventOrder=elisor.removeOrder(key,OrderMode.EVENT_ORDER) as EventOrder
				if(order)
					order.dispose();
				order=null;
			}
			if(super.hasEventListener(type)==true)super.removeEventListener(type,listener);
			
		}
		
		
		public function _setTimeOut_(delay:int,action:Function, args:Array):void
		{
			var elisor:Elisor=Elisor.getInstance()
			var order:FrameOrder=elisor.setTimeOut(this.id,delay,action,args)
			elisor.addOrder(order)
			order.start();	
		}
		
		public function onTimer(delay:int,action:Function,args:Array,callbackFunc:Function=null):FrameOrder
		{
			var elisor:Elisor=Elisor.getInstance()
			var order:FrameOrder=elisor.createFrameOrder(this.id,delay,action,args,callbackFunc,-1)
			elisor.addOrder(order)
			order.start();	
			return order
			
		}
		
		public function initialize():void
		{
			
		}
		
		public function takeOrder(id:String, orderMode:String):IOrder
		{
			var elisor:Elisor=Elisor.getInstance()
			return elisor.takeOrder(id,orderMode)
		}
		
		public function hasOrder(id:String, orderMode:String):Boolean
		{
			var elisor:Elisor=Elisor.getInstance()
			return elisor.hasOrder(id,orderMode)
		}
		
		public function removeOrder(id:String, orderMode:String):IOrder
		{
			var elisor:Elisor=Elisor.getInstance()
			return elisor.removeOrder(id,orderMode)
		}
		
		public function addOrder(order:IOrder):Boolean
		{
			var elisor:Elisor=Elisor.getInstance()
			return elisor.addOrder(order)
			
		}
		
		public function takeGroupOrders(orderMode:String):Vector.<IOrder>
		{
			
			var elisor:Elisor=Elisor.getInstance()
			return elisor.takeGroupOrders(this._id,orderMode)
			
		}
		
		public function disposeGroupOrders(orderMode:String):Vector.<IOrder>
		{
			var elisor:Elisor=Elisor.getInstance()
			return elisor.disposeGroupOrders(this._id,orderMode)
		}
		
		/**
		 * @private 
		 * 
		 *  本引擎预留的用于修改注册实例id的方法。
		 *  <br>id值非特殊需要不建议修改
		 *  <br>该方法可能存在不稳定性，不宜频繁使用，使用需要注意。
		 * @param value
		 * 
		 */		
		saiman function set id(value:String):void
		{
			DisplayObjectPort.saiman::getInstance().remove(this._id)
			var array:Vector.<IOrder>=Elisor.getInstance().disposeGroupOrders(this._id)
			this._id=value;
			DisplayObjectPort.saiman::getInstance().put(this)
			for(var i:int=0;i<array.length;i++)
			{
				if(array[i])
				{
					Elisor.getInstance().addOrder(array[i])
				}
			}
			
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set proto(value:Object):void
		{
			this.$proto=value;
		}
		
		public function get proto():Object
		{
			return $proto;
		}
		public function set oid(value:String):void
		{
			this.$oid=value
		}
		public function get oid():String
		{
			return this.$oid;
		}
		
		public function clone():IProto
		{
			var vo:Proto=new Proto
			vo.saiman::id=this._id;
			vo.saiman::oid=this.$oid;
			vo.proto=this.$proto
			return vo;
		}
		
		public function dispose():void
		{
			try{
				this.graphics.clear();
				if(this.parent)this.parent.removeChild(this)
				var array:Vector.<IOrder>=this.disposeGroupOrders(OrderMode.TOTAL)
				if(array){
					for(var i:int=0;i<array.length;i++)
					{
						var order:IOrder=array[i];
						if(order)order.dispose();
						order=null;
					}
				}
				DisplayObjectPort.saiman::getInstance().remove(this._id)
				array=null;
				this._id=null;
				this.$oid=null;
				this.$proto=null;
			}catch(e:Error){
				throw e;
			}
		}
	}
}
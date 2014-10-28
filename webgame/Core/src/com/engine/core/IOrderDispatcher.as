package com.engine.core
{
	import com.engine.core.controls.IOrder;
	import com.engine.core.model.IProto;
	
	import flash.events.IEventDispatcher;

	/**
	 *  命令指令派发接口
	 * @author saiman
	 * 
	 */	
	public interface IOrderDispatcher extends IEventDispatcher,IProto
	{
		function takeOrder(id:String,orderMode:String):IOrder
		function hasOrder(id:String,orderMode:String):Boolean;
		function removeOrder(id:String,orderMode:String):IOrder;
		function addOrder(order:IOrder):Boolean;
		function takeGroupOrders(orderMode:String):Vector.<IOrder>
		function disposeGroupOrders(orderMode:String):Vector.<IOrder>
	
		
	}
}
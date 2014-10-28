package com.engine.core.view
{
	/**
	 *  本引擎可是基类的实现接口.
	 *  <br>本接口主要作为本引擎可视基类BaseSprite提供接口声明。
	 *  <br>本接口继承自IOrderDispatcher，IOrderDispatcher接口包含了引擎资深事件，心跳机制实现的对外接口方法声明。
	 *  <br>同时，不接口还需实现如初始化，心跳事件等注册回收接口。
	 *  @author saiman
	 * 
	 */	
	import com.engine.core.IOrderDispatcher;
	import com.engine.core.controls.elisor.FrameOrder;
	import com.engine.core.model.IProto;
	
	import flash.events.IEventDispatcher;
	
	public interface IBaseSprite extends IOrderDispatcher
	{
		function _setTimeOut_(delay:int,action:Function, args:Array):void
		function onTimer(delay:int,action:Function,args:Array,callbackFunc:Function=null):FrameOrder
		function initialize():void;
		
	}
}
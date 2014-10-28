package com.engine.core.controls.model
{
	import com.engine.core.controls.service.IMessage;
	import com.engine.core.model.IProto;
	import com.engine.core.view.IBaseSprite;
	/**
	 * 模块接口 
	 * @author saiman 
	 * 
	 */	
	public interface IModule extends IProto
	{
		
		
		function get lock():Boolean
		/**
		 * 信息接受阀门 
		 * @return 
		 * 
		 */		
		function get valve():Boolean
		function set valve(value:Boolean):void
		/**
		 *  模块代理 
		 * @return 
		 * 
		 */		
		function get proxy():ModuleProxy
		/**
		 * 模块界面 
		 * @return 
		 * 
		 */			
		function get view():IBaseSprite
		function set view(value:IBaseSprite):void
		/**
		 * 注册一个模块 
		 * @param moduleName
		 * 
		 */			
		function register(moduleName:String):void
		/**
		 * 模块的信息发送接口 
		 * @param message
		 * 
		 */			
		function send(message:IMessage):void
		/**
		 * 模块对外的信息入口 
		 * @param message
		 * 
		 */			
		function subHandler(message:IMessage):void
		/**
		 *　初始化 
		 * 
		 */			
		
		
		function initialize():void
		/**
		 *  注册订阅器 
		 * @param cla
		 * 
		 */		
		function registerSub(...subs:Array):void
			
	}
}
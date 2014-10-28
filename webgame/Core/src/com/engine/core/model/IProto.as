package com.engine.core.model
{
	/**
	 *  核心原型信息载体接口
	 * 	该接口的定立用于解决后继开发对数据类型不同提供的解决方案。
	 * @author saiman
	 * @playerversion flashplayer 10
	 */	
	public interface IProto
	{
		/**
		 * 核心默认派发唯一id（可修改） 
		 * @param value
		 * 
		 */		
		function get id():String;
		
		/**
		 * 附加值 
		 * @param value
		 * 
		 */		
		function set proto(value:Object):void;
		function get proto():Object;
		/**
		 * 拥有者id 
		 * @param value
		 * 
		 */		
		function get oid():String;
		/**
		 * 拷贝 
		 * @return 返回一个数值对象的深度拷贝
		 * 
		 */		
		function  clone():IProto;
		/**
		 * 对象销毁 
		 * 
		 */		
		function dispose():void
			
		
	}
}
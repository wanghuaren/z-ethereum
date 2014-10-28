package com.engine.core.controls.service
{
	import com.engine.core.model.Proto;
	/**
	 * 信件头 
	 * @author saiman
	 * 
	 */	
	public class Head extends Proto
	{
		/**
		 * 信件类型 
		 */		
		public var messageType:String
		/**
		 * 收信方 
		 */		
		public var geters:Vector.<String>;
		/**
		 *　发信方 
		 */		
		public var sender:String
		
		public function Head()
		{
			super();
		}
		
	}
}
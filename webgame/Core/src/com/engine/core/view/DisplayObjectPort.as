package com.engine.core.view
{
	import com.engine.core.IOrderDispatcher;
	import com.engine.core.model.Proto;
	import com.engine.namespaces.saiman;
	import com.engine.utils.Hash;
	/**
	 * 核心可视对象实例池。所有本核心实现创建的相关可视实例都会注册到此管理池当中。 
	 * @author saiman
	 * 
	 */	
	public class DisplayObjectPort extends Proto
	{
		private static var _instance:DisplayObjectPort;
		private var hash:Hash
		
		public function DisplayObjectPort()
		{
		}
		
		saiman static function getInstance():DisplayObjectPort
		{
			if(_instance==null){
				_instance=new DisplayObjectPort
				_instance.hash=new Hash
			}
			return _instance
		}
		
		public function put(value:IOrderDispatcher):void
		{
			this.hash.put(value.id,value)
		}
		public function remove(id:String):IOrderDispatcher
		{
			return this.hash.remove(id) as IOrderDispatcher
		}
		public function has(id:String):Boolean
		{
			return  this.hash.has(id);
		}	
		
		public function task(id:String):IOrderDispatcher
		{
			return this.hash.take(id) as IOrderDispatcher
		}	
		public function get length():int
		{
			return this.hash.length;
		}
		
		override public  function dispose():void
		{
			for each(var item:IOrderDispatcher in this.hash)
			{
				item.dispose()
			}
			this.hash=null;
			_instance=null
		}
	}
}
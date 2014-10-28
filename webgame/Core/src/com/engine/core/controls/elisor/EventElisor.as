package com.engine.core.controls.elisor
{
	import com.engine.core.Core;
	import com.engine.core.controls.IOrder;
	import com.engine.core.model.Proto;
	import com.engine.namespaces.saiman;
	import com.engine.utils.Hash;
	
	import flash.utils.Dictionary;
	/**
	 *  事件管理器
	 * @author saiman
	 * 
	 */
	public class EventElisor extends Proto
	{
		/**
		 * @private 事件管理器的单例 
		 */		
		private static var _instance:EventElisor;
		/**
		 * 存储事件指令的字典对象 
		 */		
		private var _hash:Dictionary
		/**
		 * 管理器中注册的指令数目 
		 */		
		private var _len:int
		public function EventElisor()
		{
			super();
		}
		/**
		 * @private 
		 * 事件管理器的调用方法。该方法受saiman命名空间限制。对外调用必须使用saiman命名空间方可访问。
		 * @return 
		 * 
		 */		
		saiman static function getInstance():EventElisor
		{
			if(_instance==null){
				_instance=new EventElisor
				_instance.initialize();
			}
			return  _instance
		}
		/**
		 * 返回指令管理器里注册的指令长度 
		 * @return 
		 * 
		 */		
		public function get len():int
		{	
			return _len;
		}
		/**
		 *　　 初始化方法 
		 * 
		 */		
		public function initialize():void
		{
			_hash=new Dictionary;
			
		}
		/**
		 *   注册一个事件指令对象 
		 * @param order
		 * @param override
		 * @return 
		 * 
		 */		
		public function addOrder(order:EventOrder,override:Boolean=false):Boolean
		{
			if(order==null)return false;
			if(order.type==null||order.oid==null)return false;
			if(this._hash[order.oid]==null)this._hash[order.oid]=new Dictionary;
			if(this._hash[order.oid][order.type]==null)
			{
				this._hash[order.oid][order.type]=order;
				this._len++
			}else if(override&&this._hash[order.oid][order.type]){
				delete this._hash[order.oid][order.type]
					this._hash[order.oid][order.type]=order
			}
			return true;
		}
		/**
		 * 根据一个id移除一个指令 
		 * @param id
		 * @return 
		 * 
		 */		
		public function removeOrder(id:String):EventOrder
		{
			if(this._hash==null)return null;
			var strs:Array=id.split(Core.SIGN)
			if(strs.length!=2)return null;
			var oid:String=strs[0]
			var type:String=strs[1];
			if(this._hash[oid]==null)return null;
			return this._hash[oid][type] as EventOrder;
		}
		/**
		 *　根据一个id判断一个指令是否存在 
		 * @param id
		 * @return 
		 * 
		 */		
		public function hasOrder(id:String):Boolean
		{
			if(this._hash==null)return false;
			var strs:Array=id.split(Core.SIGN)
			if(strs.length!=2)return false;
			var oid:String=strs[0]
			var type:String=strs[1];
			if(this._hash[oid]==null)return false;
			if(this._hash[oid][type]==null)return false
			return  true;
		}
		/**
		 *　根据一个指令id获取一个指令 
		 * @param id
		 * @return 
		 * 
		 */		
		public function takeOrder(id:String):EventOrder
		{
			if(this._hash==null)return null;
			var strs:Array=id.split(Core.SIGN)
			if(strs.length!=2)return null;
			var oid:String=strs[0]
			var type:String=strs[1];
			if(this._hash[oid]==null)return null;
			return this._hash[oid][type] as EventOrder
		}
		/**
		 *　根据一个拥有者id判断是否存在对应的拥有者指令组 
		 * @param gid
		 * @return 
		 * 
		 */		
		public function hasGroup(gid:String):Boolean
		{
			if(this._hash==null)return false;
			if(this._hash[gid]!=null)return true;
			return false;
		}
		/**
		 *　根据一个指令组id返回其在事件管理器里注册的所有事件指令 
		 * @param gid　
		 * @return 
		 * 
		 */		
		public function takeGroupOrder(gid:String):Vector.<IOrder>
		{
			var array:Vector.<IOrder>=new Vector.<IOrder>
			if(this._hash==null)return array;
			if(this._hash[gid]==null)return array;
			var source:Dictionary=this._hash[gid]
			for each(var order:EventOrder in source)
			{
				array.push(order)
			}
			return array
		}
		/**
		 * 根据一个拥有者id销毁它在事件管理器里注册的所有对象 
		 * @param gid
		 * @return 
		 * 
		 */		
		public function disposeGroupOrders(gid:String):Vector.<IOrder>
		{
			var array:Vector.<IOrder>=new Vector.<IOrder>
			if(this._hash==null)return array;
			if(this._hash[gid]==null)return array;
			var source:Dictionary=this._hash[gid]
			delete this._hash[gid];
			for each(var order:EventOrder in source)
			{
				array.push(order)
			}
			return array
		}
		/**
		 * 销毁事件管理器 
		 * 
		 */		
		override public function dispose():void
		{
			if(this._hash)
			{
				for(var i:String in this._hash)
				{
					delete this._hash[i]
				}
			}
			this._hash=null;
			_instance=null
			super.dispose();
		}
		
		
	}
}
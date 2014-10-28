package com.engine.utils
{
	import com.engine.core.model.Proto;
	import com.engine.namespaces.saiman;
	/**
	 * 链状哈希表元素类型 
	 * @author saiman
	 * 
	 */	
	public class Chain extends Proto
	{
		private var _index:int;
		
		public function Chain()
		{
			super();
		}
		public function get index():int
		{
			return this._index
		}
		/**
		 * 改索引值由链状哈希表自身维护，不要认为修改 
		 * @param value
		 * 
		 */		
		saiman function set index(value:int):void
		{
			this._index=value
		}
		
		
		
		
	}
}
package com.engine.utils
{
	import com.engine.namespaces.saiman;
	
	import flash.utils.Dictionary;
	
	public class Hash 
	{
		private var _length:int
		private var _hash:Dictionary
		
		public function Hash()
		{
			_length=0;
			_hash=new Dictionary
		}
		/**
		 * 根据一个键值存储对象 
		 * @param key
		 * @param value
		 * 
		 */		
		public function put(key:String,value:Object):void
		{
			if(this.has(key)==false){
				_hash[key]=value;
				this._length++
			}else {
				remove(key)
				_hash[key]=value;
				this._length++
			}
		}
		/**
		 * 删除一个键值对应的对象 
		 * @param key
		 * 
		 */		
		public function remove(key:String):Object
		{
			if(this.has(key)){
				var item:Object=_hash[key];
				delete _hash[key]
				this._length--;
				return item;
			}
			return null
		}
		/**
		 * 判断是否存在键值对应的对象 
		 * @param key
		 * @return 
		 * 
		 */		
		public function has(key:String):Boolean
		{
			if(_hash[key]!=null)return true;
			return false;
		}
		/**
		 * 根据一个键值查询对象 
		 * @param key
		 * @return 
		 * 
		 */		
		public function take(key:String):Object
		{
			return _hash[key]
		}
		/**
		 * 当前长度 
		 * @return 
		 * 
		 */		
		public function get length():int
		{
			return _length;
		}
		/**
		 * 返回字典对象 
		 * @return 
		 * 
		 */		
		public function get hash():Dictionary
		{
			return this._hash
		}
		/**
		 * 销毁 
		 * 
		 */		
		public function dispose():void
		{
			_hash=null;
			this._length=0;
		}
		/**
		 *  深度销毁
		 * 
		 */		
		saiman function dispose():void
		{
			for(var i:String in this._hash)
			{
				delete this._hash[i]
			}
			this._hash=null;
			this._length=0;
		}
		/**
		 * 返回对象对列 
		 * @return 
		 * 
		 */		
		saiman function values():Array
		{
			var array:Array=[];
			for each (var item:Object in this._hash)
			{
				array.push(item)
			}
			return array;
		}
		
		saiman function takekey():String
		{
			for each (var item:Object in this._hash )
			{
				return item.id as String;
			}
			return null
		}
	}
}
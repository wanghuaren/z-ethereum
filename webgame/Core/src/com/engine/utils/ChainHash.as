package com.engine.utils
{
	import com.engine.namespaces.saiman;
	
	import flash.utils.Dictionary;
	/**
	 * 链状哈希表 
	 * @author saiman
	 * 
	 */
	public class ChainHash
	{
		private var _hash:Dictionary
		private var _array:Array
		private var _length:int
		public function ChainHash()
		{
			_hash=new Dictionary
			this._array=new Array
			this._length=0
		}
		public function get length():int
		{
			return _length
		}
		public function has(key:String):Boolean
		{
			if(this._hash[key])return true;
			return false;
		}
		public function addElement(key:String,value:Chain):void
		{
			
			if(this._hash[key]==null)
			{
				this._hash[key]=value;
				value.saiman::index=_length
				this._array.push(value)
				this._length+=1;
			}
		}
		public function addElementAt(index:int,value:Chain):void
		{
			if(this.has(value.id)){
				this._array.splice(value.index,1) as Chain;
				if(index>=this._length)
				{
					value.saiman::index=_length;
					this._array.push(value);
					
				}else {
					this._array.splice(index,0,value);
					value.saiman::index=index;
				}
				
			}else {
				this._hash[value.id]=value;
				if(index>=this.length)
				{
					value.saiman::index=_length;
					this._array.push(value);
				}else {
					this._array.splice(index,0,value);
					value.saiman::index=index;
				}
				this._length+=1;
			}
		}
		public function removeElement(key:String):Chain
		{
			if(this._hash[key]!=null)
			{
				var chain:Chain=this._hash[key]
				delete this._hash[key]
				this._array.splice(chain.index,1);
				this._length-=1;
				for(var i:int=chain.index;i<this._length;i++)
				{
					chain=this._array[i];
					chain.saiman::index=i;
				}
				return chain
				
			}
			return null
		}
		public function removeElementAt(index:int):Chain
		{
			if(index<this._length)
			{
				var chain:Chain=this._array.splice(chain.index,1);
				this._length-=1;
				delete this._hash[chain.id]
				for(var i:int=chain.index;i<this._length;i++)
				{
					chain=this._array[i];
					chain.saiman::index=i;
				}
				return chain
			}
			return null
		}
		
		public function takeElement(key:String):Chain
		{
			return this._hash[key] as Chain;
		}
		
		public function takeElementAt(index:int):Chain
		{
			if(index>=this.length)return null;
			return this._array[index] as Chain;
		}
		
		public function array():Array
		{
			return this._array.slice();
		}
	}
}
package com.bellaxu.struct
{
	import avmplus.getQualifiedClassName;
	
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	
	/**
	 * 	哈希表
	 * @author saiman
	 * @since asswc.com;
	 * @see http://www.asswc.com
	 *
	 * @example 示例说明:
	 * <listing version="3.0">
	 *   var hash:Hash=new Hash 
	 *   hash.put('key',2)
	 * 	 trace(hash.has('key'));
	 * 	 trace(hash.task('key'));
	 * </listing>
	 *
	 **/
	public dynamic class Hash extends Dictionary
	{
		private static var instanceKey:int=int.MAX_VALUE
		private var _length_:int
		private var _className_:String;
		private var _id_:String;
		private var _oid_:String;
		private var _proto_:Object;
		
		public function Hash()
		{
			this.id=instanceKey.toString(16);
			instanceKey--;
			flash.net.registerClassAlias('saiman.save.Hash',Hash);
			_className_=getQualifiedClassName(this)
			super(false);
		}
		
		/**
		 *  返回Key对应的存储对象 
		 * @param key
		 * @return 
		 * 
		 */		
		
		public function take(key:Object):Object
		{
			return this[key];
		}
		/**
		 *   根据一个Key存储一个对象 
		 *   <br/>注意：键名不能为Hash对象的已有属性 length,proto,id,oid,className其中之一否则将不予存储
		 * @param key 存储查询的Key
		 * @param value 存储对象
		 * @param replace 当对应的Key已存在时，通过设置该值来决定是否替换已有的存储对象，true:替换，false:不替换，
		 * @throw Error('存储key与对象现有属性冲突！')
		 * 
		 */		
		public function put(key:Object,value:Object,replace:Boolean=false):void
		{
			var bo:Boolean=hasOwnProperty(key);
			if(!replace&&!bo)
			{
				this[key]=value;
			}else if(replace){
				if(key!='length'&&key!='proto'&&key!='id'&&key!='oid'&&key!='className')
				this[key]=value;
				else throw new Error('存储key值:"'+key+'"与对象固有属性名冲突！');
			}
			if(!bo)_length_++;
		}
		/**
		 *  是否存在某Key对应的对象 
		 * @param key
		 * @return 
		 * 
		 */		
		public function has(key:Object):Boolean
		{
			return hasOwnProperty(key);
		}
		/**
		 *  移除一个对象 
		 * @param key
		 * @return 
		 * 
		 */		
		public function remove(key:Object):Object
		{
			var bo:Boolean=hasOwnProperty(key);
			var tar:Object=this[key];
			delete this[key];
			if(bo)_length_--;
			return tar;
		}
		/**
		 *  存储对象数目 
		 * @return 
		 * 
		 */		
		public function get length ():int
		{
			return _length_;
		}
		
		/**
		 *  唯一ID通常只读，特定对象要可以专门修改
		 * 
		 */	
		public function get id():String
		{
			return _id_;
		}
		public function set id(value:String):void
		{
			_id_=value;
		}
		/**
		 * 拥有者ID
		 * 
		 */	
		public function get oid():String
		{
			return _oid_;
		}
		public function set oid(value:String):void
		{
			_oid_=value;
		}
		/**
		 * 绑定数据对象
		 * 
		 */	
		public function get proto():Object
		{
			return _proto_;
		}
		public function set proto(value:Object):void
		{
			_proto_=value;
		}
		
		/**
		 * 数据对象的析构方法。 
		 **/
		public function dispose():void
		{
			this._proto_=null;
			this._oid_=null;
			this._id_=null;
			this._length_=0;
			for(var key:String in this)
			{
				delete this[key];
			}
			
		}
		/**
		 *  字符输出  
		 * @return 
		 * 
		 */		
		public function toString():String
		{
			return super.toString();
		}
		/**
		 *  原型分类 
		 * @return 
		 * 
		 */		
		public function get className():String
		{
			return _className_;
		}
	}
}
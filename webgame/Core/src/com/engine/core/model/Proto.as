package com.engine.core.model
{

	import com.engine.core.Core;
	import com.engine.core.controls.elisor.FrameElisor;
	import com.engine.namespaces.saiman;
	import com.engine.utils.ObjectUtils;
	
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *  核心原型信息载体接口
	 * 	<br>该接口的定立用于解决后继开发对数据类型不同提供的解决方案。
	 * 	<br>保留seter及geter以保持封装性。注意：频繁操作属性要声明Public
	 * @author saiman
	 * @playerversion flashplayer 10
	 */	
	public class Proto extends Object implements IProto
	{
		protected var $proto:Object;
		protected var $id:String;
		protected var $oid:String;
		
		
		
		public function Proto()
		{
			super();
			flash.net.registerClassAlias('saiman.save.ProtoVo',Proto);
			if(this.$id==null)this.$id=Core.SIGN+Core.saiman::nextInstanceIndex().toString(16)
		}

		
		/**
		 * 拥有者id 
		 */
		public function get oid():String
		{
			return $oid;
		}

		/**
		 * @private
		 */
		saiman function set oid(value:String):void
		{
			if($oid!=value)$oid = value;
		}

		/**
		 * 唯一id 
		 */
		public function get id():String
		{
			return $id;
		}

		/**
		 * @private
		 */
		saiman function set id(value:String):void
		{
			if($id!=value)$id = value;
		}

		/**
		 * 绑定数据 
		 */
		public function get proto():Object
		{
			return $proto;
		}

		/**
		 * @private
		 */
		public function set proto(value:Object):void
		{
			$proto = value;
		}

		/**
		 * 拷贝 (对象拷贝属于消耗操作，避免大量同时使用)
		 * @return 返回实例的数值拷贝对象
		 * 
		 */		
		public function clone():IProto
		{
			return ObjectUtils.copy(this) as IProto;
		}
		/**
		 * 对象销毁 
		 * 
		 */		
		public function dispose():void
		{
			if(!Core.sandBoxEnabled)return;
			this.proto=null;
			this.$oid=null;
			this.$id=null
			
			
		}
		/**
		 * 字符串输出 
		 * @return 
		 * 
		 */		
		public function toString():String
		{
			var name:String=getQualifiedClassName(this)
			return '['+name.substr(name.indexOf('::')+2,name.length)+' '+id+']'
		}
	}
}
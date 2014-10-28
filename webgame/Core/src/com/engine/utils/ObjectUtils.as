package com.engine.utils
{
	import flash.utils.ByteArray;
	/**
	 * 对象管理工具类
	 * @author saiman
	 * @playerversion flashplayer 10
	 */	
	public class ObjectUtils
	{
		public function ObjectUtils()
		{
		}
		/**
		 * 对象拷贝 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function copy(value:Object):Object
		{
			
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.position = 0;
			var result:Object = buffer.readObject();
			return result;
		}

	}
}
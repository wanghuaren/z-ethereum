package engine.support 
{
	import flash.utils.ByteArray;
	
	public interface ISerializable
	{
		/**
		 * 将对象序列化到字节流中
		 * @param ByteArray
		 * @param ar
		 * 
		 */
		function Serialize(ar:ByteArray):void;
		
		/**
		 * 从字节流中反序列化出对象数据
		 * @param ByteArray
		 * @param ar
		 * 
		 */		
		function Deserialize(ar:ByteArray):void; 
	}
}
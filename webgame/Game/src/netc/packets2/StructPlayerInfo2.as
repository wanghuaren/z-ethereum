/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量 
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *  
 */ 
package netc.packets2
{
	import flash.utils.ByteArray;
	
	import netc.Data;
	
	import engine.support.IPacket;
	import engine.support.ISerializable;
	import engine.net.packet.PacketFactory;
	import nets.packets.StructPlayerInfo;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;

	/** 
	 *
	 */
	public class StructPlayerInfo2 extends StructPlayerInfo
	{
		/** 
		 *皮肤数据
		 */
		public var  filePath:BeingFilePath;
	
		public function get isSameCamp():Boolean
		{
			return FileManager.instance.isSameCmap(Data.myKing.campid,this.camp);
		}
		
		
	}
}

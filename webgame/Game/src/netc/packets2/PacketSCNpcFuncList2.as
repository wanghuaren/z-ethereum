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
	import engine.support.ISerializable;
	import engine.support.IPacket;
	import engine.net.packet.PacketFactory;
	import nets.packets.PacketSCNpcFuncList
		/** 
		 * 行走，由服务器通知
		 */
		public class PacketSCNpcFuncList2 extends PacketSCNpcFuncList
		{
			
		}
}

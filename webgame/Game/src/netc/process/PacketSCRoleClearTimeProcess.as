/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	
	import nets.ipacket.*;
	
	import netc.packets2.PacketSCRoleClearTime2;
	
	public class PacketSCRoleClearTimeProcess extends PacketBaseProcess
	{
		public function PacketSCRoleClearTimeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCRoleClearTime2 = pack as PacketSCRoleClearTime2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
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
	import netc.packets2.PacketSCTaskStatus2;
	
	public class PacketSCTaskStatusProcess extends PacketBaseProcess
	{
		public function PacketSCTaskStatusProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCTaskStatus2 = pack as PacketSCTaskStatus2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
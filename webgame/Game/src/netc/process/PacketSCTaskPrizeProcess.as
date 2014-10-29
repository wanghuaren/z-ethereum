/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.support.IPacket;
	import nets.packets.PacketGCServerList;
	import nets.packets.PacketSCSelectServer;
	
	import netc.packets2.PacketSCTaskPrize2;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	
	import netc.packets2.PacketSCSelectServer2;
	
	public class PacketSCTaskPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCTaskPrizeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCTaskPrize2 = pack as PacketSCTaskPrize2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
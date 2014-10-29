/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCKickLeftSign2;
	
	import engine.support.IPacket;
	
	public class PacketSCKickLeftSignProcess extends PacketBaseProcess
	{
		public function PacketSCKickLeftSignProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCKickLeftSign2 = pack as PacketSCKickLeftSign2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}
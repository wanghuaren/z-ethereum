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
	import netc.packets2.PacketWSTeamBuffSet2;
	
	import nets.ipacket.*;
	
	public class PacketWSTeamBuffSetProcess extends PacketBaseProcess
	{
		public function PacketWSTeamBuffSetProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketWSTeamBuffSet2 = pack as PacketWSTeamBuffSet2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//			
			
			return p;
		}
	}
}
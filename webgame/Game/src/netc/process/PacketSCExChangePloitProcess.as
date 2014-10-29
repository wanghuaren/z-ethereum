package netc.process
{
	import flash.utils.getQualifiedClassName;
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import nets.*;
	import netc.packets2.PacketSCExChangePloit2;
	
	public class PacketSCExChangePloitProcess extends PacketBaseProcess
	{
		public function PacketSCExChangePloitProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			var p:PacketSCExChangePloit2 = pack as PacketSCExChangePloit2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}

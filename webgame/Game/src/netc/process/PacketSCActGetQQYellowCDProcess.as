package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import nets.*;
	import netc.packets2.PacketSCActGetQQYellowCD2;
	
	public class PacketSCActGetQQYellowCDProcess extends PacketBaseProcess
	{
		public function PacketSCActGetQQYellowCDProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			var p:PacketSCActGetQQYellowCD2 = pack as PacketSCActGetQQYellowCD2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}

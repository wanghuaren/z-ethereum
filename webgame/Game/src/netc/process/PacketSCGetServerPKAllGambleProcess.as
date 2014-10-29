package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetServerPKAllGamble2;
	
	import engine.support.IPacket;
	
	public class PacketSCGetServerPKAllGambleProcess extends PacketBaseProcess
	{
		public function PacketSCGetServerPKAllGambleProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCGetServerPKAllGamble2 = pack as PacketSCGetServerPKAllGamble2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
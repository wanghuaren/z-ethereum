package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetServerPKCamble2;
	
	import engine.support.IPacket;
	
	public class PacketSCGetServerPKCambleProcess extends PacketBaseProcess
	{
		public function PacketSCGetServerPKCambleProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCGetServerPKCamble2 = pack as PacketSCGetServerPKCamble2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
	}
}
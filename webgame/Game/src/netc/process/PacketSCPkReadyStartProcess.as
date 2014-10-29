package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCPkReadyStart2;
	
	import engine.support.IPacket;
	
	public class PacketSCPkReadyStartProcess extends PacketBaseProcess
	{
		public function PacketSCPkReadyStartProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCPkReadyStart2 = pack as PacketSCPkReadyStart2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
		
	}
}
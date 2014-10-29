package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCPkNewsUpdate2;
	
	import engine.support.IPacket;
	
	public class PacketSCPkNewsUpdateProcess extends PacketBaseProcess
	{
		public function PacketSCPkNewsUpdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCPkNewsUpdate2 = pack as PacketSCPkNewsUpdate2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
	}
}
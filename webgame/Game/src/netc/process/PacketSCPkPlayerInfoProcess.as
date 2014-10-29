package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCPkPlayerInfo2;
	
	import engine.support.IPacket;
	
	public class PacketSCPkPlayerInfoProcess extends PacketBaseProcess
	{
		public function PacketSCPkPlayerInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCPkPlayerInfo2 = pack as PacketSCPkPlayerInfo2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
		
	}
}
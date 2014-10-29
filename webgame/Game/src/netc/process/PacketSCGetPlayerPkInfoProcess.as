package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetPlayerPkInfo2;
	
	import engine.support.IPacket;
	
	public class PacketSCGetPlayerPkInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetPlayerPkInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCGetPlayerPkInfo2 = pack as PacketSCGetPlayerPkInfo2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
	}
}
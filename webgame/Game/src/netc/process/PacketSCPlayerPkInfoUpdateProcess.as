package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCPlayerPkInfoUpdate2;
	
	import engine.support.IPacket;
	
	public class PacketSCPlayerPkInfoUpdateProcess extends PacketBaseProcess
	{
		public function PacketSCPlayerPkInfoUpdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCPlayerPkInfoUpdate2 = pack as PacketSCPlayerPkInfoUpdate2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			
			//step 2		
			
			return p;
		}
	}
}
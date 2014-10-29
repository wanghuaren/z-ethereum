package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetServerPKSelfInfo2;
	
	import engine.support.IPacket;
	
	public class PacketSCGetServerPKSelfInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetServerPKSelfInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCGetServerPKSelfInfo2 = pack as PacketSCGetServerPKSelfInfo2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetServerPKResult2;
	
	import engine.support.IPacket;
	
	public class PacketSCGetServerPKResultProcess extends PacketBaseProcess
	{
		public function PacketSCGetServerPKResultProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCGetServerPKResult2 = pack as PacketSCGetServerPKResult2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
	}
}
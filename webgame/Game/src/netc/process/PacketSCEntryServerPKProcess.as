package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCEntryServerPK2;
	
	import engine.support.IPacket;
	
	public class PacketSCEntryServerPKProcess extends PacketBaseProcess
	{
		public function PacketSCEntryServerPKProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketSCEntryServerPK2 = pack as PacketSCEntryServerPK2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
	}
}
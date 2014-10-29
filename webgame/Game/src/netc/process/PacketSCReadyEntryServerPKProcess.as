package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCReadyEntryServerPK2;
	
	import engine.support.IPacket;
	
	public class PacketSCReadyEntryServerPKProcess extends PacketBaseProcess
	{
		public function PacketSCReadyEntryServerPKProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketSCReadyEntryServerPK2 = pack as PacketSCReadyEntryServerPK2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
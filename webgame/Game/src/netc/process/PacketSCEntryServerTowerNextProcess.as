package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCEntryServerTowerNext2;
	
	import engine.support.IPacket;
	
	public class PacketSCEntryServerTowerNextProcess extends PacketBaseProcess
	{
		public function PacketSCEntryServerTowerNextProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCEntryServerTowerNext2 = pack as PacketSCEntryServerTowerNext2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
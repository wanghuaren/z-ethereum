package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCEntryServerTower2;
	
	import engine.support.IPacket;
	
	public class PacketSCEntryServerTowerProcess extends PacketBaseProcess
	{
		public function PacketSCEntryServerTowerProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCEntryServerTower2 = pack as PacketSCEntryServerTower2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGodEquipFound2;
	
	import engine.support.IPacket;
	
	public class PacketSCGodEquipFoundProcess extends PacketBaseProcess
	{
		public function PacketSCGodEquipFoundProcess()
		{
			super();
		}
		
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCGodEquipFound2 = pack as PacketSCGodEquipFound2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			//DataCenter.packZone.put(p.GetId(),p);
			
			return p;
		}
		
		
	}
}
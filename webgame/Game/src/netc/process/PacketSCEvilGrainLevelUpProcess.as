package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCEvilGrainLevelUp2;
	
	import engine.support.IPacket;
	
	public class PacketSCEvilGrainLevelUpProcess extends PacketBaseProcess
	{
		public function PacketSCEvilGrainLevelUpProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCEvilGrainLevelUp2 = pack as PacketSCEvilGrainLevelUp2;
			
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
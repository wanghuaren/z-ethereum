package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGodStoneCompose2;
	
	import engine.support.IPacket;
	
	public class PacketSCGodStoneComposeProcess extends PacketBaseProcess
	{
		public function PacketSCGodStoneComposeProcess()
		{
			super();
		}
		
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCGodStoneCompose2 = pack as PacketSCGodStoneCompose2;
			
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
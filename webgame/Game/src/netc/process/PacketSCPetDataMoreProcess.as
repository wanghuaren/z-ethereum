package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCPetDataMore2;
	
	import nets.*;
	
	public class PacketSCPetDataMoreProcess extends PacketBaseProcess
	{
		public function PacketSCPetDataMoreProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			var p:PacketSCPetDataMore2 = pack as PacketSCPetDataMore2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//Data.huoBan.setPetMoreList(p);
			
			return p;
		}
	}
}

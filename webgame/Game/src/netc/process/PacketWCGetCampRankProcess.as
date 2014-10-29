package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCGetCampRank2;
	
	import engine.support.IPacket;
	
	public class PacketWCGetCampRankProcess extends PacketBaseProcess
	{
		public function PacketWCGetCampRankProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketWCGetCampRank2 = pack as PacketWCGetCampRank2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}


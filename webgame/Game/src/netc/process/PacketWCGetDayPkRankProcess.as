package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCGetDayPkRank2;
	
	import engine.support.IPacket;
	
	public class PacketWCGetDayPkRankProcess extends PacketBaseProcess
	{
		public function PacketWCGetDayPkRankProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketWCGetDayPkRank2 = pack as PacketWCGetDayPkRank2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCGetWeekPkRank2;
	
	import engine.support.IPacket;
	
	public class PacketWCGetWeekPkRankProcess extends PacketBaseProcess
	{
		public function PacketWCGetWeekPkRankProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketWCGetWeekPkRank2 = pack as PacketWCGetWeekPkRank2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
	}
}
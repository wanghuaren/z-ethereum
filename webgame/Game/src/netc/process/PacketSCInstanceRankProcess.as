package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCInstanceRank2;
	
	import engine.support.IPacket;
	
	public class PacketSCInstanceRankProcess extends PacketBaseProcess
	{
		public function PacketSCInstanceRankProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCInstanceRank2 = pack as PacketSCInstanceRank2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			Data.moTian.syncByInstanceRankList(p);
			
			return p;
		}
	}
}
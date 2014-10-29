package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCGetSHRank2;
	
	public class PacketSCGetSHRankProcess extends PacketBaseProcess
	{
		public function PacketSCGetSHRankProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSHRank2=pack as PacketSCGetSHRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
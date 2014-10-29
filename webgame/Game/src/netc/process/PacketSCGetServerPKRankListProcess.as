package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetServerPKRankList2;

	public class PacketSCGetServerPKRankListProcess extends PacketBaseProcess
	{
		public function PacketSCGetServerPKRankListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetServerPKRankList2=pack as PacketSCGetServerPKRankList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
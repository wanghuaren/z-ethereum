package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetSSPKRankList2;

	public class PacketSCGetSSPKRankListProcess extends PacketBaseProcess
	{
		public function PacketSCGetSSPKRankListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSSPKRankList2=pack as PacketSCGetSSPKRankList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
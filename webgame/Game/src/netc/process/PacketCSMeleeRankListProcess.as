package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSMeleeRankList2;

	public class PacketCSMeleeRankListProcess extends PacketBaseProcess
	{
		public function PacketCSMeleeRankListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSMeleeRankList2=pack as PacketCSMeleeRankList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
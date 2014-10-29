package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWGetDayPkRank2;

	public class PacketCWGetDayPkRankProcess extends PacketBaseProcess
	{
		public function PacketCWGetDayPkRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWGetDayPkRank2=pack as PacketCWGetDayPkRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
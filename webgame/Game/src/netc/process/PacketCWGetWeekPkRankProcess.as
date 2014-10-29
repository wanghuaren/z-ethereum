package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWGetWeekPkRank2;

	public class PacketCWGetWeekPkRankProcess extends PacketBaseProcess
	{
		public function PacketCWGetWeekPkRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWGetWeekPkRank2=pack as PacketCWGetWeekPkRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetChineseNewYearRank2;

	public class PacketCSGetChineseNewYearRankProcess extends PacketBaseProcess
	{
		public function PacketCSGetChineseNewYearRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetChineseNewYearRank2=pack as PacketCSGetChineseNewYearRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
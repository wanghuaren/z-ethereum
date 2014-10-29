package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetDayPrizeListInfo2;

	public class PacketCSGetDayPrizeListInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetDayPrizeListInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetDayPrizeListInfo2=pack as PacketCSGetDayPrizeListInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetDayLimitPrize2;

	public class PacketCSGetDayLimitPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetDayLimitPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetDayLimitPrize2=pack as PacketCSGetDayLimitPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
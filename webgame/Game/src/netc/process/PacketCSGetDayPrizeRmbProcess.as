package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetDayPrizeRmb2;

	public class PacketCSGetDayPrizeRmbProcess extends PacketBaseProcess
	{
		public function PacketCSGetDayPrizeRmbProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetDayPrizeRmb2=pack as PacketCSGetDayPrizeRmb2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
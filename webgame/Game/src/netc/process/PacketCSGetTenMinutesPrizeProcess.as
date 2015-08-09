package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetTenMinutesPrize2;

	public class PacketCSGetTenMinutesPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetTenMinutesPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetTenMinutesPrize2=pack as PacketCSGetTenMinutesPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
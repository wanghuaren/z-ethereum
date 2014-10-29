package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetTenMinutesPrize2;

	public class PacketSCGetTenMinutesPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetTenMinutesPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetTenMinutesPrize2=pack as PacketSCGetTenMinutesPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
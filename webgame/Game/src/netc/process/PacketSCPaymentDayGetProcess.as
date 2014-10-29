package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCPaymentDayGet2;

	public class PacketSCPaymentDayGetProcess extends PacketBaseProcess
	{
		public function PacketSCPaymentDayGetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCPaymentDayGet2=pack as PacketSCPaymentDayGet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
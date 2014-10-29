package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetStartPayment2;

	public class PacketCSGetStartPaymentProcess extends PacketBaseProcess
	{
		public function PacketCSGetStartPaymentProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetStartPayment2=pack as PacketCSGetStartPayment2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
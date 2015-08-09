package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCPaymentOncePay2;

	public class PacketSCPaymentOncePayProcess extends PacketBaseProcess
	{
		public function PacketSCPaymentOncePayProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCPaymentOncePay2=pack as PacketSCPaymentOncePay2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
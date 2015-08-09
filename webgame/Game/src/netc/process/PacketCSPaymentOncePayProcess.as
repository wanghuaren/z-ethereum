package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPaymentOncePay2;

	public class PacketCSPaymentOncePayProcess extends PacketBaseProcess
	{
		public function PacketCSPaymentOncePayProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPaymentOncePay2=pack as PacketCSPaymentOncePay2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
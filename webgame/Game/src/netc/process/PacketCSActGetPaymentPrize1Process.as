package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetPaymentPrize12;

	public class PacketCSActGetPaymentPrize1Process extends PacketBaseProcess
	{
		public function PacketCSActGetPaymentPrize1Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetPaymentPrize12=pack as PacketCSActGetPaymentPrize12;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
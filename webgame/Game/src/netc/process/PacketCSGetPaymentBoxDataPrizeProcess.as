package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetPaymentBoxDataPrize2;

	public class PacketCSGetPaymentBoxDataPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetPaymentBoxDataPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetPaymentBoxDataPrize2=pack as PacketCSGetPaymentBoxDataPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
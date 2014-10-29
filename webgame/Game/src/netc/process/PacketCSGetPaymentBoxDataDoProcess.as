package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetPaymentBoxDataDo2;

	public class PacketCSGetPaymentBoxDataDoProcess extends PacketBaseProcess
	{
		public function PacketCSGetPaymentBoxDataDoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetPaymentBoxDataDo2=pack as PacketCSGetPaymentBoxDataDo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
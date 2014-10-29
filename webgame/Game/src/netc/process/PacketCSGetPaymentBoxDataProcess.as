package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetPaymentBoxData2;

	public class PacketCSGetPaymentBoxDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetPaymentBoxDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetPaymentBoxData2=pack as PacketCSGetPaymentBoxData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
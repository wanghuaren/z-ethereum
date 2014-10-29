package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetStartPaymentState2;

	public class PacketCSGetStartPaymentStateProcess extends PacketBaseProcess
	{
		public function PacketCSGetStartPaymentStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetStartPaymentState2=pack as PacketCSGetStartPaymentState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPaymentOnceGet2;

	public class PacketCSPaymentOnceGetProcess extends PacketBaseProcess
	{
		public function PacketCSPaymentOnceGetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPaymentOnceGet2=pack as PacketCSPaymentOnceGet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
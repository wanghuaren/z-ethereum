package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPaymentDayGet2;

	public class PacketCSPaymentDayGetProcess extends PacketBaseProcess
	{
		public function PacketCSPaymentDayGetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPaymentDayGet2=pack as PacketCSPaymentDayGet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
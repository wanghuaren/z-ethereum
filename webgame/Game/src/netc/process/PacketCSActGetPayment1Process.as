package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetPayment12;

	public class PacketCSActGetPayment1Process extends PacketBaseProcess
	{
		public function PacketCSActGetPayment1Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetPayment12=pack as PacketCSActGetPayment12;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
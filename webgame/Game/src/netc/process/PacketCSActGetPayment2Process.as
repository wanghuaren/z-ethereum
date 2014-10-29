package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetPayment22;

	public class PacketCSActGetPayment2Process extends PacketBaseProcess
	{
		public function PacketCSActGetPayment2Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetPayment22=pack as PacketCSActGetPayment22;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetPayment2Data2;

	public class PacketCSActGetPayment2DataProcess extends PacketBaseProcess
	{
		public function PacketCSActGetPayment2DataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetPayment2Data2=pack as PacketCSActGetPayment2Data2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCSubtractGold2;

	public class PacketWCSubtractGoldProcess extends PacketBaseProcess
	{
		public function PacketWCSubtractGoldProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCSubtractGold2=pack as PacketWCSubtractGold2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
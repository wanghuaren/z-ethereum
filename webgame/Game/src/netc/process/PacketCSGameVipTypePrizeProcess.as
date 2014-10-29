package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGameVipTypePrize2;

	public class PacketCSGameVipTypePrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGameVipTypePrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGameVipTypePrize2=pack as PacketCSGameVipTypePrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
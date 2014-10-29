package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGameVipTypePrizeNum2;

	public class PacketCSGameVipTypePrizeNumProcess extends PacketBaseProcess
	{
		public function PacketCSGameVipTypePrizeNumProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGameVipTypePrizeNum2=pack as PacketCSGameVipTypePrizeNum2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
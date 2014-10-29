package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSHPrizeInfo2;

	public class PacketCSGetSHPrizeInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetSHPrizeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSHPrizeInfo2=pack as PacketCSGetSHPrizeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetArrowPrizeList2;

	public class PacketCSGetArrowPrizeListProcess extends PacketBaseProcess
	{
		public function PacketCSGetArrowPrizeListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetArrowPrizeList2=pack as PacketCSGetArrowPrizeList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
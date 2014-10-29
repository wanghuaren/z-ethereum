package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetArrowPrizeList2;

	public class PacketSCGetArrowPrizeListProcess extends PacketBaseProcess
	{
		public function PacketSCGetArrowPrizeListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetArrowPrizeList2=pack as PacketSCGetArrowPrizeList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
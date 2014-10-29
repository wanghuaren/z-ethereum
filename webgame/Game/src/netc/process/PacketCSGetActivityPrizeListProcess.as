package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetActivityPrizeList2;

	public class PacketCSGetActivityPrizeListProcess extends PacketBaseProcess
	{
		public function PacketCSGetActivityPrizeListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetActivityPrizeList2=pack as PacketCSGetActivityPrizeList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetGuildOnePrizeInfo2;

	public class PacketCSGetGuildOnePrizeInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetGuildOnePrizeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetGuildOnePrizeInfo2=pack as PacketCSGetGuildOnePrizeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
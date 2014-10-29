package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildOnePrizeInfo2;

	public class PacketSCGetGuildOnePrizeInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildOnePrizeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildOnePrizeInfo2=pack as PacketSCGetGuildOnePrizeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
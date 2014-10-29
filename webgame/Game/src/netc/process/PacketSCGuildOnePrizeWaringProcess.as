package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGuildOnePrizeWaring2;

	public class PacketSCGuildOnePrizeWaringProcess extends PacketBaseProcess
	{
		public function PacketSCGuildOnePrizeWaringProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGuildOnePrizeWaring2=pack as PacketSCGuildOnePrizeWaring2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
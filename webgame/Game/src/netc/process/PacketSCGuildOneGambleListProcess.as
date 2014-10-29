package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGuildOneGambleList2;

	public class PacketSCGuildOneGambleListProcess extends PacketBaseProcess
	{
		public function PacketSCGuildOneGambleListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGuildOneGambleList2=pack as PacketSCGuildOneGambleList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
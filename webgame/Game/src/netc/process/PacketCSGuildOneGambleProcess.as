package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildOneGamble2;

	public class PacketCSGuildOneGambleProcess extends PacketBaseProcess
	{
		public function PacketCSGuildOneGambleProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildOneGamble2=pack as PacketCSGuildOneGamble2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
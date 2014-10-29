package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildOneGambleList2;

	public class PacketCSGuildOneGambleListProcess extends PacketBaseProcess
	{
		public function PacketCSGuildOneGambleListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildOneGambleList2=pack as PacketCSGuildOneGambleList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
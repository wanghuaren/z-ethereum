package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryGuildMelee2;

	public class PacketCSEntryGuildMeleeProcess extends PacketBaseProcess
	{
		public function PacketCSEntryGuildMeleeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryGuildMelee2=pack as PacketCSEntryGuildMelee2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
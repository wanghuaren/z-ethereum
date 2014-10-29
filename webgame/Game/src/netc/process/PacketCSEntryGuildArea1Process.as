package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryGuildArea12;

	public class PacketCSEntryGuildArea1Process extends PacketBaseProcess
	{
		public function PacketCSEntryGuildArea1Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryGuildArea12=pack as PacketCSEntryGuildArea12;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
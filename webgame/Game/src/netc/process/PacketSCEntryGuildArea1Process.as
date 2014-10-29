package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEntryGuildArea12;

	public class PacketSCEntryGuildArea1Process extends PacketBaseProcess
	{
		public function PacketSCEntryGuildArea1Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEntryGuildArea12=pack as PacketSCEntryGuildArea12;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
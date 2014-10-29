package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCReadyEntryGuildArea12;

	public class PacketSCReadyEntryGuildArea1Process extends PacketBaseProcess
	{
		public function PacketSCReadyEntryGuildArea1Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReadyEntryGuildArea12=pack as PacketSCReadyEntryGuildArea12;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
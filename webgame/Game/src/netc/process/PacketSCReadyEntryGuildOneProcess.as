package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCReadyEntryGuildOne2;

	public class PacketSCReadyEntryGuildOneProcess extends PacketBaseProcess
	{
		public function PacketSCReadyEntryGuildOneProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReadyEntryGuildOne2=pack as PacketSCReadyEntryGuildOne2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
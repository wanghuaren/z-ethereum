package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCReadyEntryGuildGuard2;

	public class PacketSCReadyEntryGuildGuardProcess extends PacketBaseProcess
	{
		public function PacketSCReadyEntryGuildGuardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReadyEntryGuildGuard2=pack as PacketSCReadyEntryGuildGuard2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
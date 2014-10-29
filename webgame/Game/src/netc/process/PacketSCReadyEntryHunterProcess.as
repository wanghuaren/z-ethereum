package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCReadyEntryHunter2;

	public class PacketSCReadyEntryHunterProcess extends PacketBaseProcess
	{
		public function PacketSCReadyEntryHunterProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReadyEntryHunter2=pack as PacketSCReadyEntryHunter2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
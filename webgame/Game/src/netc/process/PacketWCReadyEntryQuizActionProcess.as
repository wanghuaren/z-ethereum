package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCReadyEntryQuizAction2;

	public class PacketWCReadyEntryQuizActionProcess extends PacketBaseProcess
	{
		public function PacketWCReadyEntryQuizActionProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCReadyEntryQuizAction2=pack as PacketWCReadyEntryQuizAction2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
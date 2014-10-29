package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCReadyEntrySSPK2;

	public class PacketSCReadyEntrySSPKProcess extends PacketBaseProcess
	{
		public function PacketSCReadyEntrySSPKProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReadyEntrySSPK2=pack as PacketSCReadyEntrySSPK2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
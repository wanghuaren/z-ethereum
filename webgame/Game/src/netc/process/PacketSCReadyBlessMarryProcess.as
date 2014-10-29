package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCReadyBlessMarry2;

	public class PacketSCReadyBlessMarryProcess extends PacketBaseProcess
	{
		public function PacketSCReadyBlessMarryProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReadyBlessMarry2=pack as PacketSCReadyBlessMarry2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
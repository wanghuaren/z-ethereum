package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCReadyMarryCar2;

	public class PacketSCReadyMarryCarProcess extends PacketBaseProcess
	{
		public function PacketSCReadyMarryCarProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReadyMarryCar2=pack as PacketSCReadyMarryCar2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
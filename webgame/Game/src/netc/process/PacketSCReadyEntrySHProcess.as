package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCReadyEntrySH2;
	
	public class PacketSCReadyEntrySHProcess extends PacketBaseProcess
	{
		public function PacketSCReadyEntrySHProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReadyEntrySH2=pack as PacketSCReadyEntrySH2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
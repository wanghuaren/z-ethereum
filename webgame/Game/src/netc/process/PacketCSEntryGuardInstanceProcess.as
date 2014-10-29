package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryGuardInstance2;

	public class PacketCSEntryGuardInstanceProcess extends PacketBaseProcess
	{
		public function PacketCSEntryGuardInstanceProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryGuardInstance2=pack as PacketCSEntryGuardInstance2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
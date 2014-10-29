package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEntryGuildOne2;

	public class PacketSCEntryGuildOneProcess extends PacketBaseProcess
	{
		public function PacketSCEntryGuildOneProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEntryGuildOne2=pack as PacketSCEntryGuildOne2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
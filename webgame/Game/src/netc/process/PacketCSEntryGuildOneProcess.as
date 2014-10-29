package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryGuildOne2;

	public class PacketCSEntryGuildOneProcess extends PacketBaseProcess
	{
		public function PacketCSEntryGuildOneProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryGuildOne2=pack as PacketCSEntryGuildOne2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryGuildGuard2;

	public class PacketCSEntryGuildGuardProcess extends PacketBaseProcess
	{
		public function PacketCSEntryGuildGuardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryGuildGuard2=pack as PacketCSEntryGuildGuard2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
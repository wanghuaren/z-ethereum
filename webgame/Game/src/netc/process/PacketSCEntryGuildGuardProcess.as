package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEntryGuildGuard2;

	public class PacketSCEntryGuildGuardProcess extends PacketBaseProcess
	{
		public function PacketSCEntryGuildGuardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEntryGuildGuard2=pack as PacketSCEntryGuildGuard2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSStartGuildGuard2;

	public class PacketCSStartGuildGuardProcess extends PacketBaseProcess
	{
		public function PacketCSStartGuildGuardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSStartGuildGuard2=pack as PacketCSStartGuildGuard2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
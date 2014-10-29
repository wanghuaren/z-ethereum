package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildBossPlayerList2;

	public class PacketCSGuildBossPlayerListProcess extends PacketBaseProcess
	{
		public function PacketCSGuildBossPlayerListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildBossPlayerList2=pack as PacketCSGuildBossPlayerList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
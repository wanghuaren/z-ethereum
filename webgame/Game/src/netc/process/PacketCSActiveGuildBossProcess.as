package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActiveGuildBoss2;

	public class PacketCSActiveGuildBossProcess extends PacketBaseProcess
	{
		public function PacketCSActiveGuildBossProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActiveGuildBoss2=pack as PacketCSActiveGuildBoss2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
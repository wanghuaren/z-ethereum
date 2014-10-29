package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetGuildBossTime2;

	public class PacketCSGetGuildBossTimeProcess extends PacketBaseProcess
	{
		public function PacketCSGetGuildBossTimeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetGuildBossTime2=pack as PacketCSGetGuildBossTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
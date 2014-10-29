package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSetGuildBossTime2;

	public class PacketCSSetGuildBossTimeProcess extends PacketBaseProcess
	{
		public function PacketCSSetGuildBossTimeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSetGuildBossTime2=pack as PacketCSSetGuildBossTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
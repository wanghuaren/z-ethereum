package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCCallGuildBoss2;

	public class PacketSCCallGuildBossProcess extends PacketBaseProcess
	{
		public function PacketSCCallGuildBossProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCCallGuildBoss2=pack as PacketSCCallGuildBoss2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildLevelUp2;

	public class PacketCSGuildLevelUpProcess extends PacketBaseProcess
	{
		public function PacketCSGuildLevelUpProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildLevelUp2=pack as PacketCSGuildLevelUp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
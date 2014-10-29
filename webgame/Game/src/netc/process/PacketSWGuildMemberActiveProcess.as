package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSWGuildMemberActive2;

	public class PacketSWGuildMemberActiveProcess extends PacketBaseProcess
	{
		public function PacketSWGuildMemberActiveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSWGuildMemberActive2=pack as PacketSWGuildMemberActive2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
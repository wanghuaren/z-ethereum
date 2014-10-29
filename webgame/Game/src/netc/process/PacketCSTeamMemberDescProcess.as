package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTeamMemberDesc2;

	public class PacketCSTeamMemberDescProcess extends PacketBaseProcess
	{
		public function PacketCSTeamMemberDescProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTeamMemberDesc2=pack as PacketCSTeamMemberDesc2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
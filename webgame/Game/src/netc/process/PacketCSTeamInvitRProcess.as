package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTeamInvitR2;

	public class PacketCSTeamInvitRProcess extends PacketBaseProcess
	{
		public function PacketCSTeamInvitRProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTeamInvitR2=pack as PacketCSTeamInvitR2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
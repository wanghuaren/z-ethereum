package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWSTeamMemberState2;

	public class PacketWSTeamMemberStateProcess extends PacketBaseProcess
	{
		public function PacketWSTeamMemberStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWSTeamMemberState2=pack as PacketWSTeamMemberState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
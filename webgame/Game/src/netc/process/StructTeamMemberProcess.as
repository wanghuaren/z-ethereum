package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructTeamMember2;

	public class StructTeamMemberProcess extends PacketBaseProcess
	{
		public function StructTeamMemberProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructTeamMember2=pack as StructTeamMember2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
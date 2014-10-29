package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWSTeamLeader2;

	public class PacketWSTeamLeaderProcess extends PacketBaseProcess
	{
		public function PacketWSTeamLeaderProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWSTeamLeader2=pack as PacketWSTeamLeader2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
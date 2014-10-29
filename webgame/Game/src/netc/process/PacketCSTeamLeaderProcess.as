package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTeamLeader2;

	public class PacketCSTeamLeaderProcess extends PacketBaseProcess
	{
		public function PacketCSTeamLeaderProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTeamLeader2=pack as PacketCSTeamLeader2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
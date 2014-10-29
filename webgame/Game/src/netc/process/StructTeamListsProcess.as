package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructTeamLists2;

	public class StructTeamListsProcess extends PacketBaseProcess
	{
		public function StructTeamListsProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructTeamLists2=pack as StructTeamLists2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
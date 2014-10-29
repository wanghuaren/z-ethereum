package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructTeamList2;

	public class StructTeamListProcess extends PacketBaseProcess
	{
		public function StructTeamListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructTeamList2=pack as StructTeamList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
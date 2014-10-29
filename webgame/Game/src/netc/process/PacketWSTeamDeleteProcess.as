package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWSTeamDelete2;

	public class PacketWSTeamDeleteProcess extends PacketBaseProcess
	{
		public function PacketWSTeamDeleteProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWSTeamDelete2=pack as PacketWSTeamDelete2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
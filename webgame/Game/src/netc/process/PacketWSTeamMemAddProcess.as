package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWSTeamMemAdd2;

	public class PacketWSTeamMemAddProcess extends PacketBaseProcess
	{
		public function PacketWSTeamMemAddProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWSTeamMemAdd2=pack as PacketWSTeamMemAdd2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
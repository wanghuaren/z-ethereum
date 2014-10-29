package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTeamMemDel2;

	public class PacketCSTeamMemDelProcess extends PacketBaseProcess
	{
		public function PacketCSTeamMemDelProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTeamMemDel2=pack as PacketCSTeamMemDel2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
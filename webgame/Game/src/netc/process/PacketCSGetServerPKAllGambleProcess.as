package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetServerPKAllGamble2;

	public class PacketCSGetServerPKAllGambleProcess extends PacketBaseProcess
	{
		public function PacketCSGetServerPKAllGambleProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetServerPKAllGamble2=pack as PacketCSGetServerPKAllGamble2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
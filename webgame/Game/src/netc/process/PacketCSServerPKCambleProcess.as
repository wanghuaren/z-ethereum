package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSServerPKCamble2;

	public class PacketCSServerPKCambleProcess extends PacketBaseProcess
	{
		public function PacketCSServerPKCambleProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSServerPKCamble2=pack as PacketCSServerPKCamble2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
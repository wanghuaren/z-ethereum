package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSIsGuildOneSign2;

	public class PacketCSIsGuildOneSignProcess extends PacketBaseProcess
	{
		public function PacketCSIsGuildOneSignProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSIsGuildOneSign2=pack as PacketCSIsGuildOneSign2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
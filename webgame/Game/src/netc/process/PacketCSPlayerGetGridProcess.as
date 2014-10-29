package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerGetGrid2;

	public class PacketCSPlayerGetGridProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerGetGridProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerGetGrid2=pack as PacketCSPlayerGetGrid2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
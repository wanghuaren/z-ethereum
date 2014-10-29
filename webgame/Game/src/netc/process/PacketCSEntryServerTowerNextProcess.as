package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryServerTowerNext2;

	public class PacketCSEntryServerTowerNextProcess extends PacketBaseProcess
	{
		public function PacketCSEntryServerTowerNextProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryServerTowerNext2=pack as PacketCSEntryServerTowerNext2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
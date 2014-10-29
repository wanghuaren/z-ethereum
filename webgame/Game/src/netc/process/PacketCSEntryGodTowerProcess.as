package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryGodTower2;

	public class PacketCSEntryGodTowerProcess extends PacketBaseProcess
	{
		public function PacketCSEntryGodTowerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryGodTower2=pack as PacketCSEntryGodTower2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
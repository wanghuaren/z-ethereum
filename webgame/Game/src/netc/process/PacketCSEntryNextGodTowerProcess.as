package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryNextGodTower2;

	public class PacketCSEntryNextGodTowerProcess extends PacketBaseProcess
	{
		public function PacketCSEntryNextGodTowerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryNextGodTower2=pack as PacketCSEntryNextGodTower2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
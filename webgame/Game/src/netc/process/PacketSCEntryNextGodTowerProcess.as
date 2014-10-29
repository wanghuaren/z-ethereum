package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEntryNextGodTower2;

	public class PacketSCEntryNextGodTowerProcess extends PacketBaseProcess
	{
		public function PacketSCEntryNextGodTowerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEntryNextGodTower2=pack as PacketSCEntryNextGodTower2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
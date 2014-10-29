package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCPlayerResetGodTower2;

	public class PacketSCPlayerResetGodTowerProcess extends PacketBaseProcess
	{
		public function PacketSCPlayerResetGodTowerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCPlayerResetGodTower2=pack as PacketSCPlayerResetGodTower2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
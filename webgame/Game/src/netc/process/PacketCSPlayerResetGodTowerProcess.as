package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerResetGodTower2;

	public class PacketCSPlayerResetGodTowerProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerResetGodTowerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerResetGodTower2=pack as PacketCSPlayerResetGodTower2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
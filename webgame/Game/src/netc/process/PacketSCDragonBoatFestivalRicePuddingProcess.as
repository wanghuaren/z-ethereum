package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDragonBoatFestivalRicePudding2;

	public class PacketSCDragonBoatFestivalRicePuddingProcess extends PacketBaseProcess
	{
		public function PacketSCDragonBoatFestivalRicePuddingProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDragonBoatFestivalRicePudding2=pack as PacketSCDragonBoatFestivalRicePudding2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
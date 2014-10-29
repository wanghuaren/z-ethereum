package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetDragonBoatFestivalPrize2;

	public class PacketCSGetDragonBoatFestivalPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetDragonBoatFestivalPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetDragonBoatFestivalPrize2=pack as PacketCSGetDragonBoatFestivalPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
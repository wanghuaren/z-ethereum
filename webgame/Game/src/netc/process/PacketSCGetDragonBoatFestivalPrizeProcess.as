package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetDragonBoatFestivalPrize2;

	public class PacketSCGetDragonBoatFestivalPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetDragonBoatFestivalPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetDragonBoatFestivalPrize2=pack as PacketSCGetDragonBoatFestivalPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
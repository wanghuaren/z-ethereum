package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetDragonBoatFestivalRank2;

	public class PacketCSGetDragonBoatFestivalRankProcess extends PacketBaseProcess
	{
		public function PacketCSGetDragonBoatFestivalRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetDragonBoatFestivalRank2=pack as PacketCSGetDragonBoatFestivalRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
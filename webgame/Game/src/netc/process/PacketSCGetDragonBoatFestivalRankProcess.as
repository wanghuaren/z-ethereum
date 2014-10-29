package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetDragonBoatFestivalRank2;

	public class PacketSCGetDragonBoatFestivalRankProcess extends PacketBaseProcess
	{
		public function PacketSCGetDragonBoatFestivalRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetDragonBoatFestivalRank2=pack as PacketSCGetDragonBoatFestivalRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
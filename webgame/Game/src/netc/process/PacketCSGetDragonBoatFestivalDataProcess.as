package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetDragonBoatFestivalData2;

	public class PacketCSGetDragonBoatFestivalDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetDragonBoatFestivalDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetDragonBoatFestivalData2=pack as PacketCSGetDragonBoatFestivalData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetDragonBoatFestivalData2;

	public class PacketSCGetDragonBoatFestivalDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetDragonBoatFestivalDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetDragonBoatFestivalData2=pack as PacketSCGetDragonBoatFestivalData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
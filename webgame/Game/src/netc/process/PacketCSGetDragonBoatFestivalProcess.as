package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetDragonBoatFestival2;

	public class PacketCSGetDragonBoatFestivalProcess extends PacketBaseProcess
	{
		public function PacketCSGetDragonBoatFestivalProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetDragonBoatFestival2=pack as PacketCSGetDragonBoatFestival2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
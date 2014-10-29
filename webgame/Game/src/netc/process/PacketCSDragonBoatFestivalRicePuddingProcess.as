package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDragonBoatFestivalRicePudding2;

	public class PacketCSDragonBoatFestivalRicePuddingProcess extends PacketBaseProcess
	{
		public function PacketCSDragonBoatFestivalRicePuddingProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDragonBoatFestivalRicePudding2=pack as PacketCSDragonBoatFestivalRicePudding2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
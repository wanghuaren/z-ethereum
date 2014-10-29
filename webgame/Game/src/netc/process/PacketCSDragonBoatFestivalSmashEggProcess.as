package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDragonBoatFestivalSmashEgg2;

	public class PacketCSDragonBoatFestivalSmashEggProcess extends PacketBaseProcess
	{
		public function PacketCSDragonBoatFestivalSmashEggProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDragonBoatFestivalSmashEgg2=pack as PacketCSDragonBoatFestivalSmashEgg2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
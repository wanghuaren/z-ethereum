package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetNationalDayGift2;

	public class PacketCSGetNationalDayGiftProcess extends PacketBaseProcess
	{
		public function PacketCSGetNationalDayGiftProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetNationalDayGift2=pack as PacketCSGetNationalDayGift2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
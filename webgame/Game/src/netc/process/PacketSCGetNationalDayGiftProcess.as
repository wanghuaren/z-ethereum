package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetNationalDayGift2;

	public class PacketSCGetNationalDayGiftProcess extends PacketBaseProcess
	{
		public function PacketSCGetNationalDayGiftProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetNationalDayGift2=pack as PacketSCGetNationalDayGift2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
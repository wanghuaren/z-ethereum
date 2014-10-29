package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSBuyNationBeautyTimes2;

	public class PacketCSBuyNationBeautyTimesProcess extends PacketBaseProcess
	{
		public function PacketCSBuyNationBeautyTimesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSBuyNationBeautyTimes2=pack as PacketCSBuyNationBeautyTimes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
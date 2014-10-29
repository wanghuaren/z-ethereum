package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCBuyNationBeautyTimes2;

	public class PacketSCBuyNationBeautyTimesProcess extends PacketBaseProcess
	{
		public function PacketSCBuyNationBeautyTimesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCBuyNationBeautyTimes2=pack as PacketSCBuyNationBeautyTimes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
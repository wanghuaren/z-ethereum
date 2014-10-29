package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetBuyNationBeautyTimes2;

	public class PacketCSGetBuyNationBeautyTimesProcess extends PacketBaseProcess
	{
		public function PacketCSGetBuyNationBeautyTimesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetBuyNationBeautyTimes2=pack as PacketCSGetBuyNationBeautyTimes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
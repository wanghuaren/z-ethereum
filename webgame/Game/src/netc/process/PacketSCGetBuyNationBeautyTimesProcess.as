package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetBuyNationBeautyTimes2;

	public class PacketSCGetBuyNationBeautyTimesProcess extends PacketBaseProcess
	{
		public function PacketSCGetBuyNationBeautyTimesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetBuyNationBeautyTimes2=pack as PacketSCGetBuyNationBeautyTimes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
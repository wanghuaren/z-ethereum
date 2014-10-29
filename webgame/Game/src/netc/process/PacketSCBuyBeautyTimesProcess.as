package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCBuyBeautyTimes2;

	public class PacketSCBuyBeautyTimesProcess extends PacketBaseProcess
	{
		public function PacketSCBuyBeautyTimesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCBuyBeautyTimes2=pack as PacketSCBuyBeautyTimes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
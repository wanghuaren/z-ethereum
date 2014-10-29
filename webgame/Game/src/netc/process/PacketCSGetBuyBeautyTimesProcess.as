package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetBuyBeautyTimes2;

	public class PacketCSGetBuyBeautyTimesProcess extends PacketBaseProcess
	{
		public function PacketCSGetBuyBeautyTimesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetBuyBeautyTimes2=pack as PacketCSGetBuyBeautyTimes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
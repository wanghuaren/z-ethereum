package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetBuyBeautyTimes2;

	public class PacketSCGetBuyBeautyTimesProcess extends PacketBaseProcess
	{
		public function PacketSCGetBuyBeautyTimesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetBuyBeautyTimes2=pack as PacketSCGetBuyBeautyTimes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
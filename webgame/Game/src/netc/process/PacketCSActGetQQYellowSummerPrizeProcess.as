package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetQQYellowSummerPrize2;

	public class PacketCSActGetQQYellowSummerPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSActGetQQYellowSummerPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetQQYellowSummerPrize2=pack as PacketCSActGetQQYellowSummerPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
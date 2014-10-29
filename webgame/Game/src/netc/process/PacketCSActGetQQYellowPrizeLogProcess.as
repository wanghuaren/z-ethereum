package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetQQYellowPrizeLog2;

	public class PacketCSActGetQQYellowPrizeLogProcess extends PacketBaseProcess
	{
		public function PacketCSActGetQQYellowPrizeLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetQQYellowPrizeLog2=pack as PacketCSActGetQQYellowPrizeLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGameVipTypePrize2;

	public class PacketSCGameVipTypePrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGameVipTypePrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGameVipTypePrize2=pack as PacketSCGameVipTypePrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
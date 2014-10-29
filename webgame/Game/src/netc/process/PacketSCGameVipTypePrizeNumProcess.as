package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGameVipTypePrizeNum2;

	public class PacketSCGameVipTypePrizeNumProcess extends PacketBaseProcess
	{
		public function PacketSCGameVipTypePrizeNumProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGameVipTypePrizeNum2=pack as PacketSCGameVipTypePrizeNum2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
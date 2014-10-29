package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetVipLevelPrize2;

	public class PacketCSGetVipLevelPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetVipLevelPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetVipLevelPrize2=pack as PacketCSGetVipLevelPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
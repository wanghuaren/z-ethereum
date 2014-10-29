package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetWifeOnlineTimePrize2;

	public class PacketCSGetWifeOnlineTimePrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetWifeOnlineTimePrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetWifeOnlineTimePrize2=pack as PacketCSGetWifeOnlineTimePrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
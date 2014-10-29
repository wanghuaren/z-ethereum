package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetFirstPayPrize2;

	public class PacketCSGetFirstPayPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetFirstPayPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetFirstPayPrize2=pack as PacketCSGetFirstPayPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetFirstPayPrize2;

	public class PacketSCGetFirstPayPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetFirstPayPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetFirstPayPrize2=pack as PacketSCGetFirstPayPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
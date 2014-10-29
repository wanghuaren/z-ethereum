package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCSoarExpExchang2;

	public class PacketSCSoarExpExchangProcess extends PacketBaseProcess
	{
		public function PacketSCSoarExpExchangProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCSoarExpExchang2=pack as PacketSCSoarExpExchang2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
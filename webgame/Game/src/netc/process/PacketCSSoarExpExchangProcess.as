package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSoarExpExchang2;

	public class PacketCSSoarExpExchangProcess extends PacketBaseProcess
	{
		public function PacketCSSoarExpExchangProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSoarExpExchang2=pack as PacketCSSoarExpExchang2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
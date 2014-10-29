package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSExchangeCDKey2;

	public class PacketCSExchangeCDKeyProcess extends PacketBaseProcess
	{
		public function PacketCSExchangeCDKeyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSExchangeCDKey2=pack as PacketCSExchangeCDKey2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
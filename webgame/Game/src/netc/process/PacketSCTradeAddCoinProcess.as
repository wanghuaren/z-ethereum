package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTradeAddCoin2;

	public class PacketSCTradeAddCoinProcess extends PacketBaseProcess
	{
		public function PacketSCTradeAddCoinProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTradeAddCoin2=pack as PacketSCTradeAddCoin2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
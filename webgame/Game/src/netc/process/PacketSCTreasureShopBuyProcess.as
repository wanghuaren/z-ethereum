package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTreasureShopBuy2;

	public class PacketSCTreasureShopBuyProcess extends PacketBaseProcess
	{
		public function PacketSCTreasureShopBuyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTreasureShopBuy2=pack as PacketSCTreasureShopBuy2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
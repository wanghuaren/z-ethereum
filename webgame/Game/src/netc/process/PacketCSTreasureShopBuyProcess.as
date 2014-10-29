package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTreasureShopBuy2;

	public class PacketCSTreasureShopBuyProcess extends PacketBaseProcess
	{
		public function PacketCSTreasureShopBuyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTreasureShopBuy2=pack as PacketCSTreasureShopBuy2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
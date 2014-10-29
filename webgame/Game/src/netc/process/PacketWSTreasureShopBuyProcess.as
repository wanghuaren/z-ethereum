package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWSTreasureShopBuy2;

	public class PacketWSTreasureShopBuyProcess extends PacketBaseProcess
	{
		public function PacketWSTreasureShopBuyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWSTreasureShopBuy2=pack as PacketWSTreasureShopBuy2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
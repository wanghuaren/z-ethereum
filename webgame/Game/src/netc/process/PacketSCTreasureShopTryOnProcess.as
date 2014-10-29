package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTreasureShopTryOn2;

	public class PacketSCTreasureShopTryOnProcess extends PacketBaseProcess
	{
		public function PacketSCTreasureShopTryOnProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTreasureShopTryOn2=pack as PacketSCTreasureShopTryOn2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
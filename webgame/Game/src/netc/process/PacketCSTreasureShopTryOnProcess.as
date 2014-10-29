package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTreasureShopTryOn2;

	public class PacketCSTreasureShopTryOnProcess extends PacketBaseProcess
	{
		public function PacketCSTreasureShopTryOnProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTreasureShopTryOn2=pack as PacketCSTreasureShopTryOn2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
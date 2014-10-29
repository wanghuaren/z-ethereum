package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTreasureShopQuery2;

	public class PacketCSTreasureShopQueryProcess extends PacketBaseProcess
	{
		public function PacketCSTreasureShopQueryProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTreasureShopQuery2=pack as PacketCSTreasureShopQuery2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
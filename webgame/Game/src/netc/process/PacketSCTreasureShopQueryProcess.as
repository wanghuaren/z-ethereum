package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTreasureShopQuery2;

	public class PacketSCTreasureShopQueryProcess extends PacketBaseProcess
	{
		public function PacketSCTreasureShopQueryProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTreasureShopQuery2=pack as PacketSCTreasureShopQuery2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
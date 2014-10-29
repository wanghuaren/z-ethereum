package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildGetShopItem2;

	public class PacketCSGuildGetShopItemProcess extends PacketBaseProcess
	{
		public function PacketCSGuildGetShopItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildGetShopItem2=pack as PacketCSGuildGetShopItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
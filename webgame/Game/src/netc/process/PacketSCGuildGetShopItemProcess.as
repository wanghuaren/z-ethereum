package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGuildGetShopItem2;

	public class PacketSCGuildGetShopItemProcess extends PacketBaseProcess
	{
		public function PacketSCGuildGetShopItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGuildGetShopItem2=pack as PacketSCGuildGetShopItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
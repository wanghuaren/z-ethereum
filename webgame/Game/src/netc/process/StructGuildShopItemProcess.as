package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructGuildShopItem2;

	public class StructGuildShopItemProcess extends PacketBaseProcess
	{
		public function StructGuildShopItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructGuildShopItem2=pack as StructGuildShopItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructRmbShopItem2;

	public class StructRmbShopItemProcess extends PacketBaseProcess
	{
		public function StructRmbShopItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructRmbShopItem2=pack as StructRmbShopItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
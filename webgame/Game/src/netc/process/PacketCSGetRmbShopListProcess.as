package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetRmbShopList2;

	public class PacketCSGetRmbShopListProcess extends PacketBaseProcess
	{
		public function PacketCSGetRmbShopListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetRmbShopList2=pack as PacketCSGetRmbShopList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSItemBuyDiscount2;

	public class PacketCSItemBuyDiscountProcess extends PacketBaseProcess
	{
		public function PacketCSItemBuyDiscountProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSItemBuyDiscount2=pack as PacketCSItemBuyDiscount2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
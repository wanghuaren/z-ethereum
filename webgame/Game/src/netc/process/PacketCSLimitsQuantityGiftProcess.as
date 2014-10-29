package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSLimitsQuantityGift2;

	public class PacketCSLimitsQuantityGiftProcess extends PacketBaseProcess
	{
		public function PacketCSLimitsQuantityGiftProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSLimitsQuantityGift2=pack as PacketCSLimitsQuantityGift2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
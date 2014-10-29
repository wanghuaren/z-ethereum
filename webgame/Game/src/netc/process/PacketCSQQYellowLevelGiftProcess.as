package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSQQYellowLevelGift2;

	public class PacketCSQQYellowLevelGiftProcess extends PacketBaseProcess
	{
		public function PacketCSQQYellowLevelGiftProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSQQYellowLevelGift2=pack as PacketCSQQYellowLevelGift2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
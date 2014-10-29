package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSQQYellowLevelGiftState2;

	public class PacketCSQQYellowLevelGiftStateProcess extends PacketBaseProcess
	{
		public function PacketCSQQYellowLevelGiftStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSQQYellowLevelGiftState2=pack as PacketCSQQYellowLevelGiftState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
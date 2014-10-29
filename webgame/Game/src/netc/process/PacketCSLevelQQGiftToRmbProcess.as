package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSLevelQQGiftToRmb2;

	public class PacketCSLevelQQGiftToRmbProcess extends PacketBaseProcess
	{
		public function PacketCSLevelQQGiftToRmbProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSLevelQQGiftToRmb2=pack as PacketCSLevelQQGiftToRmb2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
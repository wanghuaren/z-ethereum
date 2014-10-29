package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSQQInviteGiftState2;

	public class PacketCSQQInviteGiftStateProcess extends PacketBaseProcess
	{
		public function PacketCSQQInviteGiftStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSQQInviteGiftState2=pack as PacketCSQQInviteGiftState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
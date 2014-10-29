package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSQQInviteSuccess2;

	public class PacketCSQQInviteSuccessProcess extends PacketBaseProcess
	{
		public function PacketCSQQInviteSuccessProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSQQInviteSuccess2=pack as PacketCSQQInviteSuccess2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
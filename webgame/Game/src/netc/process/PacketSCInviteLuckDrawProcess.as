package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCInviteLuckDraw2;

	public class PacketSCInviteLuckDrawProcess extends PacketBaseProcess
	{
		public function PacketSCInviteLuckDrawProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCInviteLuckDraw2=pack as PacketSCInviteLuckDraw2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
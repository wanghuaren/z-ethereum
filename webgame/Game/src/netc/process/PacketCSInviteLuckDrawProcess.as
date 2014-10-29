package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSInviteLuckDraw2;

	public class PacketCSInviteLuckDrawProcess extends PacketBaseProcess
	{
		public function PacketCSInviteLuckDrawProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSInviteLuckDraw2=pack as PacketCSInviteLuckDraw2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
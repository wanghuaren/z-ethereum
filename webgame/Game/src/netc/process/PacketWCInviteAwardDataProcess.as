package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCInviteAwardData2;

	public class PacketWCInviteAwardDataProcess extends PacketBaseProcess
	{
		public function PacketWCInviteAwardDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCInviteAwardData2=pack as PacketWCInviteAwardData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
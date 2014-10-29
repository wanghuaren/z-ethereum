package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWInviteAwardData2;

	public class PacketCWInviteAwardDataProcess extends PacketBaseProcess
	{
		public function PacketCWInviteAwardDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWInviteAwardData2=pack as PacketCWInviteAwardData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
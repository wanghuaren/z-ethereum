package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSWInviteAwardData2;

	public class PacketSWInviteAwardDataProcess extends PacketBaseProcess
	{
		public function PacketSWInviteAwardDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSWInviteAwardData2=pack as PacketSWInviteAwardData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
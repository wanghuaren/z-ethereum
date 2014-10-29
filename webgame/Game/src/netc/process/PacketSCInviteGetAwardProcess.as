package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCInviteGetAward2;

	public class PacketSCInviteGetAwardProcess extends PacketBaseProcess
	{
		public function PacketSCInviteGetAwardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCInviteGetAward2=pack as PacketSCInviteGetAward2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
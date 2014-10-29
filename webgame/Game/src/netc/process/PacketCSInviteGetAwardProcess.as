package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSInviteGetAward2;

	public class PacketCSInviteGetAwardProcess extends PacketBaseProcess
	{
		public function PacketCSInviteGetAwardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSInviteGetAward2=pack as PacketCSInviteGetAward2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
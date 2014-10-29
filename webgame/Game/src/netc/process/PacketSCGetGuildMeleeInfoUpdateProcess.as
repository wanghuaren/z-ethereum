package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildMeleeInfoUpdate2;

	public class PacketSCGetGuildMeleeInfoUpdateProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildMeleeInfoUpdateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildMeleeInfoUpdate2=pack as PacketSCGetGuildMeleeInfoUpdate2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
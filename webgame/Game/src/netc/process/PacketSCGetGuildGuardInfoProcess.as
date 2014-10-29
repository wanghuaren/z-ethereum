package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildGuardInfo2;

	public class PacketSCGetGuildGuardInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildGuardInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildGuardInfo2=pack as PacketSCGetGuildGuardInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
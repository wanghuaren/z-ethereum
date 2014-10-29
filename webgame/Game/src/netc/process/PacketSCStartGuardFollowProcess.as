package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCStartGuardFollow2;

	public class PacketSCStartGuardFollowProcess extends PacketBaseProcess
	{
		public function PacketSCStartGuardFollowProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCStartGuardFollow2=pack as PacketSCStartGuardFollow2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
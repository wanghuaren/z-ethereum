package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCStopGuardFollow2;

	public class PacketSCStopGuardFollowProcess extends PacketBaseProcess
	{
		public function PacketSCStopGuardFollowProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCStopGuardFollow2=pack as PacketSCStopGuardFollow2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSStopGuardFollow2;

	public class PacketCSStopGuardFollowProcess extends PacketBaseProcess
	{
		public function PacketCSStopGuardFollowProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSStopGuardFollow2=pack as PacketCSStopGuardFollow2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
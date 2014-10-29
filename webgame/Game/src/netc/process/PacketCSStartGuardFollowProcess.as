package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSStartGuardFollow2;

	public class PacketCSStartGuardFollowProcess extends PacketBaseProcess
	{
		public function PacketCSStartGuardFollowProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSStartGuardFollow2=pack as PacketCSStartGuardFollow2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
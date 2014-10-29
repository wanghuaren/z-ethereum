package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetServerPKSelfInfo2;

	public class PacketCSGetServerPKSelfInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetServerPKSelfInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetServerPKSelfInfo2=pack as PacketCSGetServerPKSelfInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
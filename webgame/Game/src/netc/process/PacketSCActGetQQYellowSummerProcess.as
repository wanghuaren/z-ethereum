package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCActGetQQYellowSummer2;

	public class PacketSCActGetQQYellowSummerProcess extends PacketBaseProcess
	{
		public function PacketSCActGetQQYellowSummerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCActGetQQYellowSummer2=pack as PacketSCActGetQQYellowSummer2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
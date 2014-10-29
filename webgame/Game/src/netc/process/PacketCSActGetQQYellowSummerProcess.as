package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetQQYellowSummer2;

	public class PacketCSActGetQQYellowSummerProcess extends PacketBaseProcess
	{
		public function PacketCSActGetQQYellowSummerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetQQYellowSummer2=pack as PacketCSActGetQQYellowSummer2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
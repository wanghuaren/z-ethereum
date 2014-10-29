package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCActGetQQYellowSummerData2;

	public class PacketSCActGetQQYellowSummerDataProcess extends PacketBaseProcess
	{
		public function PacketSCActGetQQYellowSummerDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCActGetQQYellowSummerData2=pack as PacketSCActGetQQYellowSummerData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
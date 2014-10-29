package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetQQYellowData2;

	public class PacketCSActGetQQYellowDataProcess extends PacketBaseProcess
	{
		public function PacketCSActGetQQYellowDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetQQYellowData2=pack as PacketCSActGetQQYellowData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
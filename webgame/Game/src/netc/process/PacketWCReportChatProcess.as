package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCReportChat2;

	public class PacketWCReportChatProcess extends PacketBaseProcess
	{
		public function PacketWCReportChatProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCReportChat2=pack as PacketWCReportChat2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
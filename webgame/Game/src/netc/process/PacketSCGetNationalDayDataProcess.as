package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetNationalDayData2;

	public class PacketSCGetNationalDayDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetNationalDayDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetNationalDayData2=pack as PacketSCGetNationalDayData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
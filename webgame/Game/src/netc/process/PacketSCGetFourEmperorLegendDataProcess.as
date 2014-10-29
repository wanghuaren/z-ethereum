package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetFourEmperorLegendData2;

	public class PacketSCGetFourEmperorLegendDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetFourEmperorLegendDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetFourEmperorLegendData2=pack as PacketSCGetFourEmperorLegendData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
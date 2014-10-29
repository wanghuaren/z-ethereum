package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetFourEmperorLegendData2;

	public class PacketCSGetFourEmperorLegendDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetFourEmperorLegendDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetFourEmperorLegendData2=pack as PacketCSGetFourEmperorLegendData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
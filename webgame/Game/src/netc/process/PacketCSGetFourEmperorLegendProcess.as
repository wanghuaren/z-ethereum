package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetFourEmperorLegend2;

	public class PacketCSGetFourEmperorLegendProcess extends PacketBaseProcess
	{
		public function PacketCSGetFourEmperorLegendProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetFourEmperorLegend2=pack as PacketCSGetFourEmperorLegend2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetFourEmperorLegendDo2;

	public class PacketCSGetFourEmperorLegendDoProcess extends PacketBaseProcess
	{
		public function PacketCSGetFourEmperorLegendDoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetFourEmperorLegendDo2=pack as PacketCSGetFourEmperorLegendDo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
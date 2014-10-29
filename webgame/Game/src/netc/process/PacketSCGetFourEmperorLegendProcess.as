package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetFourEmperorLegend2;

	public class PacketSCGetFourEmperorLegendProcess extends PacketBaseProcess
	{
		public function PacketSCGetFourEmperorLegendProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetFourEmperorLegend2=pack as PacketSCGetFourEmperorLegend2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetCityKingInfo2;

	public class PacketCSGetCityKingInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetCityKingInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetCityKingInfo2=pack as PacketCSGetCityKingInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
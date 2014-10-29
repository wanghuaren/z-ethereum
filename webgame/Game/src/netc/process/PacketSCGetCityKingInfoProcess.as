package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetCityKingInfo2;

	public class PacketSCGetCityKingInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetCityKingInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetCityKingInfo2=pack as PacketSCGetCityKingInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
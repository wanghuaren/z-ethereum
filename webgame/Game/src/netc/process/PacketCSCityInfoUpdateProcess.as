package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSCityInfoUpdate2;

	public class PacketCSCityInfoUpdateProcess extends PacketBaseProcess
	{
		public function PacketCSCityInfoUpdateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSCityInfoUpdate2=pack as PacketCSCityInfoUpdate2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
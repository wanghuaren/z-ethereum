package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetWorldCupData2;

	public class PacketCSGetWorldCupDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetWorldCupDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetWorldCupData2=pack as PacketCSGetWorldCupData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
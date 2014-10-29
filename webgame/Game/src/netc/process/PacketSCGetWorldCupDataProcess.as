package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetWorldCupData2;

	public class PacketSCGetWorldCupDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetWorldCupDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetWorldCupData2=pack as PacketSCGetWorldCupData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetMidAutumnPrizeData2;

	public class PacketSCGetMidAutumnPrizeDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetMidAutumnPrizeDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetMidAutumnPrizeData2=pack as PacketSCGetMidAutumnPrizeData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
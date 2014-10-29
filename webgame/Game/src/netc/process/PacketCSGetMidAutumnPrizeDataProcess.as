package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetMidAutumnPrizeData2;

	public class PacketCSGetMidAutumnPrizeDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetMidAutumnPrizeDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetMidAutumnPrizeData2=pack as PacketCSGetMidAutumnPrizeData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
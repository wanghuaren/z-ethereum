package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructOnlinePrizeData2;

	public class StructOnlinePrizeDataProcess extends PacketBaseProcess
	{
		public function StructOnlinePrizeDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructOnlinePrizeData2=pack as StructOnlinePrizeData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
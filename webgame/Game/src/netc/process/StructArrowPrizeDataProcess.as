package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructArrowPrizeData2;

	public class StructArrowPrizeDataProcess extends PacketBaseProcess
	{
		public function StructArrowPrizeDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructArrowPrizeData2=pack as StructArrowPrizeData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
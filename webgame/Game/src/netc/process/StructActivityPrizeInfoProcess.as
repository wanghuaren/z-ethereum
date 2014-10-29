package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructActivityPrizeInfo2;

	public class StructActivityPrizeInfoProcess extends PacketBaseProcess
	{
		public function StructActivityPrizeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructActivityPrizeInfo2=pack as StructActivityPrizeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
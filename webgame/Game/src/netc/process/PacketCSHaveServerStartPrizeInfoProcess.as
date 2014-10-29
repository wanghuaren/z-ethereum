package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSHaveServerStartPrizeInfo2;

	public class PacketCSHaveServerStartPrizeInfoProcess extends PacketBaseProcess
	{
		public function PacketCSHaveServerStartPrizeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSHaveServerStartPrizeInfo2=pack as PacketCSHaveServerStartPrizeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
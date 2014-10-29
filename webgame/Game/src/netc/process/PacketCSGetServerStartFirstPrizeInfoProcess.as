package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetServerStartFirstPrizeInfo2;

	public class PacketCSGetServerStartFirstPrizeInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetServerStartFirstPrizeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetServerStartFirstPrizeInfo2=pack as PacketCSGetServerStartFirstPrizeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
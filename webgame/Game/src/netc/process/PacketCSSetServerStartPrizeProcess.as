package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSetServerStartPrize2;

	public class PacketCSSetServerStartPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSSetServerStartPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSetServerStartPrize2=pack as PacketCSSetServerStartPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
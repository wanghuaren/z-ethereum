package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSHPrize2;

	public class PacketCSGetSHPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetSHPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSHPrize2=pack as PacketCSGetSHPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
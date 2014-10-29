package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetGodBlessPrize2;

	public class PacketCSGetGodBlessPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetGodBlessPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetGodBlessPrize2=pack as PacketCSGetGodBlessPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGodBlessPrize2;

	public class PacketSCGetGodBlessPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetGodBlessPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGodBlessPrize2=pack as PacketSCGetGodBlessPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
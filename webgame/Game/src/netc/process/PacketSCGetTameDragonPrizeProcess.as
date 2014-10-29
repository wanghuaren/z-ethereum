package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetTameDragonPrize2;

	public class PacketSCGetTameDragonPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetTameDragonPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetTameDragonPrize2=pack as PacketSCGetTameDragonPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetTameDragonPrize2;

	public class PacketCSGetTameDragonPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetTameDragonPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetTameDragonPrize2=pack as PacketCSGetTameDragonPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
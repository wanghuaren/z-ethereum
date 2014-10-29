package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetContinueLoginPrize2;

	public class PacketCSGetContinueLoginPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetContinueLoginPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetContinueLoginPrize2=pack as PacketCSGetContinueLoginPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
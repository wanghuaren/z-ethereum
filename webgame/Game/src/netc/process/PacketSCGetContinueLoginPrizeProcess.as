package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetContinueLoginPrize2;

	public class PacketSCGetContinueLoginPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetContinueLoginPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetContinueLoginPrize2=pack as PacketSCGetContinueLoginPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
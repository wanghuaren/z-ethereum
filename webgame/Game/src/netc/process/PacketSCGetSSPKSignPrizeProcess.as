package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetSSPKSignPrize2;

	public class PacketSCGetSSPKSignPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetSSPKSignPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSSPKSignPrize2=pack as PacketSCGetSSPKSignPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
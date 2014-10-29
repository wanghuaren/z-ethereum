package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSSPKSignPrize2;

	public class PacketCSGetSSPKSignPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSGetSSPKSignPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSSPKSignPrize2=pack as PacketCSGetSSPKSignPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
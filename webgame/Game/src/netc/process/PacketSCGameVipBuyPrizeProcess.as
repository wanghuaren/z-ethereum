package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import netc.packets2.PacketSCGameVipBuyPrize2;
	
	public class PacketSCGameVipBuyPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGameVipBuyPrizeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGameVipBuyPrize2=pack as PacketSCGameVipBuyPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
		
		
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import netc.packets2.PacketSCGetVipLevelPrize2;
	
	public class PacketSCGetVipLevelPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetVipLevelPrizeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetVipLevelPrize2=pack as PacketSCGetVipLevelPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
		
	}
}
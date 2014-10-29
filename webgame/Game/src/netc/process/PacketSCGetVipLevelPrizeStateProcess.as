package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import netc.packets2.PacketSCGetVipLevelPrizeState2;
	
	public class PacketSCGetVipLevelPrizeStateProcess extends PacketBaseProcess
	{
		public function PacketSCGetVipLevelPrizeStateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetVipLevelPrizeState2=pack as PacketSCGetVipLevelPrizeState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
	
	
}
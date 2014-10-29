package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCQQYellowLevelGift2;
	
	import flash.utils.getQualifiedClassName;
	
	import engine.support.IPacket;
	
	public class PacketSCQQYellowLevelGiftProcess extends PacketBaseProcess
	{
		
		public function PacketSCQQYellowLevelGiftProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketSCQQYellowLevelGift2 = pack as PacketSCQQYellowLevelGift2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
	}
}
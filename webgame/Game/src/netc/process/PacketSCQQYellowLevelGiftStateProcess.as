package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCQQYellowLevelGiftState2;
	
	import flash.utils.getQualifiedClassName;
	
	import engine.support.IPacket;
	
	public class PacketSCQQYellowLevelGiftStateProcess extends PacketBaseProcess
	{
		public function PacketSCQQYellowLevelGiftStateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketSCQQYellowLevelGiftState2 = pack as PacketSCQQYellowLevelGiftState2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
	}
}
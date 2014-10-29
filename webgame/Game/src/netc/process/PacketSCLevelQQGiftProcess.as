package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCLevelQQGift2;
	
	import engine.support.IPacket;
	
	public class PacketSCLevelQQGiftProcess extends PacketBaseProcess
	{
		public function PacketSCLevelQQGiftProcess()
		{
			super();
		}
		
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCLevelQQGift2 = pack as PacketSCLevelQQGift2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
		
	}
}
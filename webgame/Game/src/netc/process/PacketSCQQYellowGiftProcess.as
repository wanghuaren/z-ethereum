package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCQQYellowGift2;
	
	
	import flash.utils.getQualifiedClassName;
	
	
	import engine.support.IPacket;
	
	public class PacketSCQQYellowGiftProcess extends PacketBaseProcess
	{
		public function PacketSCQQYellowGiftProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketSCQQYellowGift2 = pack as PacketSCQQYellowGift2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
	}
}
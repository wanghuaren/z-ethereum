package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCLevelQQGiftToRmb2;
	
	import engine.support.IPacket;
	
	public class PacketSCLevelQQGiftToRmbProcess extends PacketBaseProcess
	{
		public function PacketSCLevelQQGiftToRmbProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			
			//step 1
			var p:PacketSCLevelQQGiftToRmb2 = pack as PacketSCLevelQQGiftToRmb2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
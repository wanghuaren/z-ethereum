package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketWCGuildPrize2;
	
	public class PacketWCGuildPrizeProcess extends PacketBaseProcess
	{
		public function PacketWCGuildPrizeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWCGuildPrize2 = pack as PacketWCGuildPrize2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			Data.bangPai.syncGuildPrize(p);
			
			return p;
		}
		
		
	}
}
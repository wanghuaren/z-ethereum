package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCNewCard2;
	
	public class PacketSCNewCardProcess extends PacketBaseProcess
	{
		public function PacketSCNewCardProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCNewCard2 = pack as PacketSCNewCard2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			//Data.cangJingGe.syncNewCard(p);
			
			return p;
		}
		
		
	}
}
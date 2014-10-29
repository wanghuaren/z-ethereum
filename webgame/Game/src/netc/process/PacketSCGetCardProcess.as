package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCGetCard2;
	
	public class PacketSCGetCardProcess extends PacketBaseProcess
	{
		public function PacketSCGetCardProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCGetCard2 = pack as PacketSCGetCard2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			//Data.cangJingGe.syncGetCard(p);
			
			return p;
		}
	}
}
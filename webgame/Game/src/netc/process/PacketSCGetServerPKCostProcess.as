package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetServerPKCost2;
	
	import engine.support.IPacket;
	
	public class PacketSCGetServerPKCostProcess extends PacketBaseProcess
	{
		public function PacketSCGetServerPKCostProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCGetServerPKCost2 = pack as PacketSCGetServerPKCost2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
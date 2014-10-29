package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetServerStartFirstPrizeInfo2;
	
	import engine.support.IPacket;
	
	public class PacketSCGetServerStartFirstPrizeInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetServerStartFirstPrizeInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCGetServerStartFirstPrizeInfo2 = pack as PacketSCGetServerStartFirstPrizeInfo2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			//DataCenter.packZone.put(p.GetId(),p);
			
			return p;
		}
	}
}
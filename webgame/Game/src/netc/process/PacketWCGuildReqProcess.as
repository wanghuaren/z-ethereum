package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketWCGuildReq2;
	
	public class PacketWCGuildReqProcess extends PacketBaseProcess
	{
		public function PacketWCGuildReqProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWCGuildReq2 = pack as PacketWCGuildReq2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			Data.bangPai.syncGuildReq(p);
			
			return p;
		}
	}
}
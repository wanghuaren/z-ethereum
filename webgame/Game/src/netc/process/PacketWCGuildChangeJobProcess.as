package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketWCGuildChangeJob2;
	
	public class PacketWCGuildChangeJobProcess extends PacketBaseProcess
	{
		public function PacketWCGuildChangeJobProcess()
		{
			super();
		}
		
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketWCGuildChangeJob2 = pack as PacketWCGuildChangeJob2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2
			Data.bangPai.syncGuildChangeJob(p);
			
			return p;
		}
	}
}
package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketWCGuildTreeOp2;
	
	public class PacketWCGuildTreeOpProcess extends PacketBaseProcess
	{
		public function PacketWCGuildTreeOpProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWCGuildTreeOp2 = pack as PacketWCGuildTreeOp2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
			Data.bangPai.syncGuildTreeOp(p);
			
			return p;
		}
		
		
	}
}
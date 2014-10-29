package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketWCGuildTreeDrop2;
	
	public class PacketWCGuildTreeDropProcess extends PacketBaseProcess
	{
		public function PacketWCGuildTreeDropProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketWCGuildTreeDrop2 = pack as PacketWCGuildTreeDrop2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
			Data.bangPai.syncGuildTreeDrop(p);
			
			return p;
		}
	}
}


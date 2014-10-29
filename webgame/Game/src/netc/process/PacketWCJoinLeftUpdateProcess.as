package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCJoinLeftUpdate2;
	
	import engine.support.IPacket;
	
	public class PacketWCJoinLeftUpdateProcess extends PacketBaseProcess
	{
		public function PacketWCJoinLeftUpdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWCJoinLeftUpdate2 = pack as PacketWCJoinLeftUpdate2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
	}
}


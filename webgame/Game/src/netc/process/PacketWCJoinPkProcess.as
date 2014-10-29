package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCJoinPk2;
	
	import engine.support.IPacket;
	
	public class PacketWCJoinPkProcess extends PacketBaseProcess
	{
		public function PacketWCJoinPkProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketWCJoinPk2 = pack as PacketWCJoinPk2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSWCurServerPkInfo2;
	
	import engine.support.IPacket;
	
	public class PacketSWCurServerPkInfoProcess extends PacketBaseProcess
	{
		public function PacketSWCurServerPkInfoProcess()
		{
			super();
		}
		
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketSWCurServerPkInfo2 = pack as PacketSWCurServerPkInfo2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
	}
}
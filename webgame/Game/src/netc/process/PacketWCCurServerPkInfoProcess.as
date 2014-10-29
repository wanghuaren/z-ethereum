package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCCurServerPkInfo2;
	
	import engine.support.IPacket;
	
	public class PacketWCCurServerPkInfoProcess extends PacketBaseProcess
	{
		public function PacketWCCurServerPkInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWCCurServerPkInfo2 = pack as PacketWCCurServerPkInfo2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
	}
}
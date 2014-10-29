package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWSCurServerPkInfo2;
	
	import engine.support.IPacket;
	
	public class PacketWSCurServerPkInfoProcess extends PacketBaseProcess
	{
		public function PacketWSCurServerPkInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWSCurServerPkInfo2 = pack as PacketWSCurServerPkInfo2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
	}
}
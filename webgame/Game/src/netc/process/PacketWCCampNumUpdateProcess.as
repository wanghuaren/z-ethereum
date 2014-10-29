package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCCampNumUpdate2;
	
	import engine.support.IPacket;
	
	public class PacketWCCampNumUpdateProcess extends PacketBaseProcess
	{
		public function PacketWCCampNumUpdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWCCampNumUpdate2 = pack as PacketWCCampNumUpdate2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
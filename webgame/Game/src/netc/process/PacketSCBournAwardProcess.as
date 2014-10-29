package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCBournAward2;
	
	import engine.support.IPacket;
	
	public class PacketSCBournAwardProcess extends PacketBaseProcess
	{
		public function PacketSCBournAwardProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{			
			//step 1
			var p:PacketSCBournAward2 = pack as PacketSCBournAward2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2	
		
			return p;
		}
	}
}
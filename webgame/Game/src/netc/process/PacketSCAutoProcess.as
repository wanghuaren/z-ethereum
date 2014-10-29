package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCAuto2;
	
	import engine.support.IPacket;
	
	public class PacketSCAutoProcess extends PacketBaseProcess
	{
		public function PacketSCAutoProcess()
		{
			//TODO: implement function
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			
			//step 1
			var p:PacketSCAuto2 = pack as PacketSCAuto2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
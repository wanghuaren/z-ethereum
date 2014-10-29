package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	
	import engine.support.IPacket;
	import netc.packets2.PacketSCSetAutoConfig2;
	
	public class PacketSCSetAutoConfigProcess extends PacketBaseProcess
	{
		public function PacketSCSetAutoConfigProcess()
		{
			//TODO: implement function
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCSetAutoConfig2 = pack as PacketSCSetAutoConfig2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
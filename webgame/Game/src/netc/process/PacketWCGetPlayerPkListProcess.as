package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCGetPlayerPkList2;
	
	import engine.support.IPacket;
	
	public class PacketWCGetPlayerPkListProcess extends PacketBaseProcess
	{
		public function PacketWCGetPlayerPkListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWCGetPlayerPkList2 = pack as PacketWCGetPlayerPkList2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWSSetMapGroupEnd2;
	
	import engine.support.IPacket;
	
	public class PacketWSSetMapGroupEndProcess extends PacketBaseProcess
	{
		public function PacketWSSetMapGroupEndProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketWSSetMapGroupEnd2 = pack as PacketWSSetMapGroupEnd2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
	}
}
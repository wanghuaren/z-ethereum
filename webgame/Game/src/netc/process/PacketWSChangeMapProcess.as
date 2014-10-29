package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWSChangeMap2;
	
	import engine.support.IPacket;
	
	public class PacketWSChangeMapProcess extends PacketBaseProcess
	{
		public function PacketWSChangeMapProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketWSChangeMap2 = pack as PacketWSChangeMap2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
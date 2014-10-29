package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSWMapNumUpdate2;
	
	import engine.support.IPacket;
	
	public class PacketSWMapNumUpdateProcess extends PacketBaseProcess
	{
		public function PacketSWMapNumUpdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSWMapNumUpdate2 = pack as PacketSWMapNumUpdate2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
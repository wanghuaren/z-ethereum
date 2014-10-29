package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSWGetCDKeyInfo2;
	
	public class PacketSWGetCDKeyInfoProcess extends PacketBaseProcess
	{
		public function PacketSWGetCDKeyInfoProcess()
		{
			super();
		}
		override public function process(pack:IPacket):IPacket
		{
			
			var p:PacketSWGetCDKeyInfo2 = pack as PacketSWGetCDKeyInfo2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}

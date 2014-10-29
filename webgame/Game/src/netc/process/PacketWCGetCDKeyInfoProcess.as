package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketWCGetCDKeyInfo2;
	
	public class PacketWCGetCDKeyInfoProcess extends PacketBaseProcess
	{
		public function PacketWCGetCDKeyInfoProcess()
		{
			super();
		}
		override public function process(pack:IPacket):IPacket
		{
			
			var p:PacketWCGetCDKeyInfo2 = pack as PacketWCGetCDKeyInfo2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}

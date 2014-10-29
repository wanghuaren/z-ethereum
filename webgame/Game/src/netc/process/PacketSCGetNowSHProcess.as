package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCGetNowSH2;
	
	public class PacketSCGetNowSHProcess extends PacketBaseProcess
	{
		public function PacketSCGetNowSHProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetNowSH2=pack as PacketSCGetNowSH2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
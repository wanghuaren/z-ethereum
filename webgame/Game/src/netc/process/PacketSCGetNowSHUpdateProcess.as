package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCGetNowSHUpdate2;
	
	public class PacketSCGetNowSHUpdateProcess extends PacketBaseProcess
	{
		public function PacketSCGetNowSHUpdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetNowSHUpdate2=pack as PacketSCGetNowSHUpdate2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
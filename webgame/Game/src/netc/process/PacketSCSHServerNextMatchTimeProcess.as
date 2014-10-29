package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCSHServerNextMatchTime2;
	
	public class PacketSCSHServerNextMatchTimeProcess extends PacketBaseProcess
	{
		public function PacketSCSHServerNextMatchTimeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCSHServerNextMatchTime2=pack as PacketSCSHServerNextMatchTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}



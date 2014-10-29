package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCSHMatchUpdate2;
	
	public class PacketSCSHMatchUpdateProcess extends PacketBaseProcess
	{
		public function PacketSCSHMatchUpdateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCSHMatchUpdate2=pack as PacketSCSHMatchUpdate2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
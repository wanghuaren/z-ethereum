package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCSHAllFightMsg2;
	
	public class PacketSCSHAllFightMsgProcess extends PacketBaseProcess
	{
		public function PacketSCSHAllFightMsgProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCSHAllFightMsg2=pack as PacketSCSHAllFightMsg2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
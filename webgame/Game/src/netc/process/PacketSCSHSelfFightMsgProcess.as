package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCSHSelfFightMsg2;
	
	public class PacketSCSHSelfFightMsgProcess extends PacketBaseProcess
	{
		public function PacketSCSHSelfFightMsgProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCSHSelfFightMsg2=pack as PacketSCSHSelfFightMsg2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
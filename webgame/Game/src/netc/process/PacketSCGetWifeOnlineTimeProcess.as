package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetWifeOnlineTime2;

	public class PacketSCGetWifeOnlineTimeProcess extends PacketBaseProcess
	{
		public function PacketSCGetWifeOnlineTimeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetWifeOnlineTime2=pack as PacketSCGetWifeOnlineTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
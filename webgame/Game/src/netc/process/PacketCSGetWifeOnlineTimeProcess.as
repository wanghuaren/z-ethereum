package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetWifeOnlineTime2;

	public class PacketCSGetWifeOnlineTimeProcess extends PacketBaseProcess
	{
		public function PacketCSGetWifeOnlineTimeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetWifeOnlineTime2=pack as PacketCSGetWifeOnlineTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
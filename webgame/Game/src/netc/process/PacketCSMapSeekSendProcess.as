package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSMapSeekSend2;

	public class PacketCSMapSeekSendProcess extends PacketBaseProcess
	{
		public function PacketCSMapSeekSendProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSMapSeekSend2=pack as PacketCSMapSeekSend2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
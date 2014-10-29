package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSBoothSendAdvert2;

	public class PacketCSBoothSendAdvertProcess extends PacketBaseProcess
	{
		public function PacketCSBoothSendAdvertProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSBoothSendAdvert2=pack as PacketCSBoothSendAdvert2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
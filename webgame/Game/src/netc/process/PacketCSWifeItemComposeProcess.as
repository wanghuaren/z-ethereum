package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSWifeItemCompose2;

	public class PacketCSWifeItemComposeProcess extends PacketBaseProcess
	{
		public function PacketCSWifeItemComposeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSWifeItemCompose2=pack as PacketCSWifeItemCompose2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
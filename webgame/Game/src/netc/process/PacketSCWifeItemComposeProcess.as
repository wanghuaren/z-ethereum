package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCWifeItemCompose2;

	public class PacketSCWifeItemComposeProcess extends PacketBaseProcess
	{
		public function PacketSCWifeItemComposeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCWifeItemCompose2=pack as PacketSCWifeItemCompose2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
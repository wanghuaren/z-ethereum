package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryPKOneAction2;

	public class PacketCSEntryPKOneActionProcess extends PacketBaseProcess
	{
		public function PacketCSEntryPKOneActionProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryPKOneAction2=pack as PacketCSEntryPKOneAction2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
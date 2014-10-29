package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryDoubleExpInstance2;

	public class PacketCSEntryDoubleExpInstanceProcess extends PacketBaseProcess
	{
		public function PacketCSEntryDoubleExpInstanceProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryDoubleExpInstance2=pack as PacketCSEntryDoubleExpInstance2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryQuizAction2;

	public class PacketCSEntryQuizActionProcess extends PacketBaseProcess
	{
		public function PacketCSEntryQuizActionProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryQuizAction2=pack as PacketCSEntryQuizAction2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
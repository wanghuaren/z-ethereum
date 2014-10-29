package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSShortKeyCodeSet2;

	public class PacketCSShortKeyCodeSetProcess extends PacketBaseProcess
	{
		public function PacketCSShortKeyCodeSetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSShortKeyCodeSet2=pack as PacketCSShortKeyCodeSet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
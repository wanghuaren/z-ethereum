package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSHeavenBookCurInfo2;

	public class PacketCSHeavenBookCurInfoProcess extends PacketBaseProcess
	{
		public function PacketCSHeavenBookCurInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSHeavenBookCurInfo2=pack as PacketCSHeavenBookCurInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
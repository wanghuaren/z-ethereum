package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCHeavenBookCurInfo2;

	public class PacketSCHeavenBookCurInfoProcess extends PacketBaseProcess
	{
		public function PacketSCHeavenBookCurInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCHeavenBookCurInfo2=pack as PacketSCHeavenBookCurInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
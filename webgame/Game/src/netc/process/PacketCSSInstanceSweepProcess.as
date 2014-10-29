package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSInstanceSweep2;

	public class PacketCSSInstanceSweepProcess extends PacketBaseProcess
	{
		public function PacketCSSInstanceSweepProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSInstanceSweep2=pack as PacketCSSInstanceSweep2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
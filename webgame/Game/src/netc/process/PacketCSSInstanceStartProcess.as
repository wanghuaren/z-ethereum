package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSInstanceStart2;

	public class PacketCSSInstanceStartProcess extends PacketBaseProcess
	{
		public function PacketCSSInstanceStartProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSInstanceStart2=pack as PacketCSSInstanceStart2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
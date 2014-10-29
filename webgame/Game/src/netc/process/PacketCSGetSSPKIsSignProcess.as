package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSSPKIsSign2;

	public class PacketCSGetSSPKIsSignProcess extends PacketBaseProcess
	{
		public function PacketCSGetSSPKIsSignProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSSPKIsSign2=pack as PacketCSGetSSPKIsSign2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
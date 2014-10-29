package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetSSPKIsSign2;

	public class PacketSCGetSSPKIsSignProcess extends PacketBaseProcess
	{
		public function PacketSCGetSSPKIsSignProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSSPKIsSign2=pack as PacketSCGetSSPKIsSign2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGemDown2;

	public class PacketSCGemDownProcess extends PacketBaseProcess
	{
		public function PacketSCGemDownProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGemDown2=pack as PacketSCGemDown2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCQueryCanPick2;

	public class PacketSCQueryCanPickProcess extends PacketBaseProcess
	{
		public function PacketSCQueryCanPickProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCQueryCanPick2=pack as PacketSCQueryCanPick2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
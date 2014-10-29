package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSQueryCanPick2;

	public class PacketCSQueryCanPickProcess extends PacketBaseProcess
	{
		public function PacketCSQueryCanPickProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSQueryCanPick2=pack as PacketCSQueryCanPick2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
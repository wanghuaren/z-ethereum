package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSLeaveSpa2;

	public class PacketCSLeaveSpaProcess extends PacketBaseProcess
	{
		public function PacketCSLeaveSpaProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSLeaveSpa2=pack as PacketCSLeaveSpa2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
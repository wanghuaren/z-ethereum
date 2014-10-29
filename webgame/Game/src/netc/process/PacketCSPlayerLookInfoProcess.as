package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerLookInfo2;

	public class PacketCSPlayerLookInfoProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerLookInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerLookInfo2=pack as PacketCSPlayerLookInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
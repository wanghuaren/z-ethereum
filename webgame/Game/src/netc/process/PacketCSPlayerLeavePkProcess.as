package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerLeavePk2;

	public class PacketCSPlayerLeavePkProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerLeavePkProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerLeavePk2=pack as PacketCSPlayerLeavePk2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
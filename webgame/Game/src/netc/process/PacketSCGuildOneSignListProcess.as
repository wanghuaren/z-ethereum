package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGuildOneSignList2;

	public class PacketSCGuildOneSignListProcess extends PacketBaseProcess
	{
		public function PacketSCGuildOneSignListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGuildOneSignList2=pack as PacketSCGuildOneSignList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
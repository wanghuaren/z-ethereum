package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildOneGambleSort2;

	public class PacketSCGetGuildOneGambleSortProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildOneGambleSortProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildOneGambleSort2=pack as PacketSCGetGuildOneGambleSort2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
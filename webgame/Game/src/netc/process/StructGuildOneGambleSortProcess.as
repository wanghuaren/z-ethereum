package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructGuildOneGambleSort2;

	public class StructGuildOneGambleSortProcess extends PacketBaseProcess
	{
		public function StructGuildOneGambleSortProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructGuildOneGambleSort2=pack as StructGuildOneGambleSort2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
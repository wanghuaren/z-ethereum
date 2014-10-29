package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructHorseList2;

	public class StructHorseListProcess extends PacketBaseProcess
	{
		public function StructHorseListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructHorseList2=pack as StructHorseList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructTaskList2;

	public class StructTaskListProcess extends PacketBaseProcess
	{
		public function StructTaskListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructTaskList2=pack as StructTaskList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructDBTaskList2;

	public class StructDBTaskListProcess extends PacketBaseProcess
	{
		public function StructDBTaskListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructDBTaskList2=pack as StructDBTaskList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
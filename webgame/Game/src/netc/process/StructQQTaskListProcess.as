package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructQQTaskList2;

	public class StructQQTaskListProcess extends PacketBaseProcess
	{
		public function StructQQTaskListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructQQTaskList2=pack as StructQQTaskList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
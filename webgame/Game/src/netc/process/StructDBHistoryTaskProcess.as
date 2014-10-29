package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructDBHistoryTask2;

	public class StructDBHistoryTaskProcess extends PacketBaseProcess
	{
		public function StructDBHistoryTaskProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructDBHistoryTask2=pack as StructDBHistoryTask2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructHoistoryTask2;

	public class StructHoistoryTaskProcess extends PacketBaseProcess
	{
		public function StructHoistoryTaskProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructHoistoryTask2=pack as StructHoistoryTask2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructDragonPulseList2;

	public class StructDragonPulseListProcess extends PacketBaseProcess
	{
		public function StructDragonPulseListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructDragonPulseList2=pack as StructDragonPulseList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
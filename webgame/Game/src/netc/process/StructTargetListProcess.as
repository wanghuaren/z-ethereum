package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructTargetList2;

	public class StructTargetListProcess extends PacketBaseProcess
	{
		public function StructTargetListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructTargetList2=pack as StructTargetList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
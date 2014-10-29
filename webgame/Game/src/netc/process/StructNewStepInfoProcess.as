package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructNewStepInfo2;

	public class StructNewStepInfoProcess extends PacketBaseProcess
	{
		public function StructNewStepInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructNewStepInfo2=pack as StructNewStepInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
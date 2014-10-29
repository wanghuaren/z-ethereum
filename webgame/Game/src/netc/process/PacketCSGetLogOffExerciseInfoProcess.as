package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetLogOffExerciseInfo2;

	public class PacketCSGetLogOffExerciseInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetLogOffExerciseInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetLogOffExerciseInfo2=pack as PacketCSGetLogOffExerciseInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetLogOffExerciseExp2;

	public class PacketCSGetLogOffExerciseExpProcess extends PacketBaseProcess
	{
		public function PacketCSGetLogOffExerciseExpProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetLogOffExerciseExp2=pack as PacketCSGetLogOffExerciseExp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructExercise2;

	public class StructExerciseProcess extends PacketBaseProcess
	{
		public function StructExerciseProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructExercise2=pack as StructExercise2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}